# src/libnl/xfrm/sp.cr
#
# Security Policy (SP) management – allocation, cache, add/delete/update,
# and attribute getters/setters.

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- SP allocation / free / reference counting -------------------------

  fun xfrmnl_sp_alloc = xfrmnl_sp_alloc : Pointer(XfrmnlSp)
  fun xfrmnl_sp_put = xfrmnl_sp_put(sp : Pointer(XfrmnlSp)) : Void

  # ---- SP cache ----------------------------------------------------------

  fun xfrmnl_sp_alloc_cache = xfrmnl_sp_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- SP lookup ---------------------------------------------------------

  fun xfrmnl_sp_get = xfrmnl_sp_get(
    cache : Pointer(LibNL::NL_Cache),
    index : UInt32,
    dir : UInt32,
  ) : Pointer(XfrmnlSp)

  # ---- SP parse ----------------------------------------------------------

  fun xfrmnl_sp_parse = xfrmnl_sp_parse(
    n : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(XfrmnlSp)),
  ) : Int32

  # ---- SP get kernel -----------------------------------------------------

  fun xfrmnl_sp_get_kernel = xfrmnl_sp_get_kernel(
    sk : Pointer(LibNL::NL_Sock),
    index : UInt32,
    dir : UInt32,
    mark : UInt32,
    mark_mask : UInt32,
    result : Pointer(Pointer(XfrmnlSp)),
  ) : Int32

  # ---- SP build get request ----------------------------------------------

  fun xfrmnl_sp_build_get_request = xfrmnl_sp_build_get_request(
    index : UInt32,
    dir : UInt32,
    mark : UInt32,
    mark_mask : UInt32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SP add ------------------------------------------------------------

  fun xfrmnl_sp_add = xfrmnl_sp_add(
    sk : Pointer(LibNL::NL_Sock),
    sp : Pointer(XfrmnlSp),
    flags : Int32,
  ) : Int32

  fun xfrmnl_sp_build_add_request = xfrmnl_sp_build_add_request(
    sp : Pointer(XfrmnlSp),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SP update ---------------------------------------------------------

  fun xfrmnl_sp_update = xfrmnl_sp_update(
    sk : Pointer(LibNL::NL_Sock),
    sp : Pointer(XfrmnlSp),
    flags : Int32,
  ) : Int32

  fun xfrmnl_sp_build_update_request = xfrmnl_sp_build_update_request(
    sp : Pointer(XfrmnlSp),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SP delete ---------------------------------------------------------

  fun xfrmnl_sp_delete = xfrmnl_sp_delete(
    sk : Pointer(LibNL::NL_Sock),
    sp : Pointer(XfrmnlSp),
    flags : Int32,
  ) : Int32

  fun xfrmnl_sp_build_delete_request = xfrmnl_sp_build_delete_request(
    sp : Pointer(XfrmnlSp),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- SP selector (getters / setters) -----------------------------------

  fun xfrmnl_sp_get_sel = xfrmnl_sp_get_sel(sp : Pointer(XfrmnlSp)) : Pointer(XfrmnlSel)
  fun xfrmnl_sp_set_sel = xfrmnl_sp_set_sel(
    sp : Pointer(XfrmnlSp),
    sel : Pointer(XfrmnlSel),
  ) : Int32

  # ---- SP lifetime config (getters / setters) ----------------------------

  fun xfrmnl_sp_get_lifetime_cfg = xfrmnl_sp_get_lifetime_cfg(
    sp : Pointer(XfrmnlSp),
  ) : Pointer(XfrmnlLtimeCfg)
  fun xfrmnl_sp_set_lifetime_cfg = xfrmnl_sp_set_lifetime_cfg(
    sp : Pointer(XfrmnlSp),
    lft : Pointer(XfrmnlLtimeCfg),
  ) : Int32

  # ---- SP current lifetime (getters / setters) ---------------------------

  fun xfrmnl_sp_get_curlifetime = xfrmnl_sp_get_curlifetime(
    sp : Pointer(XfrmnlSp),
  ) : Pointer(XfrmnlLifetimeCur)

  # ---- SP priority (getters / setters) -----------------------------------

  fun xfrmnl_sp_get_priority = xfrmnl_sp_get_priority(sp : Pointer(XfrmnlSp)) : UInt32
  fun xfrmnl_sp_set_priority = xfrmnl_sp_set_priority(
    sp : Pointer(XfrmnlSp),
    priority : UInt32,
  ) : Int32

  # ---- SP index (getters / setters) --------------------------------------

  fun xfrmnl_sp_get_index = xfrmnl_sp_get_index(sp : Pointer(XfrmnlSp)) : UInt32
  fun xfrmnl_sp_set_index = xfrmnl_sp_set_index(
    sp : Pointer(XfrmnlSp),
    index : UInt32,
  ) : Int32

  # ---- SP direction (getters / setters) ----------------------------------

  fun xfrmnl_sp_get_dir = xfrmnl_sp_get_dir(sp : Pointer(XfrmnlSp)) : UInt8
  fun xfrmnl_sp_set_dir = xfrmnl_sp_set_dir(
    sp : Pointer(XfrmnlSp),
    dir : UInt8,
  ) : Int32

  # ---- SP action (getters / setters) -------------------------------------

  fun xfrmnl_sp_get_action = xfrmnl_sp_get_action(sp : Pointer(XfrmnlSp)) : UInt8
  fun xfrmnl_sp_set_action = xfrmnl_sp_set_action(
    sp : Pointer(XfrmnlSp),
    action : UInt8,
  ) : Int32

  # ---- SP flags (getters / setters) --------------------------------------

  fun xfrmnl_sp_get_flags = xfrmnl_sp_get_flags(sp : Pointer(XfrmnlSp)) : UInt8
  fun xfrmnl_sp_set_flags = xfrmnl_sp_set_flags(
    sp : Pointer(XfrmnlSp),
    flags : UInt8,
  ) : Int32

  # ---- SP share (getters / setters) --------------------------------------

  fun xfrmnl_sp_get_share = xfrmnl_sp_get_share(sp : Pointer(XfrmnlSp)) : UInt8
  fun xfrmnl_sp_set_share = xfrmnl_sp_set_share(
    sp : Pointer(XfrmnlSp),
    share : UInt8,
  ) : Int32

  # ---- SP mark (getters / setters) ---------------------------------------

  fun xfrmnl_sp_get_mark = xfrmnl_sp_get_mark(sp : Pointer(XfrmnlSp)) : Pointer(XfrmnlMark)
  fun xfrmnl_sp_set_mark = xfrmnl_sp_set_mark(
    sp : Pointer(XfrmnlSp),
    mark : Pointer(XfrmnlMark),
  ) : Int32

  # ---- SP if_id (getters / setters) --------------------------------------

  fun xfrmnl_sp_get_if_id = xfrmnl_sp_get_if_id(sp : Pointer(XfrmnlSp)) : UInt32
  fun xfrmnl_sp_set_if_id = xfrmnl_sp_set_if_id(
    sp : Pointer(XfrmnlSp),
    if_id : UInt32,
  ) : Int32

  # ---- SP user templates (getters / setters) -----------------------------

  fun xfrmnl_sp_get_nr_user_tmpl = xfrmnl_sp_get_nr_user_tmpl(
    sp : Pointer(XfrmnlSp),
  ) : UInt32
  fun xfrmnl_sp_get_user_tmpl = xfrmnl_sp_get_user_tmpl(
    sp : Pointer(XfrmnlSp),
    index : UInt32,
  ) : Pointer(XfrmnlUserTmpl)
  fun xfrmnl_sp_add_user_tmpl = xfrmnl_sp_add_user_tmpl(
    sp : Pointer(XfrmnlSp),
    tmpl : Pointer(XfrmnlUserTmpl),
  ) : Int32
  fun xfrmnl_sp_del_user_tmpl = xfrmnl_sp_del_user_tmpl(
    sp : Pointer(XfrmnlSp),
    tmpl : Pointer(XfrmnlUserTmpl),
  ) : Int32
end
