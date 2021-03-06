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

#include "I2CTLVStorage.h"

module I2CTLVStorageP{
  uses interface TLVStorage;
  uses interface TLVUtils;
  uses interface I2CComSlave;
} implementation {

  void debugTLV(void* tlvs_){
    tlv_entry_t* e;
    uint8_t offset = 0;
    uint8_t i;
    do{
      offset = call TLVUtils.findEntry(TAG_ANY, offset+1, &e, tlvs_);
      if (e != NULL){
        printf("------------\n\r");
        printf(" Offset: %d\n\r", offset);
        printf(" Tag:\t[%d]\t%x\n\r", offset, e->tag);
        printf(" Len:\t[%d]\t%x\n\r", offset+1, e->len);
        if (e->tag != TAG_EMPTY){
        printf(" Data:\n\r");
        for (i = 0; i < e->len; i++){
          printf("  [%d]\t(%d)\t%x\n\r", offset+2+i, i, e->data.b[i]);
        }
        }else{
          printf("  [%d]->[%d] (empty)\n\r", offset+2,
          offset+2+e->len-1);
        }
      }
    } while( offset != 0);
  }

  i2c_message_t msg_internal;
  norace i2c_message_t* msg = &msg_internal;

  i2c_message_t* swap(i2c_message_t* msg_){
    i2c_message_t* swp = msg;
    msg = msg_;
    return swp;
  }

  async event i2c_message_t* I2CComSlave.slaveTXStart(i2c_message_t* msg_){
    P6OUT |= BIT0;
    P6OUT &= ~BIT0;
    return swap(msg_);
  }

  task void readTask(){
    error_t error;
    i2c_tlv_storage_t* tlvs = 
      (i2c_tlv_storage_t*) call I2CComSlave.getPayload(msg);
    tlvs->cmd = TLV_STORAGE_RESPONSE_CMD;
    error = call TLVStorage.loadTLVStorage(tlvs->data);
//    printf("%s: %s\n\r", __FUNCTION__, decodeError(error));
    call I2CComSlave.unpause();
  }

  task void writeTask(){
    error_t error;
    i2c_tlv_storage_t* tlvs = 
      (i2c_tlv_storage_t*) call I2CComSlave.getPayload(msg);
    error = call TLVStorage.persistTLVStorage(tlvs->data);
    call I2CComSlave.unpause();
  }

  async event i2c_message_t* I2CComSlave.received(i2c_message_t* msg_){
    i2c_tlv_storage_t* payload = 
      (i2c_tlv_storage_t*) call I2CComSlave.getPayload(msg_);

    switch ( payload->cmd ){
      case TLV_STORAGE_WRITE_CMD:
        call I2CComSlave.pause();
        post writeTask();
        return swap(msg_);
      case TLV_STORAGE_READ_CMD:
        call I2CComSlave.pause();
        post readTask();
        return msg_;
      default:
        printf("unknown command\n\r");
        return msg_;
    }
  }

}
