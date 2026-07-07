# src/libnl/nf/log.cr
#
# Netfilter logging (NFLOG) – allocation, configuration, and binding.

@[Link("nl-nf-3")]
lib LibNLNf
  # ---- Log object allocation / free -------------------------------------

  fun nfnl_log_alloc = nfnl_log_alloc : Pointer(NfnlLog)
  fun nfnl_log_put = nfnl_log_put(log : Pointer(NfnlLog)) : Void
  fun nfnl_log_get = nfnl_log_get(log : Pointer(NfnlLog)) : Void

  # ---- Log configuration setters / getters ------------------------------

  fun nfnl_log_set_group = nfnl_log_set_group(log : Pointer(NfnlLog), group : UInt16) : Void
  fun nfnl_log_get_group = nfnl_log_get_group(log : Pointer(NfnlLog)) : UInt16

  fun nfnl_log_set_copy_mode = nfnl_log_set_copy_mode(
    log : Pointer(NfnlLog),
    mode : NfLogCopyMode,
  ) : Void
  fun nfnl_log_get_copy_mode = nfnl_log_get_copy_mode(
    log : Pointer(NfnlLog),
  ) : NfLogCopyMode

  fun nfnl_log_set_copy_range = nfnl_log_set_copy_range(
    log : Pointer(NfnlLog),
    range : UInt32,
  ) : Void
  fun nfnl_log_get_copy_range = nfnl_log_get_copy_range(
    log : Pointer(NfnlLog),
  ) : UInt32

  fun nfnl_log_set_queue_threshold = nfnl_log_set_queue_threshold(
    log : Pointer(NfnlLog),
    threshold : UInt32,
  ) : Void
  fun nfnl_log_get_queue_threshold = nfnl_log_get_queue_threshold(
    log : Pointer(NfnlLog),
  ) : UInt32

  fun nfnl_log_set_flags = nfnl_log_set_flags(
    log : Pointer(NfnlLog),
    flags : UInt32,
  ) : Void
  fun nfnl_log_get_flags = nfnl_log_get_flags(
    log : Pointer(NfnlLog),
  ) : UInt32

  fun nfnl_log_set_prefix = nfnl_log_set_prefix(
    log : Pointer(NfnlLog),
    prefix : LibC::Char*,
  ) : Int32
  fun nfnl_log_get_prefix = nfnl_log_get_prefix(
    log : Pointer(NfnlLog),
  ) : LibC::Char*

  # ---- Log bind / unbind (apply configuration) -------------------------

  fun nfnl_log_bind = nfnl_log_bind(
    sk : Pointer(LibNL::NL_Sock),
    log : Pointer(NfnlLog),
  ) : Int32

  fun nfnl_log_unbind = nfnl_log_unbind(
    sk : Pointer(LibNL::NL_Sock),
    log : Pointer(NfnlLog),
  ) : Int32

  # ---- Build netlink messages for log configuration --------------------

  fun nfnl_log_build_bind_request = nfnl_log_build_bind_request(
    log : Pointer(NfnlLog),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  fun nfnl_log_build_unbind_request = nfnl_log_build_unbind_request(
    log : Pointer(NfnlLog),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Parse a netlink message into a log object ------------------------

  fun nfnl_log_parse = nfnl_log_parse(
    nlh : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(NfnlLog)),
  ) : Int32

  # ---- Additional log operations -------------------------------------------
  # nfnl_* functions from nfnl.h
  fun nfnl_connect = nfnl_connect(
    sk : Pointer(LibNL::NL_Sock),
  ) : Int32

  fun nfnl_send_simple = nfnl_send_simple(
    sk : Pointer(LibNL::NL_Sock),
    subsys : UInt8,
    subtype : UInt8,
    flags : Int32,
    family : UInt8,
    res_id : UInt16,
  ) : Int32

  fun nfnlmsg_alloc_simple = nfnlmsg_alloc_simple(
    subsys : UInt8,
    subtype : UInt8,
    flags : Int32,
    family : UInt8,
    res_id : UInt16,
  ) : Pointer(LibNL::NL_Msg)

  fun nfnlmsg_put = nfnlmsg_put(
    msg : Pointer(LibNL::NL_Msg),
    port : UInt32,
    seq : UInt32,
    subsys : UInt8,
    subtype : UInt8,
    flags : Int32,
    family : UInt8,
    res_id : UInt16,
  ) : Int32

  fun nfnlmsg_subsys = nfnlmsg_subsys(
    nlh : Pointer(LibNL::NL_Msg),
  ) : UInt8

  fun nfnlmsg_subtype = nfnlmsg_subtype(
    nlh : Pointer(LibNL::NL_Msg),
  ) : UInt8

  fun nfnlmsg_family = nfnlmsg_family(
    nlh : Pointer(LibNL::NL_Msg),
  ) : UInt8

  fun nfnlmsg_res_id = nfnlmsg_res_id(
    nlh : Pointer(LibNL::NL_Msg),
  ) : UInt16
end
