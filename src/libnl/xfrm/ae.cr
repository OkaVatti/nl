# src/libnl/xfrm/ae.cr
#
# Attribute Element (AE) interface for retrieving and updating SA attributes
# such as lifetime, replay state, etc.

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- AE allocation / free / reference counting -------------------------

  fun xfrmnl_ae_alloc = xfrmnl_ae_alloc : Pointer(XfrmnlAe)
  fun xfrmnl_ae_put = xfrmnl_ae_put(ae : Pointer(XfrmnlAe)) : Void

  # ---- AE get kernel -----------------------------------------------------

  fun xfrmnl_ae_get_kernel = xfrmnl_ae_get_kernel(
    sk : Pointer(LibNL::NL_Sock),
    daddr : Pointer(LibNL::NL_Addr),
    spi : UInt32,
    proto : UInt32,
    mark : UInt32,
    mark_mask : UInt32,
    result : Pointer(Pointer(XfrmnlAe)),
  ) : Int32

  # ---- AE set (update) ---------------------------------------------------

  fun xfrmnl_ae_set = xfrmnl_ae_set(
    sk : Pointer(LibNL::NL_Sock),
    ae : Pointer(XfrmnlAe),
    flags : Int32,
  ) : Int32

  # ---- AE parse ----------------------------------------------------------

  fun xfrmnl_ae_parse = xfrmnl_ae_parse(
    n : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(XfrmnlAe)),
  ) : Int32

  # ---- AE build get request ----------------------------------------------

  fun xfrmnl_ae_build_get_request = xfrmnl_ae_build_get_request(
    daddr : Pointer(LibNL::NL_Addr),
    spi : UInt32,
    proto : UInt32,
    mark : UInt32,
    mark_mask : UInt32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- AE destination address (getters / setters) -----------------------

  fun xfrmnl_ae_get_daddr = xfrmnl_ae_get_daddr(ae : Pointer(XfrmnlAe)) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_ae_set_daddr = xfrmnl_ae_set_daddr(
    ae : Pointer(XfrmnlAe),
    daddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- AE source address (getters / setters) -----------------------------

  fun xfrmnl_ae_get_saddr = xfrmnl_ae_get_saddr(ae : Pointer(XfrmnlAe)) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_ae_set_saddr = xfrmnl_ae_set_saddr(
    ae : Pointer(XfrmnlAe),
    saddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- AE SPI (getters / setters) ----------------------------------------

  fun xfrmnl_ae_get_spi = xfrmnl_ae_get_spi(ae : Pointer(XfrmnlAe)) : UInt32
  fun xfrmnl_ae_set_spi = xfrmnl_ae_set_spi(
    ae : Pointer(XfrmnlAe),
    spi : UInt32,
  ) : Int32

  # ---- AE protocol (getters / setters) -----------------------------------

  fun xfrmnl_ae_get_proto = xfrmnl_ae_get_proto(ae : Pointer(XfrmnlAe)) : UInt8
  fun xfrmnl_ae_set_proto = xfrmnl_ae_set_proto(
    ae : Pointer(XfrmnlAe),
    proto : UInt8,
  ) : Int32

  # ---- AE family (getters / setters) -------------------------------------

  fun xfrmnl_ae_get_family = xfrmnl_ae_get_family(ae : Pointer(XfrmnlAe)) : UInt8
  fun xfrmnl_ae_set_family = xfrmnl_ae_set_family(
    ae : Pointer(XfrmnlAe),
    family : UInt8,
  ) : Int32

  # ---- AE flags (getters / setters) --------------------------------------

  fun xfrmnl_ae_get_flags = xfrmnl_ae_get_flags(ae : Pointer(XfrmnlAe)) : UInt32
  fun xfrmnl_ae_set_flags = xfrmnl_ae_set_flags(
    ae : Pointer(XfrmnlAe),
    flags : UInt32,
  ) : Int32

  # ---- AE mark (getters / setters) ---------------------------------------

  fun xfrmnl_ae_get_mark = xfrmnl_ae_get_mark(ae : Pointer(XfrmnlAe)) : Pointer(XfrmnlMark)
  fun xfrmnl_ae_set_mark = xfrmnl_ae_set_mark(
    ae : Pointer(XfrmnlAe),
    mark : Pointer(XfrmnlMark),
  ) : Int32

  # ---- AE current lifetime (getters / setters) ---------------------------

  fun xfrmnl_ae_get_curlifetime = xfrmnl_ae_get_curlifetime(
    ae : Pointer(XfrmnlAe),
  ) : Pointer(XfrmnlLifetimeCur)
  fun xfrmnl_ae_set_curlifetime = xfrmnl_ae_set_curlifetime(
    ae : Pointer(XfrmnlAe),
    curlft : Pointer(XfrmnlLifetimeCur),
  ) : Int32

  # ---- AE replay settings (getters / setters) ----------------------------

  fun xfrmnl_ae_get_replay_maxage = xfrmnl_ae_get_replay_maxage(
    ae : Pointer(XfrmnlAe),
  ) : UInt32
  fun xfrmnl_ae_set_replay_maxage = xfrmnl_ae_set_replay_maxage(
    ae : Pointer(XfrmnlAe),
    maxage : UInt32,
  ) : Int32

  fun xfrmnl_ae_get_replay_maxdiff = xfrmnl_ae_get_replay_maxdiff(
    ae : Pointer(XfrmnlAe),
  ) : UInt32
  fun xfrmnl_ae_set_replay_maxdiff = xfrmnl_ae_set_replay_maxdiff(
    ae : Pointer(XfrmnlAe),
    maxdiff : UInt32,
  ) : Int32

  # ---- AE replay state (getters / setters) -------------------------------

  fun xfrmnl_ae_get_replay_state = xfrmnl_ae_get_replay_state(
    ae : Pointer(XfrmnlAe),
  ) : UInt32
  fun xfrmnl_ae_set_replay_state = xfrmnl_ae_set_replay_state(
    ae : Pointer(XfrmnlAe),
    state : UInt32,
  ) : Int32

  fun xfrmnl_ae_get_replay_state_esn = xfrmnl_ae_get_replay_state_esn(
    ae : Pointer(XfrmnlAe),
  ) : UInt64
  fun xfrmnl_ae_set_replay_state_esn = xfrmnl_ae_set_replay_state_esn(
    ae : Pointer(XfrmnlAe),
    state : UInt64,
  ) : Int32

  # ---- Additional AE operations --------------------------------------------
  fun xfrmnl_ae_flags2str = xfrmnl_ae_flags2str(
    flags : Int32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun xfrmnl_ae_str2flag = xfrmnl_ae_str2flag(
    name : LibC::Char*,
  ) : Int32
end
