#!/usr/bin/env python

# Copyright (c) 2014 Johns Hopkins University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# - Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the
#   distribution.
# - Neither the name of the copyright holders nor the names of
#   its contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
# THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'CxLppWakeup'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 4

# The Active Message type associated with this message.
AM_TYPE = 198

class CxLppWakeup(tinyos.message.Message.Message):
    # Create a new CxLppWakeup of size 4.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=4):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <CxLppWakeup> \n"
        try:
            s += "  [timeout=0x%x]\n" % (self.get_timeout())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: timeout
    #   Field type: long
    #   Offset (bits): 0
    #   Size (bits): 32
    #

    #
    # Return whether the field 'timeout' is signed (False).
    #
    def isSigned_timeout(self):
        return False
    
    #
    # Return whether the field 'timeout' is an array (False).
    #
    def isArray_timeout(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'timeout'
    #
    def offset_timeout(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'timeout'
    #
    def offsetBits_timeout(self):
        return 0
    
    #
    # Return the value (as a long) of the field 'timeout'
    #
    def get_timeout(self):
        return self.getUIntElement(self.offsetBits_timeout(), 32, 1)
    
    #
    # Set the value of the field 'timeout'
    #
    def set_timeout(self, value):
        self.setUIntElement(self.offsetBits_timeout(), 32, value, 1)
    
    #
    # Return the size, in bytes, of the field 'timeout'
    #
    def size_timeout(self):
        return (32 / 8)
    
    #
    # Return the size, in bits, of the field 'timeout'
    #
    def sizeBits_timeout(self):
        return 32
    
