#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'GetSettingsStorageCmdMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 19

# The Active Message type associated with this message.
AM_TYPE = 193

class GetSettingsStorageCmdMsg(tinyos.message.Message.Message):
    # Create a new GetSettingsStorageCmdMsg of size 19.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=19):
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
        s = "Message <GetSettingsStorageCmdMsg> \n"
        try:
            s += "  [error=0x%x]\n" % (self.get_error())
        except:
            pass
        try:
            s += "  [key=0x%x]\n" % (self.get_key())
        except:
            pass
        try:
            s += "  [len=0x%x]\n" % (self.get_len())
        except:
            pass
        try:
            s += "  [val=";
            for i in range(0, 16):
                s += "0x%x " % (self.getElement_val(i) & 0xff)
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
    # Accessor methods for field: key
    #   Field type: short
    #   Offset (bits): 8
    #   Size (bits): 8
    #

    #
    # Return whether the field 'key' is signed (False).
    #
    def isSigned_key(self):
        return False
    
    #
    # Return whether the field 'key' is an array (False).
    #
    def isArray_key(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'key'
    #
    def offset_key(self):
        return (8 / 8)
    
    #
    # Return the offset (in bits) of the field 'key'
    #
    def offsetBits_key(self):
        return 8
    
    #
    # Return the value (as a short) of the field 'key'
    #
    def get_key(self):
        return self.getUIntElement(self.offsetBits_key(), 8, 1)
    
    #
    # Set the value of the field 'key'
    #
    def set_key(self, value):
        self.setUIntElement(self.offsetBits_key(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'key'
    #
    def size_key(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'key'
    #
    def sizeBits_key(self):
        return 8
    
    #
    # Accessor methods for field: len
    #   Field type: short
    #   Offset (bits): 16
    #   Size (bits): 8
    #

    #
    # Return whether the field 'len' is signed (False).
    #
    def isSigned_len(self):
        return False
    
    #
    # Return whether the field 'len' is an array (False).
    #
    def isArray_len(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'len'
    #
    def offset_len(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'len'
    #
    def offsetBits_len(self):
        return 16
    
    #
    # Return the value (as a short) of the field 'len'
    #
    def get_len(self):
        return self.getUIntElement(self.offsetBits_len(), 8, 1)
    
    #
    # Set the value of the field 'len'
    #
    def set_len(self, value):
        self.setUIntElement(self.offsetBits_len(), 8, value, 1)
    
    #
    # Return the size, in bytes, of the field 'len'
    #
    def size_len(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of the field 'len'
    #
    def sizeBits_len(self):
        return 8
    
    #
    # Accessor methods for field: val
    #   Field type: short[]
    #   Offset (bits): 24
    #   Size of each element (bits): 8
    #

    #
    # Return whether the field 'val' is signed (False).
    #
    def isSigned_val(self):
        return False
    
    #
    # Return whether the field 'val' is an array (True).
    #
    def isArray_val(self):
        return True
    
    #
    # Return the offset (in bytes) of the field 'val'
    #
    def offset_val(self, index1):
        offset = 24
        if index1 < 0 or index1 >= 16:
            raise IndexError
        offset += 0 + index1 * 8
        return (offset / 8)
    
    #
    # Return the offset (in bits) of the field 'val'
    #
    def offsetBits_val(self, index1):
        offset = 24
        if index1 < 0 or index1 >= 16:
            raise IndexError
        offset += 0 + index1 * 8
        return offset
    
    #
    # Return the entire array 'val' as a short[]
    #
    def get_val(self):
        tmp = [None]*16
        for index0 in range (0, self.numElements_val(0)):
                tmp[index0] = self.getElement_val(index0)
        return tmp
    
    #
    # Set the contents of the array 'val' from the given short[]
    #
    def set_val(self, value):
        for index0 in range(0, len(value)):
            self.setElement_val(index0, value[index0])

    #
    # Return an element (as a short) of the array 'val'
    #
    def getElement_val(self, index1):
        return self.getUIntElement(self.offsetBits_val(index1), 8, 1)
    
    #
    # Set an element of the array 'val'
    #
    def setElement_val(self, index1, value):
        self.setUIntElement(self.offsetBits_val(index1), 8, value, 1)
    
    #
    # Return the total size, in bytes, of the array 'val'
    #
    def totalSize_val(self):
        return (128 / 8)
    
    #
    # Return the total size, in bits, of the array 'val'
    #
    def totalSizeBits_val(self):
        return 128
    
    #
    # Return the size, in bytes, of each element of the array 'val'
    #
    def elementSize_val(self):
        return (8 / 8)
    
    #
    # Return the size, in bits, of each element of the array 'val'
    #
    def elementSizeBits_val(self):
        return 8
    
    #
    # Return the number of dimensions in the array 'val'
    #
    def numDimensions_val(self):
        return 1
    
    #
    # Return the number of elements in the array 'val'
    #
    def numElements_val():
        return 16
    
    #
    # Return the number of elements in the array 'val'
    # for the given dimension.
    #
    def numElements_val(self, dimension):
        array_dims = [ 16,  ]
        if dimension < 0 or dimension >= 1:
            raise IndexException
        if array_dims[dimension] == 0:
            raise IndexError
        return array_dims[dimension]
    
    #
    # Fill in the array 'val' with a String
    #
    def setString_val(self, s):
         l = len(s)
         for i in range(0, l):
             self.setElement_val(i, ord(s[i]));
         self.setElement_val(l, 0) #null terminate
    
    #
    # Read the array 'val' as a String
    #
    def getString_val(self):
        carr = "";
        for i in range(0, 4000):
            if self.getElement_val(i) == chr(0):
                break
            carr += self.getElement_val(i)
        return carr
    
