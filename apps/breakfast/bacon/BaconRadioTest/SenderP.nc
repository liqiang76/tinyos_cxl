/*
 * Copyright (c) 2014 Johns Hopkins University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "bacon_radio_test.h"

module SenderP {
  uses interface Boot;
  uses interface Leds;

  uses interface SplitControl;
  uses interface AMSend as RadioSend;
  uses interface Packet as RadioPacket;
  uses interface Rf1aPacket;
  uses interface HplMsp430Rf1aIf as Rf1aIf;

  uses interface CC1190;
  uses interface StdControl as CC1190Control;

  uses interface SplitControl as SerialSplitControl;
  uses interface AMSend as ReportSend;
  uses interface Packet as SerialPacket;
  
  uses interface Timer<TMilli> as SendTimer;

} implementation {
  //This is: -12 dbm, -6 dbm, 0 dbm, 10 dbm
  uint8_t powerLevels[] = {0x25, 0x2D, 0x8D, 0xC3};

  #ifndef TX_POWER
    #define TX_POWER 0
    #warning "Undefined TX power, using 0 dbm"
  #endif

  #if TX_POWER == -12
  uint8_t patable_0 = 0x25;
  #elif TX_POWER == -6
  uint8_t patable_0 = 0x2D;
  #elif TX_POWER == 0
  uint8_t patable_0 = 0x8D;
  #elif TX_POWER == 10
  uint8_t patable_0 = 0xC3;
  #else 
  #error "unrecognized TX_POWER! valid entries are -12, -6, 0, and 10" 
  uint8_t patable_0 = 0xff;
  #endif

  event void Boot.booted(){
    call SplitControl.start();
  }

  event void SplitControl.startDone(error_t err){
    call SerialSplitControl.start();
  }

  void initCC1190(){
    //0 dbm
    call CC1190Control.start();
    call CC1190.TXMode(HGM_ENABLED);
  }

  event void SerialSplitControl.startDone(error_t err){
    initCC1190();
    call Rf1aIf.writeSinglePATable(patable_0);
    //OK, ready to send
    call SendTimer.startOneShot(SEND_INTERVAL);
  }

  message_t rmsg;
  uint32_t sn = 0;

  bool sending = FALSE;

  event void SendTimer.fired(){
    test_payload_t* pl = (test_payload_t*)(call RadioPacket.getPayload(&rmsg, sizeof(test_payload_t)));
    if (sending){
      call Leds.set(0x7);
      return;
    }
    sending = TRUE;
    sn++;
    pl -> node_id = TOS_NODE_ID;
    pl -> sn = sn;
    pl -> powerLevel = TX_POWER;
    pl -> hgm = HGM_ENABLED;
    call RadioSend.send(AM_BROADCAST_ADDR, &rmsg, sizeof(test_payload_t));
  }

  task void reportTx();
  event void RadioSend.sendDone(message_t* msg, error_t err){
    post reportTx();
  }

  message_t smsg;
  task void reportTx(){
    report_t* rpt = (report_t*)(call SerialPacket.getPayload(&smsg, sizeof(report_t)));
    rpt->node_id = TOS_NODE_ID;
    rpt->sn = sn;
    rpt->powerLevel = TX_POWER;
    rpt->hgmTx = HGM_ENABLED;
    rpt->hgmRx = 0;
    rpt->rssi = 0;
    rpt->lqi = 0;
    call ReportSend.send(AM_BROADCAST_ADDR, &smsg, sizeof(report_t));
  }

  event void ReportSend.sendDone(message_t* msg, error_t err){
    sending = FALSE;
    call Leds.led0Toggle();
    call SendTimer.startOneShot(SEND_INTERVAL);
  }

  event void SplitControl.stopDone(error_t err){}
  event void SerialSplitControl.stopDone(error_t err){}
}
