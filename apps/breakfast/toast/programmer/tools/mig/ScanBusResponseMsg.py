#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'ScanBusResponseMsg'
# message type.
#

from tools.tinyos.Message import Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 2

# The Active Message type associated with this message.
AM_TYPE = 145

class ScanBusResponseMsg(Message):
    # Create a new ScanBusResponseMsg of size 2.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=2):
        Message.__init__(self, data, addr, gid, base_offset, data_length)
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
        s = "Message <ScanBusResponseMsg> \n"
        try:
            s += "  [error=0x%x]\n" % (self.get_error())
        except:
            pass
        try:
            s += "  [numFound=0x%x]\n" % (self.get_numFound())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: error
    #   Field type: short
    #   Offset (bits): 0
    #   Size (bits): 8
    #

    #
    # Return whether the field 'error' is signed (False).
    #
    def isSigned_error(self):
        return False
    
    #
    # Return whether the field 'error' is an array (False).
    #
    def isArray_error(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'error'
    #
    def offset_error(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'error'
    #
    def offsetBits_error(self):
        return 0
    
    #
    # Return the value (as a short) of the field 'error'
    #
    def get_error(self):
        return self.getUIntElement(self.offsetBits_error(), 8, 1)
    
    #
    # Set the value of the field 'error'
    #
    def set_error(self, value):
        self.setUIntElement(self.offsetBits_error(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'error'
    #
    def size_error(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'error'
    #
    def sizeBits_error(self):
        return 8
    
    #
    # Accessor methods for field: numFound
    #   Field type: short
    #   Offset (bits): 8
    #   Size (bits): 8
    #

    #
    # Return whether the field 'numFound' is signed (False).
    #
    def isSigned_numFound(self):
        return False
    
    #
    # Return whether the field 'numFound' is an array (False).
    #
    def isArray_numFound(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'numFound'
    #
    def offset_numFound(self):
        return (8 / 8)
    
    #
    # Return the offset (in bits) of the field 'numFound'
    #
    def offsetBits_numFound(self):
        return 8
    
    #
    # Return the value (as a short) of the field 'numFound'
    #
    def get_numFound(self):
        return self.getUIntElement(self.offsetBits_numFound(), 8, 1)
    
    #
    # Set the value of the field 'numFound'
    #
    def set_numFound(self, value):
        self.setUIntElement(self.offsetBits_numFound(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'numFound'
    #
    def size_numFound(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'numFound'
    #
    def sizeBits_numFound(self):
        return 8
    
