#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'ReadIvResponseMsg'
# message type.
#

from tools.tinyos.Message import Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 33

# The Active Message type associated with this message.
AM_TYPE = 129

class ReadIvResponseMsg(Message):
    # Create a new ReadIvResponseMsg of size 33.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=33):
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
        s = "Message <ReadIvResponseMsg> \n"
        try:
            s += "  [error=0x%x]\n" % (self.get_error())
        except:
            pass
        try:
            s += "  [iv=";
            for i in range(0, 16):
                s += "0x%x " % (self.getElement_iv(i) & 0xffff)
            s += "]\n";
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
    # Accessor methods for field: iv
    #   Field type: int[]
    #   Offset (bits): 8
    #   Size of each element (bits): 16
    #

    #
    # Return whether the field 'iv' is signed (False).
    #
    def isSigned_iv(self):
        return False
    
    #
    # Return whether the field 'iv' is an array (True).
    #
    def isArray_iv(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'iv'
    #
    def offset_iv(self, index1):
        offset = 8
        if index1 < 0 or index1 >= 16:
            raise IndexError
        offset += 0 + index1 * 16
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'iv'
    #
    def offsetBits_iv(self, index1):
        offset = 8
        if index1 < 0 or index1 >= 16:
            raise IndexError
        offset += 0 + index1 * 16
        return offset
    
    #
    # Return the entire array 'iv' as a int[]
    #
    def get_iv(self):
        tmp = [None]*16
        for index0 in range (0, self.numElements_iv(0)):
                tmp[index0] = self.getElement_iv(index0)
        return tmp
    
    #
    # Set the contents of the array 'iv' from the given int[]
    #
    def set_iv(self, value):
        for index0 in range(0, len(value)):
            self.setElement_iv(index0, value[index0])

    #
    # Return an element (as a int) of the array 'iv'
    #
    def getElement_iv(self, index1):
        return self.getUIntElement(self.offsetBits_iv(index1), 16, 1)
    
    #
    # Set an element of the array 'iv'
    #
    def setElement_iv(self, index1, value):
        self.setUIntElement(self.offsetBits_iv(index1), 16, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'iv'
    #
    def totalSize_iv(self):
        return (256 / 8)
    
    #
    # Return the total size, in bits, of the array 'iv'
    #
    def totalSizeBits_iv(self):
        return 256
    
    #
    # Return the size, in bytes, of each element of the array 'iv'
    #
    def elementSize_iv(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'iv'
    #
    def elementSizeBits_iv(self):
        return 16
    
    #
    # Return the number of dimensions in the array 'iv'
    #
    def numDimensions_iv(self):
        return 1
    
    #
    # Return the number of elements in the array 'iv'
    #
    def numElements_iv():
        return 16
    
    #
    # Return the number of elements in the array 'iv'
    # for the given dimension.
    #
    def numElements_iv(self, dimension):
        array_dims = [ 16,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
