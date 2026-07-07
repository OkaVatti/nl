# src/libnl/route/addr.cr
#
# Network address management – allocation, cache, addition, deletion,
# and attribute getters/setters.

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Allocation / Free / Reference counting ---------------------------

  fun rtnl_addr_alloc = rtnl_addr_alloc : Pointer(Rtnl_Addr)
  fun rtnl_addr_put = rtnl_addr_put(addr : Pointer(Rtnl_Addr)) : Void
  fun rtnl_addr_get = rtnl_addr_get(addr : Pointer(Rtnl_Addr)) : Void
  fun rtnl_addr_alloc_cache = rtnl_addr_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- Address addition / deletion --------------------------------------

  fun rtnl_addr_add = rtnl_addr_add(sk : Pointer(LibNL::NL_Sock), addr : Pointer(Rtnl_Addr), flags : Int32) : Int32
  fun rtnl_addr_build_add_request = rtnl_addr_build_add_request(
    addr : Pointer(Rtnl_Addr),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_addr_delete = rtnl_addr_delete(sk : Pointer(LibNL::NL_Sock), addr : Pointer(Rtnl_Addr), flags : Int32) : Int32
  fun rtnl_addr_build_delete_request = rtnl_addr_build_delete_request(
    addr : Pointer(Rtnl_Addr),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Address flags (string conversion) --------------------------------

  fun rtnl_addr_flags2str = rtnl_addr_flags2str(flags : Int32, buf : LibC::Char*, size : LibC::SizeT) : LibC::Char*
  fun rtnl_addr_str2flags = rtnl_addr_str2flags(str : LibC::Char*) : Int32

  # ---- Basic attributes (getters / setters) -----------------------------

  fun rtnl_addr_set_label = rtnl_addr_set_label(addr : Pointer(Rtnl_Addr), label : LibC::Char*) : Int32
  fun rtnl_addr_get_label = rtnl_addr_get_label(addr : Pointer(Rtnl_Addr)) : LibC::Char*
  fun rtnl_addr_set_ifindex = rtnl_addr_set_ifindex(addr : Pointer(Rtnl_Addr), ifindex : Int32) : Void
  fun rtnl_addr_get_ifindex = rtnl_addr_get_ifindex(addr : Pointer(Rtnl_Addr)) : Int32
  fun rtnl_addr_set_family = rtnl_addr_set_family(addr : Pointer(Rtnl_Addr), family : Int32) : Void
  fun rtnl_addr_get_family = rtnl_addr_get_family(addr : Pointer(Rtnl_Addr)) : Int32
  fun rtnl_addr_set_prefixlen = rtnl_addr_set_prefixlen(addr : Pointer(Rtnl_Addr), prefixlen : Int32) : Void
  fun rtnl_addr_get_prefixlen = rtnl_addr_get_prefixlen(addr : Pointer(Rtnl_Addr)) : Int32
  fun rtnl_addr_set_scope = rtnl_addr_set_scope(addr : Pointer(Rtnl_Addr), scope : Int32) : Void
  fun rtnl_addr_get_scope = rtnl_addr_get_scope(addr : Pointer(Rtnl_Addr)) : Int32
  fun rtnl_addr_set_flags = rtnl_addr_set_flags(addr : Pointer(Rtnl_Addr), flags : UInt32) : Void
  fun rtnl_addr_unset_flags = rtnl_addr_unset_flags(addr : Pointer(Rtnl_Addr), flags : UInt32) : Void
  fun rtnl_addr_get_flags = rtnl_addr_get_flags(addr : Pointer(Rtnl_Addr)) : UInt32

  # ---- Address values (local / peer / broadcast / multicast) ------------

  fun rtnl_addr_set_local = rtnl_addr_set_local(addr : Pointer(Rtnl_Addr), local : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_addr_get_local = rtnl_addr_get_local(addr : Pointer(Rtnl_Addr)) : Pointer(LibNL::NL_Addr)
  fun rtnl_addr_set_peer = rtnl_addr_set_peer(addr : Pointer(Rtnl_Addr), peer : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_addr_get_peer = rtnl_addr_get_peer(addr : Pointer(Rtnl_Addr)) : Pointer(LibNL::NL_Addr)
  fun rtnl_addr_set_broadcast = rtnl_addr_set_broadcast(addr : Pointer(Rtnl_Addr), broadcast : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_addr_get_broadcast = rtnl_addr_get_broadcast(addr : Pointer(Rtnl_Addr)) : Pointer(LibNL::NL_Addr)
  fun rtnl_addr_set_multicast = rtnl_addr_set_multicast(addr : Pointer(Rtnl_Addr), multicast : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_addr_get_multicast = rtnl_addr_get_multicast(addr : Pointer(Rtnl_Addr)) : Pointer(LibNL::NL_Addr)
  fun rtnl_addr_set_anycast = rtnl_addr_set_anycast(addr : Pointer(Rtnl_Addr), anycast : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_addr_get_anycast = rtnl_addr_get_anycast(addr : Pointer(Rtnl_Addr)) : Pointer(LibNL::NL_Addr)

  # ---- Timestamps -------------------------------------------------------

  fun rtnl_addr_get_create_time = rtnl_addr_get_create_time(addr : Pointer(Rtnl_Addr)) : UInt64
  fun rtnl_addr_get_last_update_time = rtnl_addr_get_last_update_time(addr : Pointer(Rtnl_Addr)) : UInt64
end
