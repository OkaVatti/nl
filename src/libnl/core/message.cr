# src/libnl/core/message.cr
#
# Netlink message allocation, construction, parsing, and introspection.

@[Link("nl-3")]
lib LibNL
  # ---- Allocation / Free --------------------------------------------------

  fun nlmsg_alloc = nlmsg_alloc : Pointer(NL_Msg)
  fun nlmsg_alloc_size = nlmsg_alloc_size(max : LibC::SizeT) : Pointer(NL_Msg)
  fun nlmsg_alloc_simple = nlmsg_alloc_simple(nlmsgtype : Int32, flags : Int32) : Pointer(NL_Msg)
  fun nlmsg_inherit = nlmsg_inherit(hdr : Pointer(Void)) : Pointer(NL_Msg)
  fun nlmsg_convert = nlmsg_convert(hdr : Pointer(Void)) : Pointer(NL_Msg)
  fun nlmsg_free = nlmsg_free(msg : Pointer(NL_Msg)) : Void

  # ---- Default size -------------------------------------------------------

  fun nlmsg_set_default_size = nlmsg_set_default_size(max : LibC::SizeT) : Void

  # ---- Size calculations --------------------------------------------------

  fun nlmsg_size = nlmsg_size(payload : Int32) : Int32
  fun nlmsg_total_size = nlmsg_total_size(payload : Int32) : Int32
  fun nlmsg_padlen = nlmsg_padlen(payload : Int32) : Int32

  # ---- Put a basic netlink message header ---------------------------------

  fun nlmsg_put = nlmsg_put(msg : Pointer(NL_Msg), port : UInt32, seq : UInt32, type : Int32, payload : Int32, flags : Int32) : Pointer(Void)

  # ---- Additional message operations ---------------------------------------

  fun nlmsg_parse = nlmsg_parse(
    nlh : Pointer(Void),
    hdrlen : Int32,
    tb : Pointer(Pointer(NL_Attr)),
    maxtype : Int32,
    policy : Pointer(NlaPolicy),
  ) : Int32

  fun nlmsg_find_attr = nlmsg_find_attr(
    nlh : Pointer(Void),
    hdrlen : Int32,
    attrtype : Int32,
  ) : Pointer(NL_Attr)

  fun nlmsg_validate = nlmsg_validate(
    nlh : Pointer(Void),
    hdrlen : Int32,
    maxtype : Int32,
    policy : Pointer(NlaPolicy),
  ) : Int32

  fun nlmsg_reserve = nlmsg_reserve(
    msg : Pointer(NL_Msg),
    len : LibC::SizeT,
    pad : Int32,
  ) : Pointer(Void)

  fun nlmsg_append = nlmsg_append(
    msg : Pointer(NL_Msg),
    data : Pointer(Void),
    len : LibC::SizeT,
    pad : Int32,
  ) : Int32

  fun nlmsg_expand = nlmsg_expand(
    msg : Pointer(NL_Msg),
    newlen : LibC::SizeT,
  ) : Int32

  fun nlmsg_hdr = nlmsg_hdr(
    msg : Pointer(NL_Msg),
  ) : Pointer(Void)

  fun nlmsg_get = nlmsg_get(
    msg : Pointer(NL_Msg),
  ) : Void

  fun nlmsg_set_proto = nlmsg_set_proto(
    msg : Pointer(NL_Msg),
    protocol : Int32,
  ) : Void

  fun nlmsg_get_proto = nlmsg_get_proto(
    msg : Pointer(NL_Msg),
  ) : Int32

  fun nlmsg_get_max_size = nlmsg_get_max_size(
    msg : Pointer(NL_Msg),
  ) : LibC::SizeT

  fun nlmsg_set_src = nlmsg_set_src(
    msg : Pointer(NL_Msg),
    addr : Pointer(Void), # struct sockaddr_nl*
  ) : Void

  fun nlmsg_get_src = nlmsg_get_src(
    msg : Pointer(NL_Msg),
  ) : Pointer(Void) # struct sockaddr_nl*

  fun nlmsg_set_dst = nlmsg_set_dst(
    msg : Pointer(NL_Msg),
    addr : Pointer(Void), # struct sockaddr_nl*
  ) : Void

  fun nlmsg_get_dst = nlmsg_get_dst(
    msg : Pointer(NL_Msg),
  ) : Pointer(Void) # struct sockaddr_nl*

  fun nlmsg_set_creds = nlmsg_set_creds(
    msg : Pointer(NL_Msg),
    creds : Pointer(Void), # struct ucred*
  ) : Void

  fun nlmsg_get_creds = nlmsg_get_creds(
    msg : Pointer(NL_Msg),
  ) : Pointer(Void) # struct ucred*

  fun nl_nlmsgtype2str = nl_nlmsgtype2str(
    type : Int32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun nl_str2nlmsgtype = nl_str2nlmsgtype(
    str : LibC::Char*,
  ) : Int32

  fun nl_nlmsg_flags2str = nl_nlmsg_flags2str(
    flags : Int32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*
end

# ---- Helper module for inline functions (previously defined in C headers) ----

module LibNLHelpers
  # Get the length from the header (was inline nlmsg_len)
  def self.nlmsg_len(nlh : Pointer(Void)) : UInt32
    nlh.as(Pointer(LibNL::NlMsghdr)).value.nlmsg_len
  end

  # Get the data pointer (after the header)
  def self.nlmsg_data(nlh : Pointer(Void)) : Pointer(Void)
    nlh + sizeof(LibNL::NlMsghdr)
  end

  # Get the tail pointer (end of message)
  def self.nlmsg_tail(nlh : Pointer(Void)) : Pointer(Void)
    nlh + nlmsg_len(nlh)
  end

  # Data length = total length - header size
  def self.nlmsg_datalen(nlh : Pointer(Void)) : Int32
    (nlmsg_len(nlh) - sizeof(LibNL::NlMsghdr)).to_i32
  end

  # Get attribute data start
  def self.nlmsg_attrdata(nlh : Pointer(Void), hdrlen : Int32) : Pointer(LibNL::NL_Attr)
    (nlh + sizeof(LibNL::NlMsghdr) + hdrlen).as(Pointer(LibNL::NL_Attr))
  end

  # Attribute length = data length - hdrlen
  def self.nlmsg_attrlen(nlh : Pointer(Void), hdrlen : Int32) : Int32
    nlmsg_datalen(nlh) - hdrlen
  end

  # Check if the header is valid (remaining >= sizeof(NlMsghdr))
  def self.nlmsg_valid_hdr(nlh : Pointer(Void), hdrlen : Int32) : Int32
    (nlmsg_len(nlh) >= sizeof(LibNL::NlMsghdr) + hdrlen) ? 1 : 0
  end

  # Check if the message is OK (remaining >= sizeof(NlMsghdr))
  def self.nlmsg_ok(nlh : Pointer(Void), remaining : Int32) : Int32
    (remaining >= sizeof(LibNL::NlMsghdr) && nlmsg_len(nlh) <= remaining && nlmsg_len(nlh) >= sizeof(LibNL::NlMsghdr)) ? 1 : 0
  end

  # Advance to the next message
  def self.nlmsg_next(nlh : Pointer(Void), remaining : Int32*) : Pointer(Void)
    len = nlmsg_len(nlh)
    remaining.value -= len
    (nlh + len).as(Pointer(Void))
  end
end
