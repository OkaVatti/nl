# src/libnl/nf/conntrack.cr
#
# Netfilter connection tracking management – allocation, cache,
# add/delete/get, and attribute getters/setters.

@[Link("nl-nf-3")]
lib LibNLNf
  # ---- Conntrack object allocation / free / reference -------------------

  fun nfnl_ct_alloc = nfnl_ct_alloc : Pointer(NfnlCt)
  fun nfnl_ct_put = nfnl_ct_put(ct : Pointer(NfnlCt)) : Void
  # Note: Reference counting is done via nl_object_get from core, not a separate nfnl_ct_get.
  fun nfnl_ct_clone = nfnl_ct_clone(ct : Pointer(NfnlCt)) : Pointer(NfnlCt)

  # ---- Conntrack cache --------------------------------------------------

  fun nfnl_ct_alloc_cache = nfnl_ct_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- Conntrack add / delete / get / update ----------------------------

  fun nfnl_ct_add = nfnl_ct_add(
    sk : Pointer(LibNL::NL_Sock),
    ct : Pointer(NfnlCt),
    flags : Int32,
  ) : Int32
  fun nfnl_ct_delete = nfnl_ct_delete(
    sk : Pointer(LibNL::NL_Sock),
    ct : Pointer(NfnlCt),
    flags : Int32,
  ) : Int32
  fun nfnl_ct_get = nfnl_ct_get(
    sk : Pointer(LibNL::NL_Sock),
    ct : Pointer(NfnlCt),
    flags : Int32,
  ) : Int32
  fun nfnl_ct_update = nfnl_ct_update(
    sk : Pointer(LibNL::NL_Sock),
    ct : Pointer(NfnlCt),
    flags : Int32,
  ) : Int32

  # ---- Message building helpers -----------------------------------------

  fun nfnl_ct_build_add_request = nfnl_ct_build_add_request(
    ct : Pointer(NfnlCt),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun nfnl_ct_build_delete_request = nfnl_ct_build_delete_request(
    ct : Pointer(NfnlCt),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun nfnl_ct_build_get_request = nfnl_ct_build_get_request(
    ct : Pointer(NfnlCt),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun nfnl_ct_build_update_request = nfnl_ct_build_update_request(
    ct : Pointer(NfnlCt),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Parse netlink message into conntrack object ----------------------

  fun nfnl_ct_parse = nfnl_ct_parse(
    nlh : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(NfnlCt)),
  ) : Int32

  # ---- Attribute setters (tuple, status, timeouts, counters, marks) ----

  # For tuple (orig/reply) – you can set IP addresses, ports, etc.
  # These use nested attributes; we provide convenience functions for setting
  # entire tuple from a nl_addr, protocol, and ports.

  fun nfnl_ct_set_tuple = nfnl_ct_set_tuple(
    ct : Pointer(NfnlCt),
    tuple : Pointer(LibNL::NL_Attr),
    dir : NfCtDir,
  ) : Int32

  fun nfnl_ct_set_tuple_orig = nfnl_ct_set_tuple_orig(
    ct : Pointer(NfnlCt),
    tuple : Pointer(LibNL::NL_Attr),
  ) : Int32

  fun nfnl_ct_set_tuple_reply = nfnl_ct_set_tuple_reply(
    ct : Pointer(NfnlCt),
    tuple : Pointer(LibNL::NL_Attr),
  ) : Int32

  fun nfnl_ct_set_status = nfnl_ct_set_status(ct : Pointer(NfnlCt), status : UInt32) : Void
  fun nfnl_ct_unset_status = nfnl_ct_unset_status(ct : Pointer(NfnlCt), status : UInt32) : Void
  fun nfnl_ct_get_status = nfnl_ct_get_status(ct : Pointer(NfnlCt)) : UInt32
  fun nfnl_ct_set_timeout = nfnl_ct_set_timeout(ct : Pointer(NfnlCt), timeout : UInt32) : Void
  fun nfnl_ct_get_timeout = nfnl_ct_get_timeout(ct : Pointer(NfnlCt)) : UInt32
  fun nfnl_ct_set_mark = nfnl_ct_set_mark(ct : Pointer(NfnlCt), mark : UInt32) : Void
  fun nfnl_ct_get_mark = nfnl_ct_get_mark(ct : Pointer(NfnlCt)) : UInt32
  fun nfnl_ct_set_use = nfnl_ct_set_use(ct : Pointer(NfnlCt), use : UInt32) : Void
  fun nfnl_ct_get_use = nfnl_ct_get_use(ct : Pointer(NfnlCt)) : UInt32
  fun nfnl_ct_set_id = nfnl_ct_set_id(ct : Pointer(NfnlCt), id : UInt32) : Void
  fun nfnl_ct_get_id = nfnl_ct_get_id(ct : Pointer(NfnlCt)) : UInt32

  # ---- Counter access ---------------------------------------------------

  fun nfnl_ct_get_counter = nfnl_ct_get_counter(
    ct : Pointer(NfnlCt),
    dir : NfCtDir,
    packets : UInt64*,
    bytes : UInt64*,
  ) : Int32

  fun nfnl_ct_set_counter = nfnl_ct_set_counter(
    ct : Pointer(NfnlCt),
    dir : NfCtDir,
    packets : UInt64,
    bytes : UInt64,
  ) : Void

  # ---- Tuple convenience getters ----------------------------------------

  fun nfnl_ct_get_tuple = nfnl_ct_get_tuple(
    ct : Pointer(NfnlCt),
    dir : NfCtDir,
  ) : Pointer(LibNL::NL_Attr)

  fun nfnl_ct_get_tuple_orig = nfnl_ct_get_tuple_orig(
    ct : Pointer(NfnlCt),
  ) : Pointer(LibNL::NL_Attr)

  fun nfnl_ct_get_tuple_reply = nfnl_ct_get_tuple_reply(
    ct : Pointer(NfnlCt),
  ) : Pointer(LibNL::NL_Attr)

  # ---- Protocol specific helpers (L3/L4) --------------------------------

  fun nfnl_ct_set_proto = nfnl_ct_set_proto(
    ct : Pointer(NfnlCt),
    proto : UInt8,
  ) : Void
  fun nfnl_ct_get_proto = nfnl_ct_get_proto(ct : Pointer(NfnlCt)) : UInt8

  # ---- Zone -------------------------------------------------------------

  fun nfnl_ct_set_zone = nfnl_ct_set_zone(ct : Pointer(NfnlCt), zone : UInt16) : Void
  fun nfnl_ct_get_zone = nfnl_ct_get_zone(ct : Pointer(NfnlCt)) : UInt16

  # ---- Helper name ------------------------------------------------------

  fun nfnl_ct_set_helper = nfnl_ct_set_helper(ct : Pointer(NfnlCt), helper : LibC::Char*) : Int32
  fun nfnl_ct_get_helper = nfnl_ct_get_helper(ct : Pointer(NfnlCt)) : LibC::Char*

  # ---- Conntrack filtering (for cache) ---------------------------------

  fun nfnl_ct_filter_add = nfnl_ct_filter_add(
    filter : Pointer(LibNL::NL_Cache),
    attr : NfCtAttr,
    data : Pointer(Void),
  ) : Int32

  fun nfnl_ct_filter_del = nfnl_ct_filter_del(
    filter : Pointer(LibNL::NL_Cache),
    attr : NfCtAttr,
  ) : Int32

  fun nfnl_ct_filter_clear = nfnl_ct_filter_clear(
    filter : Pointer(LibNL::NL_Cache),
  ) : Void

  # ---- Conntrack event handling (for monitoring) -----------------------

  # Create a callback set that filters conntrack events.
  fun nfnl_ct_cb_set = nfnl_ct_cb_set(
    cb : Pointer(LibNL::NL_Cb),
    event : NfCtEvent,
    func : (Pointer(NfnlCt), Pointer(Void) -> Int32),
    arg : Pointer(Void),
  ) : Int32

  # ---- Additional conntrack operations -------------------------------------
  fun nfnl_ct_dump_request = nfnl_ct_dump_request(
    sk : Pointer(LibNL::NL_Sock),
  ) : Int32

  fun nfnl_ct_query = nfnl_ct_query(
    sk : Pointer(LibNL::NL_Sock),
    ct : Pointer(NfnlCt),
    flags : Int32,
  ) : Int32

  fun nfnl_ct_build_query_request = nfnl_ct_build_query_request(
    ct : Pointer(NfnlCt),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  fun nfnl_ct_test_proto = nfnl_ct_test_proto(
    ct : Pointer(NfnlCt),
  ) : Int32

  fun nfnl_ct_set_tcp_state = nfnl_ct_set_tcp_state(
    ct : Pointer(NfnlCt),
    state : UInt8,
  ) : Void

  fun nfnl_ct_test_tcp_state = nfnl_ct_test_tcp_state(
    ct : Pointer(NfnlCt),
  ) : Int32

  fun nfnl_ct_get_tcp_state = nfnl_ct_get_tcp_state(
    ct : Pointer(NfnlCt),
  ) : UInt8

  fun nfnl_ct_tcp_state2str = nfnl_ct_tcp_state2str(
    state : UInt8,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun nfnl_ct_str2tcp_state = nfnl_ct_str2tcp_state(
    name : LibC::Char*,
  ) : Int32

  fun nfnl_ct_test_status = nfnl_ct_test_status(
    ct : Pointer(NfnlCt),
  ) : Int32

  fun nfnl_ct_status2str = nfnl_ct_status2str(
    status : Int32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun nfnl_ct_str2status = nfnl_ct_str2status(
    str : LibC::Char*,
  ) : Int32

  fun nfnl_ct_test_timeout = nfnl_ct_test_timeout(
    ct : Pointer(NfnlCt),
  ) : Int32

  fun nfnl_ct_test_mark = nfnl_ct_test_mark(
    ct : Pointer(NfnlCt),
  ) : Int32

  fun nfnl_ct_test_use = nfnl_ct_test_use(
    ct : Pointer(NfnlCt),
  ) : Int32
end
