# src/libnl/xfrm/lifetime.cr
#
# Lifetime configuration object – abstract data type representing
# XFRM SA/SP lifetime properties (soft/hard byte/packet limits, time limits).

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- Lifetime config allocation / clone / free -------------------------

  fun xfrmnl_ltime_cfg_alloc = xfrmnl_ltime_cfg_alloc : Pointer(XfrmnlLtimeCfg)
  fun xfrmnl_ltime_cfg_clone = xfrmnl_ltime_cfg_clone(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : Pointer(XfrmnlLtimeCfg)
  fun xfrmnl_ltime_cfg_put = xfrmnl_ltime_cfg_put(ltime : Pointer(XfrmnlLtimeCfg)) : Void

  # ---- Lifetime config reference counting --------------------------------

  fun xfrmnl_ltime_cfg_get = xfrmnl_ltime_cfg_get(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : Pointer(XfrmnlLtimeCfg)
  fun xfrmnl_ltime_cfg_shared = xfrmnl_ltime_cfg_shared(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : Int32
  fun xfrmnl_ltime_cfg_cmp = xfrmnl_ltime_cfg_cmp(
    a : Pointer(XfrmnlLtimeCfg),
    b : Pointer(XfrmnlLtimeCfg),
  ) : Int32

  # ---- Soft byte limit (getters / setters) -------------------------------

  fun xfrmnl_ltime_cfg_get_soft_bytelimit = xfrmnl_ltime_cfg_get_soft_bytelimit(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_soft_bytelimit = xfrmnl_ltime_cfg_set_soft_bytelimit(
    ltime : Pointer(XfrmnlLtimeCfg),
    limit : UInt64,
  ) : Int32

  # ---- Hard byte limit (getters / setters) -------------------------------

  fun xfrmnl_ltime_cfg_get_hard_bytelimit = xfrmnl_ltime_cfg_get_hard_bytelimit(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_hard_bytelimit = xfrmnl_ltime_cfg_set_hard_bytelimit(
    ltime : Pointer(XfrmnlLtimeCfg),
    limit : UInt64,
  ) : Int32

  # ---- Soft packet limit (getters / setters) -----------------------------

  fun xfrmnl_ltime_cfg_get_soft_packetlimit = xfrmnl_ltime_cfg_get_soft_packetlimit(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_soft_packetlimit = xfrmnl_ltime_cfg_set_soft_packetlimit(
    ltime : Pointer(XfrmnlLtimeCfg),
    limit : UInt64,
  ) : Int32

  # ---- Hard packet limit (getters / setters) -----------------------------

  fun xfrmnl_ltime_cfg_get_hard_packetlimit = xfrmnl_ltime_cfg_get_hard_packetlimit(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_hard_packetlimit = xfrmnl_ltime_cfg_set_hard_packetlimit(
    ltime : Pointer(XfrmnlLtimeCfg),
    limit : UInt64,
  ) : Int32

  # ---- Soft time limit (getters / setters) -------------------------------

  fun xfrmnl_ltime_cfg_get_soft_time = xfrmnl_ltime_cfg_get_soft_time(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_soft_time = xfrmnl_ltime_cfg_set_soft_time(
    ltime : Pointer(XfrmnlLtimeCfg),
    time : UInt64,
  ) : Int32

  # ---- Hard time limit (getters / setters) -------------------------------

  fun xfrmnl_ltime_cfg_get_hard_time = xfrmnl_ltime_cfg_get_hard_time(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_hard_time = xfrmnl_ltime_cfg_set_hard_time(
    ltime : Pointer(XfrmnlLtimeCfg),
    time : UInt64,
  ) : Int32

  # ---- Soft use time limit (getters / setters) ---------------------------

  fun xfrmnl_ltime_cfg_get_soft_use_time = xfrmnl_ltime_cfg_get_soft_use_time(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_soft_use_time = xfrmnl_ltime_cfg_set_soft_use_time(
    ltime : Pointer(XfrmnlLtimeCfg),
    time : UInt64,
  ) : Int32

  # ---- Hard use time limit (getters / setters) ---------------------------

  fun xfrmnl_ltime_cfg_get_hard_use_time = xfrmnl_ltime_cfg_get_hard_use_time(
    ltime : Pointer(XfrmnlLtimeCfg),
  ) : UInt64
  fun xfrmnl_ltime_cfg_set_hard_use_time = xfrmnl_ltime_cfg_set_hard_use_time(
    ltime : Pointer(XfrmnlLtimeCfg),
    time : UInt64,
  ) : Int32
end
