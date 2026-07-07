# src/nl/core/message.cr
#
# High‑level wrapper for netlink messages.

module Nl
  ##
  # A netlink message.
  #
  # This class handles allocation, header placement, attribute addition,
  # and provides helpers for building common request types.
  class Message
    @ptr : Pointer(LibNL::NL_Msg)
    @owned : Bool

    # Allocates a new empty message.
    def initialize
      @ptr = LibNL.nlmsg_alloc
      raise Error.new("Failed to allocate netlink message") if @ptr.null?
      @owned = true
    end

    # Wraps an existing message pointer (e.g., from parsing).
    #
    # If `owned` is `true`, the message will be freed when this object is
    # garbage‑collected.
    def initialize(ptr : Pointer(LibNL::NL_Msg), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the message if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNL.nlmsg_free(@ptr)
        @ptr = Pointer(LibNL::NL_Msg).null
      end
    end

    # Returns the underlying pointer.
    def to_unsafe
      @ptr
    end

    # Returns a pointer to the netlink header (`NlMsghdr`).
    def header : Pointer(LibNL::NlMsghdr)
      LibNL.nlmsg_hdr(@ptr).as(Pointer(LibNL::NlMsghdr))
    end

    # Puts a basic netlink header into the message.
    #
    # The header must be placed before any attributes or payload.
    def put_header(port : UInt32, seq : UInt32, type : Int32, payload : Int32, flags : Int32) : Pointer(Void)
      hdr = LibNL.nlmsg_put(@ptr, port, seq, type, payload, flags)
      raise Error.new("Failed to put netlink header") if hdr.null?
      hdr
    end

    # Appends raw data to the message.
    def append_data(data : Pointer(Void), len : LibC::SizeT, pad : Int32 = 0) : Nil
      ret = LibNL.nlmsg_append(@ptr, data, len, pad)
      raise Error.from_ret(ret) if ret < 0
    end

    # Reserves space in the message.
    def reserve(len : LibC::SizeT, pad : Int32 = 0) : Pointer(Void)
      ptr = LibNL.nlmsg_reserve(@ptr, len, pad)
      raise Error.new("Failed to reserve space") if ptr.null?
      ptr
    end

    # Expands the message to a new total length.
    def expand(newlen : LibC::SizeT) : Nil
      ret = LibNL.nlmsg_expand(@ptr, newlen)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Attributes -------------------------------------------------------

    # Starts a nested attribute block.
    def nest_start(attrtype : Int32) : Attribute
      attr = LibNL.nla_nest_start(@ptr, attrtype)
      raise Error.new("Failed to start nest") if attr.null?
      Attribute.new(attr)
    end

    # Ends a nested attribute block.
    def nest_end(attr : Attribute) : Nil
      ret = LibNL.nla_nest_end(@ptr, attr.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Cancels a nested attribute block (removes it).
    def nest_cancel(attr : Attribute) : Nil
      LibNL.nla_nest_cancel(@ptr, attr.to_unsafe)
    end

    # Generic putter for arbitrary attribute data.
    def put_attr(attrtype : Int32, data : Pointer(Void), datalen : Int32) : Nil
      ret = LibNL.nla_put(@ptr, attrtype, datalen, data)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts an unsigned 8‑bit attribute.
    def put_u8(attrtype : Int32, value : UInt8) : Nil
      ret = LibNL.nla_put_u8(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts an unsigned 16‑bit attribute.
    def put_u16(attrtype : Int32, value : UInt16) : Nil
      ret = LibNL.nla_put_u16(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts an unsigned 32‑bit attribute.
    def put_u32(attrtype : Int32, value : UInt32) : Nil
      ret = LibNL.nla_put_u32(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts an unsigned 64‑bit attribute.
    def put_u64(attrtype : Int32, value : UInt64) : Nil
      ret = LibNL.nla_put_u64(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts a signed 8‑bit attribute.
    def put_s8(attrtype : Int32, value : Int8) : Nil
      ret = LibNL.nla_put_s8(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts a signed 16‑bit attribute.
    def put_s16(attrtype : Int32, value : Int16) : Nil
      ret = LibNL.nla_put_s16(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts a signed 32‑bit attribute.
    def put_s32(attrtype : Int32, value : Int32) : Nil
      ret = LibNL.nla_put_s32(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts a signed 64‑bit attribute.
    def put_s64(attrtype : Int32, value : Int64) : Nil
      ret = LibNL.nla_put_s64(@ptr, attrtype, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts a string attribute.
    def put_string(attrtype : Int32, str : String) : Nil
      ret = LibNL.nla_put_string(@ptr, attrtype, str.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Puts a flag attribute (empty attribute with only a type).
    def put_flag(attrtype : Int32) : Nil
      ret = LibNL.nla_put_flag(@ptr, attrtype)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
