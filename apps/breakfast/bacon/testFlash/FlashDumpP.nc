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

module FlashDumpP{
  provides interface FlashDump;
  uses interface Resource;
  uses interface Stm25pSpi;
} implementation {
  #define BPL 16
  uint8_t db[BPL];
  stm25p_addr_t de;
  stm25p_addr_t cur;
  task void readNext();

  command void FlashDump.dump(stm25p_addr_t start, stm25p_addr_t end){
    call Resource.request();
    cur = start;
    de = end;
  }

  event void Resource.granted(){
    call Stm25pSpi.powerUp();
    post readNext();
  }

  task void readNext(){
    error_t error = call Stm25pSpi.read(cur, db, BPL);
    if (SUCCESS != error){
      printf("Read err: %x\r\n", error);
    }
  }

  async event void Stm25pSpi.readDone( stm25p_addr_t addr, uint8_t* buf, stm25p_len_t len, 
		       error_t error ){
    if (error == SUCCESS){
      uint8_t i;
      printf("%lx", addr);
      for (i = 0; i < len; i++){
        printf(" %2X", buf[i]);
      }
      printf("\r\n");
      cur += len;
      if (cur < de){
        post readNext();
      }else{
        call Resource.release();
      }
    }else{
      printf("rd err: %x\r\n", error);
    }
  }

  async event void Stm25pSpi.pageProgramDone( stm25p_addr_t addr, uint8_t* buf, stm25p_len_t len, 
			error_t error ){}
  async event void Stm25pSpi.sectorEraseDone( uint8_t sector, error_t error ){}
  async event void Stm25pSpi.bulkEraseDone( error_t error){}

  async event void Stm25pSpi.computeCrcDone( uint16_t crc, stm25p_addr_t addr, stm25p_len_t len, 
			     error_t error ){}
}
