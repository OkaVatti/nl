# src/libnl/route/neighbour.cr
#
# Neighbour table (ARP/NDP) management – allocation, cache, addition,
# deletion, and attribute getters/setters.

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Allocation / Free / Reference counting ---------------------------

  fun rtnl_neigh_alloc = rtnl_neigh_alloc : Pointer(Rtnl_Neigh)
  fun rtnl_neigh_put = rtnl_neigh_put(neigh : Pointer(Rtnl_Neigh)) : Void
  # Note: Reference counting is done via nl_object_get from core, not a separate rtnl_neigh_get.
  fun rtnl_neigh_alloc_cache = rtnl_neigh_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- Neighbour addition / deletion ------------------------------------

  fun rtnl_neigh_add = rtnl_neigh_add(sk : Pointer(LibNL::NL_Sock), neigh : Pointer(Rtnl_Neigh), flags : Int32) : Int32
  fun rtnl_neigh_build_add_request = rtnl_neigh_build_add_request(
    neigh : Pointer(Rtnl_Neigh),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_neigh_delete = rtnl_neigh_delete(sk : Pointer(LibNL::NL_Sock), neigh : Pointer(Rtnl_Neigh), flags : Int32) : Int32
  fun rtnl_neigh_build_delete_request = rtnl_neigh_build_delete_request(
    neigh : Pointer(Rtnl_Neigh),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Neighbour lookup -------------------------------------------------

  fun rtnl_neigh_get = rtnl_neigh_get(
    cache : Pointer(LibNL::NL_Cache),
    ifindex : Int32,
    dst : Pointer(LibNL::NL_Addr),
  ) : Pointer(Rtnl_Neigh)

  # ---- Basic attributes (getters / setters) -----------------------------

  fun rtnl_neigh_set_family = rtnl_neigh_set_family(neigh : Pointer(Rtnl_Neigh), family : Int32) : Void
  fun rtnl_neigh_get_family = rtnl_neigh_get_family(neigh : Pointer(Rtnl_Neigh)) : Int32
  fun rtnl_neigh_set_ifindex = rtnl_neigh_set_ifindex(neigh : Pointer(Rtnl_Neigh), ifindex : Int32) : Void
  fun rtnl_neigh_get_ifindex = rtnl_neigh_get_ifindex(neigh : Pointer(Rtnl_Neigh)) : Int32
  fun rtnl_neigh_set_state = rtnl_neigh_set_state(neigh : Pointer(Rtnl_Neigh), state : UInt16) : Void
  fun rtnl_neigh_get_state = rtnl_neigh_get_state(neigh : Pointer(Rtnl_Neigh)) : UInt16
  fun rtnl_neigh_set_flags = rtnl_neigh_set_flags(neigh : Pointer(Rtnl_Neigh), flags : UInt8) : Void
  fun rtnl_neigh_get_flags = rtnl_neigh_get_flags(neigh : Pointer(Rtnl_Neigh)) : UInt8
  fun rtnl_neigh_set_type = rtnl_neigh_set_type(neigh : Pointer(Rtnl_Neigh), type : UInt8) : Void
  fun rtnl_neigh_get_type = rtnl_neigh_get_type(neigh : Pointer(Rtnl_Neigh)) : UInt8

  # ---- Addresses --------------------------------------------------------

  fun rtnl_neigh_set_dst = rtnl_neigh_set_dst(neigh : Pointer(Rtnl_Neigh), dst : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_neigh_get_dst = rtnl_neigh_get_dst(neigh : Pointer(Rtnl_Neigh)) : Pointer(LibNL::NL_Addr)
  fun rtnl_neigh_set_lladdr = rtnl_neigh_set_lladdr(neigh : Pointer(Rtnl_Neigh), lladdr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_neigh_get_lladdr = rtnl_neigh_get_lladdr(neigh : Pointer(Rtnl_Neigh)) : Pointer(LibNL::NL_Addr)

  # ---- Cache info -------------------------------------------------------

  fun rtnl_neigh_get_confirmed = rtnl_neigh_get_confirmed(neigh : Pointer(Rtnl_Neigh)) : UInt32
  fun rtnl_neigh_get_used = rtnl_neigh_get_used(neigh : Pointer(Rtnl_Neigh)) : UInt32
  fun rtnl_neigh_get_updated = rtnl_neigh_get_updated(neigh : Pointer(Rtnl_Neigh)) : UInt32
  fun rtnl_neigh_get_refcnt = rtnl_neigh_get_refcnt(neigh : Pointer(Rtnl_Neigh)) : Int32
end
