# src/libnl/xfrm/sa.cr
#
# Security Association (SA) management – allocation, cache, add/delete/update,
# and attribute getters/setters.

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- SA allocation / free / reference counting -------------------------

  fun xfrmnl_sa_alloc = xfrmnl_sa_alloc : Pointer(XfrmnlSa)
  fun xfrmnl_sa_put = xfrmnl_sa_put(sa : Pointer(XfrmnlSa)) : Void

  # ---- SA cache ----------------------------------------------------------

  fun xfrmnl_sa_alloc_cache = xfrmnl_sa_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- SA lookup ---------------------------------------------------------

  fun xfrmnl_sa_get = xfrmnl_sa_get(
    cache : Pointer(LibNL::NL_Cache),
    daddr : Pointer(LibNL::NL_Addr),
    spi : UInt32,
    proto : UInt32,
  ) : Pointer(XfrmnlSa)

  # ---- SA parse ----------------------------------------------------------

  fun xfrmnl_sa_parse = xfrmnl_sa_parse(
    n : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(XfrmnlSa)),
  ) : Int32

  # ---- SA get kernel -----------------------------------------------------

  fun xfrmnl_sa_get_kernel = xfrmnl_sa_get_kernel(
    sk : Pointer(LibNL::NL_Sock),
    daddr : Pointer(LibNL::NL_Addr),
    spi : UInt32,
    proto : UInt32,
    mark : UInt32,
    mark_mask : UInt32,
    result : Pointer(Pointer(XfrmnlSa)),
  ) : Int32

  # ---- SA build get request ----------------------------------------------

  fun xfrmnl_sa_build_get_request = xfrmnl_sa_build_get_request(
    daddr : Pointer(LibNL::NL_Addr),
    spi : UInt32,
    proto : UInt32,
    mark : UInt32,
    mark_mask : UInt32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SA add ------------------------------------------------------------

  fun xfrmnl_sa_add = xfrmnl_sa_add(
    sk : Pointer(LibNL::NL_Sock),
    sa : Pointer(XfrmnlSa),
    flags : Int32,
  ) : Int32

  fun xfrmnl_sa_build_add_request = xfrmnl_sa_build_add_request(
    sa : Pointer(XfrmnlSa),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SA update ---------------------------------------------------------

  fun xfrmnl_sa_update = xfrmnl_sa_update(
    sk : Pointer(LibNL::NL_Sock),
    sa : Pointer(XfrmnlSa),
    flags : Int32,
  ) : Int32

  fun xfrmnl_sa_build_update_request = xfrmnl_sa_build_update_request(
    sa : Pointer(XfrmnlSa),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SA delete ---------------------------------------------------------

  fun xfrmnl_sa_delete = xfrmnl_sa_delete(
    sk : Pointer(LibNL::NL_Sock),
    sa : Pointer(XfrmnlSa),
    flags : Int32,
  ) : Int32

  fun xfrmnl_sa_build_delete_request = xfrmnl_sa_build_delete_request(
    sa : Pointer(XfrmnlSa),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SA selector (getters / setters) -----------------------------------

  fun xfrmnl_sa_get_sel = xfrmnl_sa_get_sel(sa : Pointer(XfrmnlSa)) : Pointer(XfrmnlSel)
  fun xfrmnl_sa_set_sel = xfrmnl_sa_set_sel(
    sa : Pointer(XfrmnlSa),
    sel : Pointer(XfrmnlSel),
  ) : Int32

  # ---- SA lifetime config (getters / setters) ----------------------------

  fun xfrmnl_sa_get_lifetime_cfg = xfrmnl_sa_get_lifetime_cfg(
    sa : Pointer(XfrmnlSa),
  ) : Pointer(XfrmnlLtimeCfg)
  fun xfrmnl_sa_set_lifetime_cfg = xfrmnl_sa_set_lifetime_cfg(
    sa : Pointer(XfrmnlSa),
    lft : Pointer(XfrmnlLtimeCfg),
  ) : Int32

  # ---- SA current lifetime (getters / setters) ---------------------------

  fun xfrmnl_sa_get_curlifetime = xfrmnl_sa_get_curlifetime(
    sa : Pointer(XfrmnlSa),
  ) : Pointer(XfrmnlLifetimeCur)
  fun xfrmnl_sa_set_curlifetime = xfrmnl_sa_set_curlifetime(
    sa : Pointer(XfrmnlSa),
    curlft : Pointer(XfrmnlLifetimeCur),
  ) : Int32

  # ---- SA statistics (getters / setters) ---------------------------------

  fun xfrmnl_sa_get_stats = xfrmnl_sa_get_stats(sa : Pointer(XfrmnlSa)) : Pointer(XfrmnlStats)
  fun xfrmnl_sa_set_stats = xfrmnl_sa_set_stats(
    sa : Pointer(XfrmnlSa),
    stats : Pointer(XfrmnlStats),
  ) : Int32

  # ---- SA address (getters / setters) ------------------------------------

  fun xfrmnl_sa_get_saddr = xfrmnl_sa_get_saddr(sa : Pointer(XfrmnlSa)) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_sa_set_saddr = xfrmnl_sa_set_saddr(
    sa : Pointer(XfrmnlSa),
    saddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  fun xfrmnl_sa_get_daddr = xfrmnl_sa_get_daddr(sa : Pointer(XfrmnlSa)) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_sa_set_daddr = xfrmnl_sa_set_daddr(
    sa : Pointer(XfrmnlSa),
    daddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- SA SPI (getters / setters) ----------------------------------------

  fun xfrmnl_sa_get_spi = xfrmnl_sa_get_spi(sa : Pointer(XfrmnlSa)) : UInt32
  fun xfrmnl_sa_set_spi = xfrmnl_sa_set_spi(
    sa : Pointer(XfrmnlSa),
    spi : UInt32,
  ) : Int32

  # ---- SA protocol (getters / setters) -----------------------------------

  fun xfrmnl_sa_get_proto = xfrmnl_sa_get_proto(sa : Pointer(XfrmnlSa)) : UInt8
  fun xfrmnl_sa_set_proto = xfrmnl_sa_set_proto(
    sa : Pointer(XfrmnlSa),
    proto : UInt8,
  ) : Int32

  # ---- SA family (getters / setters) -------------------------------------

  fun xfrmnl_sa_get_family = xfrmnl_sa_get_family(sa : Pointer(XfrmnlSa)) : UInt8
  fun xfrmnl_sa_set_family = xfrmnl_sa_set_family(
    sa : Pointer(XfrmnlSa),
    family : UInt8,
  ) : Int32

  # ---- SA mode (getters / setters) ---------------------------------------

  fun xfrmnl_sa_get_mode = xfrmnl_sa_get_mode(sa : Pointer(XfrmnlSa)) : UInt8
  fun xfrmnl_sa_set_mode = xfrmnl_sa_set_mode(
    sa : Pointer(XfrmnlSa),
    mode : UInt8,
  ) : Int32

  # ---- SA replay window (getters / setters) ------------------------------

  fun xfrmnl_sa_get_replay_window = xfrmnl_sa_get_replay_window(
    sa : Pointer(XfrmnlSa),
  ) : UInt8
  fun xfrmnl_sa_set_replay_window = xfrmnl_sa_set_replay_window(
    sa : Pointer(XfrmnlSa),
    replay_window : UInt8,
  ) : Int32

  # ---- SA reqid (getters / setters) --------------------------------------

  fun xfrmnl_sa_get_reqid = xfrmnl_sa_get_reqid(sa : Pointer(XfrmnlSa)) : UInt32
  fun xfrmnl_sa_set_reqid = xfrmnl_sa_set_reqid(
    sa : Pointer(XfrmnlSa),
    reqid : UInt32,
  ) : Int32

  # ---- SA flags (getters / setters) --------------------------------------

  fun xfrmnl_sa_get_flags = xfrmnl_sa_get_flags(sa : Pointer(XfrmnlSa)) : UInt32
  fun xfrmnl_sa_set_flags = xfrmnl_sa_set_flags(
    sa : Pointer(XfrmnlSa),
    flags : UInt32,
  ) : Int32

  # ---- SA mark (getters / setters) ---------------------------------------

  fun xfrmnl_sa_get_mark = xfrmnl_sa_get_mark(sa : Pointer(XfrmnlSa)) : Pointer(XfrmnlMark)
  fun xfrmnl_sa_set_mark = xfrmnl_sa_set_mark(
    sa : Pointer(XfrmnlSa),
    mark : Pointer(XfrmnlMark),
  ) : Int32

  # ---- SA if_id (getters / setters) --------------------------------------

  fun xfrmnl_sa_get_if_id = xfrmnl_sa_get_if_id(sa : Pointer(XfrmnlSa)) : UInt32
  fun xfrmnl_sa_set_if_id = xfrmnl_sa_set_if_id(
    sa : Pointer(XfrmnlSa),
    if_id : UInt32,
  ) : Int32

  # ---- SA algorithm (getters / setters) ----------------------------------

  fun xfrmnl_sa_get_algo = xfrmnl_sa_get_algo(sa : Pointer(XfrmnlSa)) : Pointer(XfrmnlAlgo)
  fun xfrmnl_sa_set_algo = xfrmnl_sa_set_algo(
    sa : Pointer(XfrmnlSa),
    algo : Pointer(XfrmnlAlgo),
  ) : Int32

  fun xfrmnl_sa_get_algo_auth = xfrmnl_sa_get_algo_auth(
    sa : Pointer(XfrmnlSa),
  ) : Pointer(XfrmnlAlgoAuth)
  fun xfrmnl_sa_set_algo_auth = xfrmnl_sa_set_algo_auth(
    sa : Pointer(XfrmnlSa),
    algo : Pointer(XfrmnlAlgoAuth),
  ) : Int32

  fun xfrmnl_sa_get_algo_aead = xfrmnl_sa_get_algo_aead(
    sa : Pointer(XfrmnlSa),
  ) : Pointer(XfrmnlAlgoAead)
  fun xfrmnl_sa_set_algo_aead = xfrmnl_sa_set_algo_aead(
    sa : Pointer(XfrmnlSa),
    algo : Pointer(XfrmnlAlgoAead),
  ) : Int32

  # ---- SA encapsulation template (getters / setters) ---------------------

  fun xfrmnl_sa_get_encap_tmpl = xfrmnl_sa_get_encap_tmpl(
    sa : Pointer(XfrmnlSa),
  ) : Pointer(XfrmnlEncapTmpl)
  fun xfrmnl_sa_set_encap_tmpl = xfrmnl_sa_set_encap_tmpl(
    sa : Pointer(XfrmnlSa),
    encap : Pointer(XfrmnlEncapTmpl),
  ) : Int32

  # ---- SA offload (getters / setters) ------------------------------------

  fun xfrmnl_sa_get_offload = xfrmnl_sa_get_offload(
    sa : Pointer(XfrmnlSa),
  ) : Pointer(XfrmnlUserOffload)
  fun xfrmnl_sa_set_offload = xfrmnl_sa_set_offload(
    sa : Pointer(XfrmnlSa),
    offload : Pointer(XfrmnlUserOffload),
  ) : Int32
end
