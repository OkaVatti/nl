# src/libnl/core/attr.cr
#
# Netlink attribute (TLV) construction, parsing, and access.

@[Link("nl-3")]
lib LibNL
  # ---- Attribute size helpers ---------------------------------------------

  fun nla_attr_size = nla_attr_size(payload : Int32) : Int32
  fun nla_total_size = nla_total_size(payload : Int32) : Int32
  fun nla_padlen = nla_padlen(payload : Int32) : Int32

  # ---- Attribute parsing into an index array ------------------------------

  fun nla_parse = nla_parse(
    tb : Pointer(Pointer(NL_Attr)),
    maxtype : Int32,
    head : Pointer(NL_Attr),
    len : Int32,
    policy : Pointer(NlaPolicy),
  ) : Int32

  fun nla_validate = nla_validate(
    head : Pointer(NL_Attr),
    len : Int32,
    maxtype : Int32,
    policy : Pointer(NlaPolicy),
  ) : Int32

  # ---- Finding attributes ------------------------------------------------

  fun nla_find = nla_find(head : Pointer(NL_Attr), len : Int32, attrtype : Int32) : Pointer(NL_Attr)

  # ---- Putting attributes into a message ---------------------------------

  fun nla_put = nla_put(msg : Pointer(NL_Msg), attrtype : Int32, datalen : Int32, data : Pointer(Void)) : Int32
  fun nla_put_u8 = nla_put_u8(msg : Pointer(NL_Msg), attrtype : Int32, value : UInt8) : Int32
  fun nla_put_u16 = nla_put_u16(msg : Pointer(NL_Msg), attrtype : Int32, value : UInt16) : Int32
  fun nla_put_u32 = nla_put_u32(msg : Pointer(NL_Msg), attrtype : Int32, value : UInt32) : Int32
  fun nla_put_u64 = nla_put_u64(msg : Pointer(NL_Msg), attrtype : Int32, value : UInt64) : Int32
  fun nla_put_s8 = nla_put_s8(msg : Pointer(NL_Msg), attrtype : Int32, value : Int8) : Int32
  fun nla_put_s16 = nla_put_s16(msg : Pointer(NL_Msg), attrtype : Int32, value : Int16) : Int32
  fun nla_put_s32 = nla_put_s32(msg : Pointer(NL_Msg), attrtype : Int32, value : Int32) : Int32
  fun nla_put_s64 = nla_put_s64(msg : Pointer(NL_Msg), attrtype : Int32, value : Int64) : Int32
  fun nla_put_string = nla_put_string(msg : Pointer(NL_Msg), attrtype : Int32, str : LibC::Char*) : Int32
  fun nla_put_flag = nla_put_flag(msg : Pointer(NL_Msg), attrtype : Int32) : Int32
  fun nla_put_nested = nla_put_nested(msg : Pointer(NL_Msg), attrtype : Int32, nested : Pointer(NL_Msg)) : Int32

  # ---- Nested attributes --------------------------------------------------

  fun nla_nest_start = nla_nest_start(msg : Pointer(NL_Msg), attrtype : Int32) : Pointer(NL_Attr)
  fun nla_nest_end = nla_nest_end(msg : Pointer(NL_Msg), nla : Pointer(NL_Attr)) : Int32
  fun nla_nest_cancel = nla_nest_cancel(msg : Pointer(NL_Msg), nla : Pointer(NL_Attr)) : Void

  # ---- Getting attribute values -------------------------------------------

  fun nla_get_u8 = nla_get_u8(nla : Pointer(NL_Attr)) : UInt8
  fun nla_get_u16 = nla_get_u16(nla : Pointer(NL_Attr)) : UInt16
  fun nla_get_u32 = nla_get_u32(nla : Pointer(NL_Attr)) : UInt32
  fun nla_get_u64 = nla_get_u64(nla : Pointer(NL_Attr)) : UInt64
  fun nla_get_s8 = nla_get_s8(nla : Pointer(NL_Attr)) : Int8
  fun nla_get_s16 = nla_get_s16(nla : Pointer(NL_Attr)) : Int16
  fun nla_get_s32 = nla_get_s32(nla : Pointer(NL_Attr)) : Int32
  fun nla_get_s64 = nla_get_s64(nla : Pointer(NL_Attr)) : Int64
  fun nla_get_string = nla_get_string(nla : Pointer(NL_Attr)) : LibC::Char*
  fun nla_get_flag = nla_get_flag(nla : Pointer(NL_Attr)) : Int32

  # ---- Policy definitions (helpers) ---------------------------------------

  fun nla_policy_len = nla_policy_len(policy : Pointer(NlaPolicy), maxtype : Int32) : Int32

  # ---- Additional attribute operations -------------------------------------
  fun nla_put_data = nla_put_data(
    msg : Pointer(NL_Msg),
    attrtype : Int32,
    data : Pointer(Void), # struct nl_data*
  ) : Int32

  fun nla_put_addr = nla_put_addr(
    msg : Pointer(NL_Msg),
    attrtype : Int32,
    addr : Pointer(NL_Addr),
  ) : Int32

  fun nla_memcpy = nla_memcpy(
    dest : Pointer(Void),
    nla : Pointer(NL_Attr),
    offset : Int32,
  ) : Int32

  fun nla_strlcpy = nla_strlcpy(
    dst : LibC::Char*,
    nla : Pointer(NL_Attr),
    dstsize : LibC::SizeT,
  ) : LibC::SizeT

  fun nla_memcmp = nla_memcmp(
    nla : Pointer(NL_Attr),
    data : Pointer(Void),
    size : LibC::SizeT,
  ) : Int32

  fun nla_strcmp = nla_strcmp(
    nla : Pointer(NL_Attr),
    str : LibC::Char*,
  ) : Int32

  fun nla_reserve = nla_reserve(
    msg : Pointer(NL_Msg),
    attrtype : Int32,
    len : Int32,
  ) : Pointer(NL_Attr)
end

# ---- Helper module for inline functions (previously defined in C headers) ----

module LibNLHelpers
  # Get attribute type (was inline nla_type)
  def self.nla_type(nla : Pointer(LibNL::NL_Attr)) : Int32
    nla.as(Pointer(LibNL::NlAttr)).value.nla_type & 0x3fff # NLA_TYPE_MASK
  end

  # Get attribute data pointer (was inline nla_data)
  def self.nla_data(nla : Pointer(LibNL::NL_Attr)) : Pointer(Void)
    (nla + sizeof(LibNL::NlAttr)).as(Pointer(Void))
  end

  # Get attribute length (was inline nla_len)
  def self.nla_len(nla : Pointer(LibNL::NL_Attr)) : Int32
    nla.as(Pointer(LibNL::NlAttr)).value.nla_len.to_i32
  end

  # Check if attribute is OK (was inline nla_ok)
  def self.nla_ok(nla : Pointer(LibNL::NL_Attr), remaining : Int32) : Int32
    (remaining >= sizeof(LibNL::NlAttr) && nla_len(nla) >= sizeof(LibNL::NlAttr) && nla_len(nla) <= remaining) ? 1 : 0
  end

  # Get next attribute (was inline nla_next)
  def self.nla_next(nla : Pointer(LibNL::NL_Attr), remaining : Int32*) : Pointer(LibNL::NL_Attr)
    len = nla_len(nla)
    remaining.value -= len
    (nla + len).as(Pointer(LibNL::NL_Attr))
  end
end
