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


 #include "CXRoutingDebug.h"
module CXRoutingTableLastP {
  provides interface RoutingTable;
  uses interface Boot;
} implementation {
  uint8_t defaultDistance = CX_MAX_DEPTH;
  uint8_t evictionIndex = 0;

  typedef struct rt_entry {
    am_addr_t src;
    am_addr_t dest;
    uint8_t distance;
    uint8_t age;

    //this is for LSO usage. remove1 indicates if we have 
    //decided to remove this node from forwarding set 
    //of session src->dest from packet_sn == rm1_sn.
    // remove2 and rm2_sn for session dest->src. 
    bool removed1;
    bool removed2;
    uint32_t rm1_sn;
    uint32_t rm2_sn;
  } rt_entry_t;
  
  //3 entries is minimum: end-to-end plus segment lengths
  #define RT_LEN 10
  rt_entry_t rt[RT_LEN];

  event void Boot.booted(){
    uint8_t i;
    for (i = 0; i < RT_LEN; i++){
      rt[i].src = AM_BROADCAST_ADDR;
      rt[i].dest = AM_BROADCAST_ADDR;
      rt[i].age = 0xFF;
      rt[i].removed1 = FALSE;
      rt[i].rm1_sn = 0;
      rt[i].removed2 = FALSE;
      rt[i].rm2_sn = 0;
     }
  }
  
  command uint8_t RoutingTable.getDistance(am_addr_t from, 
      am_addr_t to, bool use_optm)
  {
    if (to == AM_BROADCAST_ADDR){
      return defaultDistance;
    } else if (from == to){
      return 0;
    } else {
      uint8_t i;
      for (i = 0; i < RT_LEN; i++)
      {
        if (!use_optm)
        {
          if ((from == rt[i].src && to == rt[i].dest) 
              || (from == rt[i].dest && to == rt[i].src)){
            return rt[i].distance;
          }
        } 
        else
        {
          if (from == rt[i].src && to == rt[i].dest)
          {
            if (rt[i].removed1)
              return 255;
            else
              return rt[i].distance;
          }
          else if (to == rt[i].src && from == rt[i].dest)
          {
            if (rt[i].removed2)
              return 255;
            else
              return rt[i].distance;
          }
        }
      }
      cdbg(ROUTING, "DD %u %u\r\n", from, to);
      return defaultDistance;
    }
  }


  //After packet with sn is sent, we decide not to involve
  // this session any longer
  command error_t RoutingTable.leaveForwardSet(am_addr_t from, am_addr_t to, int32_t sn)
  {
    uint8_t i;

    if(to == AM_BROADCAST_ADDR)
      return EINVAL;

    for (i=0; i<RT_LEN; i++)
    {
      if((rt[i].src == from) && (rt[i].dest == to))
      {
        rt[i].removed1 = TRUE;
        rt[i].rm1_sn = sn;
        return SUCCESS;
      }
      else if((rt[i].src == to) && (rt[i].dest == from))
      {
        rt[i].removed2 = TRUE;
        rt[i].rm2_sn = sn;
        return SUCCESS;
      }
    }

    return FAIL;
  }

  command error_t RoutingTable.returnForwardSet(am_addr_t from, am_addr_t to, int32_t sn)
  {
    uint8_t i;

    if(to == AM_BROADCAST_ADDR)
      return EINVAL;

    for (i=0; i<RT_LEN; i++)
    {
      if((rt[i].src == from) && (rt[i].dest == to))
      {
        if(rt[i].rm1_sn >= sn)
        {
          rt[i].removed1 = FALSE;
          rt[i].rm1_sn = 0;
          return SUCCESS;
        }
        break;
      }
    }

    return FAIL;
  }

  command error_t RoutingTable.addMeasurement(am_addr_t from, 
      am_addr_t to, uint8_t distance){
    uint8_t i;
    uint8_t oldest=0;
    uint8_t maxAge=0;

    cdbg(ROUTING, "DUA");
    //age up each entry
    for (i=0; i < RT_LEN; i++){
      if (rt[i].age + 1 != 0){
        rt[i].age ++;
      }
      cdbg(ROUTING, " (%u %u) %u",
        rt[i].src, rt[i].dest, rt[i].age);
      if (rt[i].age > maxAge || rt[i].src==AM_BROADCAST_ADDR || rt[i].dest == AM_BROADCAST_ADDR){
        maxAge = rt[i].age;
        oldest = i;
        cdbg(ROUTING, "*");
      }
    }

    cdbg(ROUTING, "DAM %u %u %u:",
      from, to, distance);
    //find matching entry and update/zero age
    for(i=0; i < RT_LEN; i++){
      cdbg(ROUTING, " (%u %u)", rt[i].src, rt[i].dest);
      if ((from == rt[i].src && to == rt[i].dest) 
          || (from == rt[i].dest && to == rt[i].src)){
        cdbg(ROUTING, "*\r\n");
        rt[i].src = from;
        rt[i].dest = to;
        rt[i].distance = distance;
        rt[i].age = 0;
        return SUCCESS;
      }
    }

    cdbg(ROUTING, "\r\n");
    cdbg(ROUTING, "DE %u (%u %u)\r\n",
      oldest,
      rt[oldest].src,
      rt[oldest].dest);

    //replace the oldest entry
    rt[oldest].src = from;
    rt[oldest].dest = to;
    rt[oldest].distance = distance;
    rt[oldest].age = 0;
    rt[oldest].removed1 = FALSE;
    rt[oldest].rm1_sn = 0;
    rt[oldest].removed2 = FALSE;
    rt[oldest].rm2_sn = 0;

    return SUCCESS;
  }

  command error_t RoutingTable.setDefault(uint8_t distance){
    defaultDistance = distance;
    return SUCCESS;
  }
  command uint8_t RoutingTable.getDefault(){
    return defaultDistance;
  }
}
