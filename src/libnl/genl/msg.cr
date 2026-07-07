# src/libnl/genl/msg.cr
#
# Generic Netlink message construction, parsing, and data access.

@[Link("nl-genl-3")]
lib LibNLGenl
  # ---- Generic netlink socket connection ----------------------------------

  fun genl_connect = genl_connect(sk : Pointer(LibNL::NL_Sock)) : Int32

  # ---- Join / leave multicast groups -------------------------------------

  fun genl_join_mc_group = genl_join_mc_group(
    sk : Pointer(LibNL::NL_Sock),
    family_name : LibC::Char*,
    group_name : LibC::Char*,
  ) : Int32
  fun genl_leave_mc_group = genl_leave_mc_group(
    sk : Pointer(LibNL::NL_Sock),
    family_name : LibC::Char*,
    group_name : LibC::Char*,
  ) : Int32

  # ---- Put a generic netlink message header ------------------------------

  fun genlmsg_put = genlmsg_put(
    msg : Pointer(LibNL::NL_Msg),
    port : UInt32,
    seq : UInt32,
    family : Pointer(GenlFamily),
    hdrlen : Int32,
    flags : Int32,
    cmd : UInt8,
    version : UInt8,
  ) : Pointer(Void)

  # ---- Parse generic netlink header --------------------------------------

  fun genlmsg_parse = genlmsg_parse(
    nlh : Pointer(LibNL::NL_Msg),
    hdrlen : Int32,
    tb : Pointer(Pointer(LibNL::NL_Attr)),
    maxtype : Int32,
    policy : Pointer(LibNL::NlaPolicy),
  ) : Int32

  # ---- Access to genl header and data ------------------------------------

  fun genlmsg_hdr = genlmsg_hdr(nlh : Pointer(LibNL::NL_Msg)) : Pointer(Genlmsghdr)
  fun genlmsg_user_hdr = genlmsg_user_hdr(nlh : Pointer(LibNL::NL_Msg)) : Pointer(Void)
  fun genlmsg_data = genlmsg_data(hdr : Pointer(Genlmsghdr)) : Pointer(Void)
  fun genlmsg_len = genlmsg_len(hdr : Pointer(Genlmsghdr)) : Int32
  fun genlmsg_attrdata = genlmsg_attrdata(hdr : Pointer(Genlmsghdr), hdrlen : Int32) : Pointer(LibNL::NL_Attr)
  fun genlmsg_attrlen = genlmsg_attrlen(hdr : Pointer(Genlmsghdr), hdrlen : Int32) : Int32

  # ---- Message validation (similar to nlmsg_ok) --------------------------

  fun genlmsg_ok = genlmsg_ok(hdr : Pointer(Genlmsghdr), remaining : Int32) : Int32
  fun genlmsg_next = genlmsg_next(hdr : Pointer(Genlmsghdr), remaining : Int32*) : Pointer(Genlmsghdr)

  # ---- Message parsing with callback (for generic messages) --------------

  # This is a convenience function that parses a generic netlink message
  # and calls a callback for each attribute.
  # The callback signature is: (Pointer(LibNL::NL_Attr), Pointer(Void) -> Int32)
  fun genlmsg_parse_cb = genlmsg_parse_cb(
    msg : Pointer(LibNL::NL_Msg),
    hdrlen : Int32,
    cb : (Pointer(LibNL::NL_Attr), Pointer(Void) -> Int32),
    arg : Pointer(Void),
  ) : Int32

  # ---- Additional genl message operations ----------------------------------
  fun genl_send_simple = genl_send_simple(
    sk : Pointer(LibNL::NL_Sock),
    family : Int32,
    cmd : Int32,
    version : Int32,
    flags : Int32,
  ) : Int32

  fun genlmsg_valid_hdr = genlmsg_valid_hdr(
    nlh : Pointer(LibNL::NL_Msg),
    hdrlen : Int32,
  ) : Int32

  fun genlmsg_validate = genlmsg_validate(
    nlh : Pointer(LibNL::NL_Msg),
    hdrlen : Int32,
    maxtype : Int32,
    policy : Pointer(LibNL::NlaPolicy),
  ) : Int32

  fun genlmsg_user_data = genlmsg_user_data(
    hdr : Pointer(Genlmsghdr),
    hdrlen : Int32,
  ) : Pointer(Void)

  fun genlmsg_user_datalen = genlmsg_user_datalen(
    hdr : Pointer(Genlmsghdr),
    hdrlen : Int32,
  ) : Int32

  fun genl_op2name = genl_op2name(
    family : Int32,
    cmd : Int32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*
end

# ---- Wrapper for genl_socket_alloc (was inline/deprecated) ----

module LibNLHelpers
  # Allocate a socket for generic netlink (using core nl_socket_alloc)
  def self.genl_socket_alloc : Pointer(LibNL::NL_Sock)
    LibNL.nl_socket_alloc
  end
end
