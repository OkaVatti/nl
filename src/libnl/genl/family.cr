# src/libnl/genl/family.cr
#
# Generic Netlink family management – allocation, cache, getters/setters,
# and family resolution.

@[Link("nl-genl-3")]
lib LibNLGenl
  # ---- Family allocation / free / reference counting ---------------------

  fun genl_family_alloc = genl_family_alloc : Pointer(GenlFamily)
  fun genl_family_put = genl_family_put(family : Pointer(GenlFamily)) : Void
  fun genl_family_get = genl_family_get(family : Pointer(GenlFamily)) : Void

  # ---- Family cache ------------------------------------------------------

  fun genl_ctrl_alloc_cache = genl_ctrl_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- Family lookup by name or ID ---------------------------------------

  fun genl_ctrl_search_by_name = genl_ctrl_search_by_name(
    cache : Pointer(LibNL::NL_Cache),
    name : LibC::Char*,
  ) : Pointer(GenlFamily)

  fun genl_ctrl_search_by_id = genl_ctrl_search_by_id(
    cache : Pointer(LibNL::NL_Cache),
    id : Int32,
  ) : Pointer(GenlFamily)

  # ---- Family resolution (resolve name to ID) ----------------------------

  fun genl_ctrl_resolve = genl_ctrl_resolve(
    sk : Pointer(LibNL::NL_Sock),
    name : LibC::Char*,
  ) : Int32

  fun genl_ctrl_resolve_grp = genl_ctrl_resolve_grp(
    sk : Pointer(LibNL::NL_Sock),
    family_name : LibC::Char*,
    group_name : LibC::Char*,
  ) : Int32

  # ---- Family attribute getters ------------------------------------------

  fun genl_family_get_id = genl_family_get_id(family : Pointer(GenlFamily)) : UInt16
  fun genl_family_get_name = genl_family_get_name(family : Pointer(GenlFamily)) : LibC::Char*
  fun genl_family_get_version = genl_family_get_version(family : Pointer(GenlFamily)) : UInt8
  fun genl_family_get_hdrsize = genl_family_get_hdrsize(family : Pointer(GenlFamily)) : UInt32
  fun genl_family_get_maxattr = genl_family_get_maxattr(family : Pointer(GenlFamily)) : UInt32

  # ---- Family attribute setters ------------------------------------------

  fun genl_family_set_id = genl_family_set_id(family : Pointer(GenlFamily), id : UInt16) : Void
  fun genl_family_set_name = genl_family_set_name(family : Pointer(GenlFamily), name : LibC::Char*) : Int32
  fun genl_family_set_version = genl_family_set_version(family : Pointer(GenlFamily), version : UInt8) : Void
  fun genl_family_set_hdrsize = genl_family_set_hdrsize(family : Pointer(GenlFamily), hdrsize : UInt32) : Void
  fun genl_family_set_maxattr = genl_family_set_maxattr(family : Pointer(GenlFamily), maxattr : UInt32) : Void

  # ---- Multicast group management (for family) ---------------------------

  fun genl_family_get_mc_grp_count = genl_family_get_mc_grp_count(family : Pointer(GenlFamily)) : UInt32
  fun genl_family_get_mc_grp_name = genl_family_get_mc_grp_name(
    family : Pointer(GenlFamily),
    index : UInt32,
  ) : LibC::Char*
  fun genl_family_get_mc_grp_id = genl_family_get_mc_grp_id(
    family : Pointer(GenlFamily),
    index : UInt32,
  ) : UInt32

  # ---- Operations iteration (for introspection) --------------------------

  fun genl_family_get_ops_count = genl_family_get_ops_count(family : Pointer(GenlFamily)) : UInt32
  fun genl_family_get_op_id = genl_family_get_op_id(
    family : Pointer(GenlFamily),
    index : UInt32,
  ) : UInt32
  fun genl_family_get_op_flags = genl_family_get_op_flags(
    family : Pointer(GenlFamily),
    index : UInt32,
  ) : UInt32

  # ---- Family add / delete / change (for kernel operations) --------------

  fun genl_family_add = genl_family_add(
    sk : Pointer(LibNL::NL_Sock),
    family : Pointer(GenlFamily),
    flags : Int32,
  ) : Int32
  fun genl_family_delete = genl_family_delete(
    sk : Pointer(LibNL::NL_Sock),
    family : Pointer(GenlFamily),
  ) : Int32
  fun genl_family_build_add_request = genl_family_build_add_request(
    family : Pointer(GenlFamily),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun genl_family_build_del_request = genl_family_build_del_request(
    family : Pointer(GenlFamily),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Additional family operations ----------------------------------------
  fun genl_ctrl_search = genl_ctrl_search(
    cache : Pointer(LibNL::NL_Cache),
    id : Int32,
  ) : Pointer(GenlFamily)

  fun genl_family_add_op = genl_family_add_op(
    family : Pointer(GenlFamily),
    cmd : Int32,
    flags : Int32,
  ) : Int32

  fun genl_family_add_grp = genl_family_add_grp(
    family : Pointer(GenlFamily),
    id : UInt32,
    name : LibC::Char*,
  ) : Int32
end
