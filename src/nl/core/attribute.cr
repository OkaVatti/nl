# src/nl/core/attribute.cr
#
# High‑level wrapper for netlink attributes (TLVs).

module Nl
  ##
  # A netlink attribute (TLV).
  #
  # Provides type‑safe accessors for reading the payload of an attribute,
  # and supports iteration over nested attributes.
  class Attribute
    @ptr : Pointer(LibNL::NL_Attr)

    def initialize(ptr : Pointer(LibNL::NL_Attr))
      @ptr = ptr
    end

    def to_unsafe
      @ptr
    end

    # Returns the attribute type.
    def type : Int32
      LibNLHelpers.nla_type(@ptr)
    end

    # Returns the total length of the attribute (header + payload).
    def length : Int32
      LibNLHelpers.nla_len(@ptr)
    end

    # Returns a pointer to the payload data.
    def data : Pointer(Void)
      LibNLHelpers.nla_data(@ptr)
    end

    # Retrieves an unsigned 8‑bit value.
    def get_u8 : UInt8
      LibNL.nla_get_u8(@ptr)
    end

    # Retrieves an unsigned 16‑bit value.
    def get_u16 : UInt16
      LibNL.nla_get_u16(@ptr)
    end

    # Retrieves an unsigned 32‑bit value.
    def get_u32 : UInt32
      LibNL.nla_get_u32(@ptr)
    end

    # Retrieves an unsigned 64‑bit value.
    def get_u64 : UInt64
      LibNL.nla_get_u64(@ptr)
    end

    # Retrieves a signed 8‑bit value.
    def get_s8 : Int8
      LibNL.nla_get_s8(@ptr)
    end

    # Retrieves a signed 16‑bit value.
    def get_s16 : Int16
      LibNL.nla_get_s16(@ptr)
    end

    # Retrieves a signed 32‑bit value.
    def get_s32 : Int32
      LibNL.nla_get_s32(@ptr)
    end

    # Retrieves a signed 64‑bit value.
    def get_s64 : Int64
      LibNL.nla_get_s64(@ptr)
    end

    # Retrieves a string value.
    def get_string : String
      str = LibNL.nla_get_string(@ptr)
      raise "Invalid string attribute" if str.null?
      String.new(str)
    end

    # Retrieves a flag (returns `true` if the flag is present).
    def get_flag : Bool
      LibNL.nla_get_flag(@ptr) == 1
    end

    # Iterates over nested attributes.
    #
    # This method assumes the current attribute is a nested container.
    def each_nested(&)
      attr_ptr = @ptr
      remaining = LibNLHelpers.nla_len(attr_ptr)
      while remaining >= sizeof(LibNL::NlAttr)
        attr = attr_ptr.as(Pointer(LibNL::NL_Attr))
        yield Attribute.new(attr)
        attr_ptr = LibNLHelpers.nla_next(attr, pointerof(remaining))
      end
    end
  end
end
