# src/libnl/xfrm/template.cr
#
# User template – abstract data type representing XFRM SA properties
# used in security policies.

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- Template allocation / clone / free --------------------------------

  fun xfrmnl_user_tmpl_alloc = xfrmnl_user_tmpl_alloc : Pointer(XfrmnlUserTmpl)
  fun xfrmnl_user_tmpl_clone = xfrmnl_user_tmpl_clone(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : Pointer(XfrmnlUserTmpl)
  fun xfrmnl_user_tmpl_free = xfrmnl_user_tmpl_free(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : Void

  # ---- Template compare and dump -----------------------------------------

  fun xfrmnl_user_tmpl_cmp = xfrmnl_user_tmpl_cmp(
    a : Pointer(XfrmnlUserTmpl),
    b : Pointer(XfrmnlUserTmpl),
  ) : Int32
  fun xfrmnl_user_tmpl_dump = xfrmnl_user_tmpl_dump(
    utmpl : Pointer(XfrmnlUserTmpl),
    params : Pointer(LibNL::NL_DumpParams),
  ) : Void

  # ---- Destination address (getters / setters) ---------------------------

  fun xfrmnl_user_tmpl_get_daddr = xfrmnl_user_tmpl_get_daddr(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_user_tmpl_set_daddr = xfrmnl_user_tmpl_set_daddr(
    utmpl : Pointer(XfrmnlUserTmpl),
    daddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- Source address (getters / setters) --------------------------------

  fun xfrmnl_user_tmpl_get_saddr = xfrmnl_user_tmpl_get_saddr(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : Pointer(LibNL::NL_Addr)
  fun xfrmnl_user_tmpl_set_saddr = xfrmnl_user_tmpl_set_saddr(
    utmpl : Pointer(XfrmnlUserTmpl),
    saddr : Pointer(LibNL::NL_Addr),
  ) : Int32

  # ---- SPI (getters / setters) -------------------------------------------

  fun xfrmnl_user_tmpl_get_spi = xfrmnl_user_tmpl_get_spi(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt32
  fun xfrmnl_user_tmpl_set_spi = xfrmnl_user_tmpl_set_spi(
    utmpl : Pointer(XfrmnlUserTmpl),
    spi : UInt32,
  ) : Int32

  # ---- Protocol (getters / setters) --------------------------------------

  fun xfrmnl_user_tmpl_get_proto = xfrmnl_user_tmpl_get_proto(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt8
  fun xfrmnl_user_tmpl_set_proto = xfrmnl_user_tmpl_set_proto(
    utmpl : Pointer(XfrmnlUserTmpl),
    proto : UInt8,
  ) : Int32

  # ---- Family (getters / setters) ----------------------------------------

  fun xfrmnl_user_tmpl_get_family = xfrmnl_user_tmpl_get_family(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt8
  fun xfrmnl_user_tmpl_set_family = xfrmnl_user_tmpl_set_family(
    utmpl : Pointer(XfrmnlUserTmpl),
    family : UInt8,
  ) : Int32

  # ---- Mode (getters / setters) ------------------------------------------

  fun xfrmnl_user_tmpl_get_mode = xfrmnl_user_tmpl_get_mode(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt8
  fun xfrmnl_user_tmpl_set_mode = xfrmnl_user_tmpl_set_mode(
    utmpl : Pointer(XfrmnlUserTmpl),
    mode : UInt8,
  ) : Int32

  # ---- Share (getters / setters) -----------------------------------------

  fun xfrmnl_user_tmpl_get_share = xfrmnl_user_tmpl_get_share(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt8
  fun xfrmnl_user_tmpl_set_share = xfrmnl_user_tmpl_set_share(
    utmpl : Pointer(XfrmnlUserTmpl),
    share : UInt8,
  ) : Int32

  # ---- Optional (getters / setters) --------------------------------------

  fun xfrmnl_user_tmpl_get_optional = xfrmnl_user_tmpl_get_optional(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt8
  fun xfrmnl_user_tmpl_set_optional = xfrmnl_user_tmpl_set_optional(
    utmpl : Pointer(XfrmnlUserTmpl),
    optional : UInt8,
  ) : Int32

  # ---- Aalgos / Ealgos / Calgos (getters / setters) ----------------------

  fun xfrmnl_user_tmpl_get_aalgos = xfrmnl_user_tmpl_get_aalgos(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt32
  fun xfrmnl_user_tmpl_set_aalgos = xfrmnl_user_tmpl_set_aalgos(
    utmpl : Pointer(XfrmnlUserTmpl),
    aalgos : UInt32,
  ) : Int32

  fun xfrmnl_user_tmpl_get_ealgos = xfrmnl_user_tmpl_get_ealgos(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt32
  fun xfrmnl_user_tmpl_set_ealgos = xfrmnl_user_tmpl_set_ealgos(
    utmpl : Pointer(XfrmnlUserTmpl),
    ealgos : UInt32,
  ) : Int32

  fun xfrmnl_user_tmpl_get_calgos = xfrmnl_user_tmpl_get_calgos(
    utmpl : Pointer(XfrmnlUserTmpl),
  ) : UInt32
  fun xfrmnl_user_tmpl_set_calgos = xfrmnl_user_tmpl_set_calgos(
    utmpl : Pointer(XfrmnlUserTmpl),
    calgos : UInt32,
  ) : Int32
end
