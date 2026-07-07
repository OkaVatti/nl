# src/libnl/xfrm/selector.cr
#
# Address selector – abstract data type representing XFRM SA/SP selector
# properties (addresses, ports, protocols, etc.).

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- Selector allocation / clone / free --------------------------------

  fun xfrmnl_sel_alloc = xfrmnl_sel_alloc : Pointer(XfrmnlSel)
  fun xfrmnl_sel_clone = xfrmnl_sel_clone(sel : Pointer(XfrmnlSel)) : Pointer(XfrmnlSel)
  fun xfrmnl_sel_put = xfrmnl_sel_put(sel : Pointer(XfrmnlSel)) : Void

  # ---- Selector reference counting ---------------------------------------

  fun xfrmnl_sel_get = xfrmnl_sel_get(sel : Pointer(XfrmnlSel)) : Pointer(XfrmnlSel)
  fun xfrmnl_sel_shared = xfrmnl_sel_shared(sel : Pointer(XfrmnlSel)) : Int32
  fun xfrmnl_sel_cmp = xfrmnl_sel_cmp(
    a : Pointer(XfrmnlSel),
    b : Pointer(XfrmnlSel),
  ) : Int32

  # ---- Selector dump -----------------------------------------------------

  fun xfrmnl_sel_dump = xfrmnl_sel_dump(
    sel : Pointer(XfrmnlSel),
    params : Pointer(LibNL::NL_DumpParams),
  ) : Void

  # ---- Destination address (getters / setters) ---------------------------

  fun xfrmnl_sel_get_daddr = xfrmnl_sel_get_daddr(sel : Pointer(XfrmnlSel)) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_sel_set_daddr = xfrmnl_sel_set_daddr(
    sel : Pointer(XfrmnlSel),
    daddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- Source address (getters / setters) --------------------------------

  fun xfrmnl_sel_get_saddr = xfrmnl_sel_get_saddr(sel : Pointer(XfrmnlSel)) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_sel_set_saddr = xfrmnl_sel_set_saddr(
    sel : Pointer(XfrmnlSel),
    saddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- Destination port (getters / setters) ------------------------------

  fun xfrmnl_sel_get_dport = xfrmnl_sel_get_dport(sel : Pointer(XfrmnlSel)) : UInt16
  fun xfrmnl_sel_set_dport = xfrmnl_sel_set_dport(
    sel : Pointer(XfrmnlSel),
    dport : UInt16,
  ) : Int32

  fun xfrmnl_sel_get_dportmask = xfrmnl_sel_get_dportmask(sel : Pointer(XfrmnlSel)) : UInt16
  fun xfrmnl_sel_set_dportmask = xfrmnl_sel_set_dportmask(
    sel : Pointer(XfrmnlSel),
    dportmask : UInt16,
  ) : Int32

  # ---- Source port (getters / setters) -----------------------------------

  fun xfrmnl_sel_get_sport = xfrmnl_sel_get_sport(sel : Pointer(XfrmnlSel)) : UInt16
  fun xfrmnl_sel_set_sport = xfrmnl_sel_set_sport(
    sel : Pointer(XfrmnlSel),
    sport : UInt16,
  ) : Int32

  fun xfrmnl_sel_get_sportmask = xfrmnl_sel_get_sportmask(sel : Pointer(XfrmnlSel)) : UInt16
  fun xfrmnl_sel_set_sportmask = xfrmnl_sel_set_sportmask(
    sel : Pointer(XfrmnlSel),
    sportmask : UInt16,
  ) : Int32

  # ---- Family (getters / setters) ----------------------------------------

  fun xfrmnl_sel_get_family = xfrmnl_sel_get_family(sel : Pointer(XfrmnlSel)) : UInt8
  fun xfrmnl_sel_set_family = xfrmnl_sel_set_family(
    sel : Pointer(XfrmnlSel),
    family : UInt8,
  ) : Int32

  # ---- Prefix lengths (getters / setters) --------------------------------

  fun xfrmnl_sel_get_prefixlen_d = xfrmnl_sel_get_prefixlen_d(
    sel : Pointer(XfrmnlSel),
  ) : UInt8
  fun xfrmnl_sel_set_prefixlen_d = xfrmnl_sel_set_prefixlen_d(
    sel : Pointer(XfrmnlSel),
    prefixlen : UInt8,
  ) : Int32

  fun xfrmnl_sel_get_prefixlen_s = xfrmnl_sel_get_prefixlen_s(
    sel : Pointer(XfrmnlSel),
  ) : UInt8
  fun xfrmnl_sel_set_prefixlen_s = xfrmnl_sel_set_prefixlen_s(
    sel : Pointer(XfrmnlSel),
    prefixlen : UInt8,
  ) : Int32

  # ---- Protocol (getters / setters) --------------------------------------

  fun xfrmnl_sel_get_proto = xfrmnl_sel_get_proto(sel : Pointer(XfrmnlSel)) : UInt8
  fun xfrmnl_sel_set_proto = xfrmnl_sel_set_proto(
    sel : Pointer(XfrmnlSel),
    proto : UInt8,
  ) : Int32

  # ---- Ifindex (getters / setters) ---------------------------------------

  fun xfrmnl_sel_get_ifindex = xfrmnl_sel_get_ifindex(sel : Pointer(XfrmnlSel)) : Int32
  fun xfrmnl_sel_set_ifindex = xfrmnl_sel_set_ifindex(
    sel : Pointer(XfrmnlSel),
    ifindex : Int32,
  ) : Int32

  # ---- User (getters / setters) ------------------------------------------

  fun xfrmnl_sel_get_user = xfrmnl_sel_get_user(sel : Pointer(XfrmnlSel)) : UInt32
  fun xfrmnl_sel_set_user = xfrmnl_sel_set_user(
    sel : Pointer(XfrmnlSel),
    user : UInt32,
  ) : Int32
end
