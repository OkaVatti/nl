# src/libnl/core/addr.cr
#
# Network address manipulation – allocation, parsing, conversion, and comparison.
# All functions are from <netlink/addr.h>

@[Link("nl-3")]
lib LibNL
  # ---- Allocation / Free / Reference counting ----------------------------
  fun nl_addr_alloc = nl_addr_alloc(len : Int32) : Pointer(NL_Addr)
  fun nl_addr_alloc_empty = nl_addr_alloc_empty(family : Int32) : Pointer(NL_Addr)
  fun nl_addr_clone = nl_addr_clone(addr : Pointer(NL_Addr)) : Pointer(NL_Addr)
  fun nl_addr_get = nl_addr_get(addr : Pointer(NL_Addr)) : Void
  fun nl_addr_put = nl_addr_put(addr : Pointer(NL_Addr)) : Void
  fun nl_addr_shared = nl_addr_shared(addr : Pointer(NL_Addr)) : Int32

  # ---- Parsing / string conversion ---------------------------------------
  fun nl_addr_parse = nl_addr_parse(addr_str : LibC::Char*, family : Int32, result : Pointer(Pointer(NL_Addr))) : Int32
  fun nl_addr2str = nl_addr2str(addr : Pointer(NL_Addr), buf : LibC::Char*, size : LibC::SizeT) : LibC::Char*

  # ---- Family / prefix length --------------------------------------------
  fun nl_addr_set_family = nl_addr_set_family(addr : Pointer(NL_Addr), family : Int32) : Int32
  fun nl_addr_get_family = nl_addr_get_family(addr : Pointer(NL_Addr)) : Int32
  fun nl_addr_set_prefixlen = nl_addr_set_prefixlen(addr : Pointer(NL_Addr), prefixlen : Int32) : Void
  fun nl_addr_get_prefixlen = nl_addr_get_prefixlen(addr : Pointer(NL_Addr)) : Int32

  # ---- Binary data access ------------------------------------------------
  fun nl_addr_get_binary_addr = nl_addr_get_binary_addr(addr : Pointer(NL_Addr)) : Pointer(Void)
  fun nl_addr_set_binary_addr = nl_addr_set_binary_addr(addr : Pointer(NL_Addr), data : Pointer(Void), len : Int32) : Int32
  fun nl_addr_get_len = nl_addr_get_len(addr : Pointer(NL_Addr)) : Int32

  # ---- Comparison / info ------------------------------------------------
  fun nl_addr_cmp = nl_addr_cmp(a : Pointer(NL_Addr), b : Pointer(NL_Addr)) : Int32
  fun nl_addr_cmp_prefix = nl_addr_cmp_prefix(a : Pointer(NL_Addr), b : Pointer(NL_Addr)) : Int32
  fun nl_addr_iszero = nl_addr_iszero(addr : Pointer(NL_Addr)) : Int32
  fun nl_addr_valid = nl_addr_valid(addr_str : LibC::Char*, family : Int32) : Int32
  fun nl_addr_guess_family = nl_addr_guess_family(addr : Pointer(NL_Addr)) : Int32
  fun nl_addr_info = nl_addr_info(addr : Pointer(NL_Addr), result : Pointer(Pointer(NL_Cache))) : Int32

  # ---- Dump --------------------------------------------------------------
  fun nl_addr_dump = nl_addr_dump(addr : Pointer(NL_Addr), params : Pointer(NL_DumpParams)) : Void

  # ---- Group (multicast) helpers -----------------------------------------
  fun nl_addr_build = nl_addr_build(family : Int32, data : Pointer(Void), len : Int32, result : Pointer(Pointer(NL_Addr))) : Int32
  fun nl_addr_build_any = nl_addr_build_any(family : Int32, result : Pointer(Pointer(NL_Addr))) : Int32
  fun nl_addr_build_loopback = nl_addr_build_loopback(family : Int32, result : Pointer(Pointer(NL_Addr))) : Int32
  fun nl_addr_build_multicast = nl_addr_build_multicast(family : Int32, data : Pointer(Void), len : Int32, result : Pointer(Pointer(NL_Addr))) : Int32
  fun nl_addr_is_multicast = nl_addr_is_multicast(addr : Pointer(NL_Addr)) : Int32
  fun nl_addr_is_broadcast = nl_addr_is_broadcast(addr : Pointer(NL_Addr)) : Int32

  # ---- Bit operations ----------------------------------------------------
  fun nl_addr_fill_sockaddr = nl_addr_fill_sockaddr(addr : Pointer(NL_Addr), sa : Pointer(Void), salen : Int32*) : Int32
  fun nl_addr_parse_sockaddr = nl_addr_parse_sockaddr(sa : Pointer(Void), salen : Int32, result : Pointer(Pointer(NL_Addr))) : Int32
end
