# src/libnl/genl/ctrl.cr
#
# Netlink controller (nlctrl) – the generic netlink controller family
# that provides family discovery and resolution. Many of its functions
# are already declared in family.cr, but this file adds extra controller‑
# specific helpers and low‑level control message construction.

@[Link("nl-genl-3")]
lib LibNLGenl
  # ---- Controller cache (already in family.cr, but re‑expose) -----------

  # The full family cache is created with genl_ctrl_alloc_cache()

  # ---- Controller request helpers ----------------------------------------

  # Build a GETFAMILY request for a given family name.
  fun genl_ctrl_build_getfamily = genl_ctrl_build_getfamily(
    name : LibC::Char*,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # Send a GETFAMILY request and receive the family information.
  fun genl_ctrl_getfamily = genl_ctrl_getfamily(
    sk : Pointer(LibNL::NL_Sock),
    name : LibC::Char*,
    result : Pointer(Pointer(GenlFamily)),
  ) : Int32

  # ---- Controller message parsing (for family attributes) ----------------

  # Parse a GETFAMILY response into a GenlFamily object.
  fun genl_ctrl_parse_message = genl_ctrl_parse_message(
    nlh : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(GenlFamily)),
  ) : Int32

  # ---- Controller cache operations (in addition to family.cr) -----------

  # Add a family to the cache (for custom cache building)
  fun genl_ctrl_cache_add = genl_ctrl_cache_add(
    cache : Pointer(LibNL::NL_Cache),
    family : Pointer(GenlFamily),
  ) : Int32

  # ---- Controller-specific flags -----------------------------------------

  # The controller itself is a generic netlink family, so we can
  # use the standard genl functions with the controller ID (GENL_ID_CTRL).
  # This file provides convenience wrappers for common operations.

  # Resolve a family ID from a name using a cache (without sending a request).
  fun genl_ctrl_resolve_cache = genl_ctrl_resolve_cache(
    cache : Pointer(LibNL::NL_Cache),
    name : LibC::Char*,
  ) : Int32

  # Resolve a multicast group ID from a family name and group name
  # using a cache.
  fun genl_ctrl_resolve_grp_cache = genl_ctrl_resolve_grp_cache(
    cache : Pointer(LibNL::NL_Cache),
    family_name : LibC::Char*,
    group_name : LibC::Char*,
  ) : Int32
end
