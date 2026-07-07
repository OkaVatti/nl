# src/libnl/core/cache.cr
#
# Cache management – allocation, filling, and operations.

@[Link("nl-3")]
lib LibNL
  # ---- Cache allocation / free --------------------------------------------

  fun nl_cache_alloc = nl_cache_alloc(ops : Pointer(NL_Cache_Ops)) : Pointer(NL_Cache)
  fun nl_cache_alloc_name = nl_cache_alloc_name(kind : LibC::Char*) : Pointer(NL_Cache)
  fun nl_cache_free = nl_cache_free(cache : Pointer(NL_Cache)) : Void

  # ---- Cache filling ------------------------------------------------------

  fun nl_cache_refill = nl_cache_refill(sk : Pointer(NL_Sock), cache : Pointer(NL_Cache)) : Int32
  fun nl_cache_pickup = nl_cache_pickup(sk : Pointer(NL_Sock), cache : Pointer(NL_Cache)) : Int32
  fun nl_cache_resync = nl_cache_resync(sk : Pointer(NL_Sock), cache : Pointer(NL_Cache), arg : Pointer(Void)) : Int32
  fun nl_cache_clear = nl_cache_clear(cache : Pointer(NL_Cache)) : Void

  # ---- Cache operations lookup --------------------------------------------

  fun nl_cache_ops_lookup = nl_cache_ops_lookup(name : LibC::Char*) : Pointer(NL_Cache_Ops)
  fun nl_cache_ops_lookup_safe = nl_cache_ops_lookup_safe(name : LibC::Char*) : Pointer(NL_Cache_Ops)
  fun nl_cache_ops_associate = nl_cache_ops_associate(protocol : Int32, msgtype : Int32) : Pointer(NL_Cache_Ops)
  fun nl_cache_ops_associate_safe = nl_cache_ops_associate_safe(protocol : Int32, msgtype : Int32) : Pointer(NL_Cache_Ops)

  fun nl_cache_ops_get = nl_cache_ops_get(ops : Pointer(NL_Cache_Ops)) : Void
  fun nl_cache_ops_put = nl_cache_ops_put(ops : Pointer(NL_Cache_Ops)) : Void

  # ---- Message type association -------------------------------------------

  fun nl_msgtype_lookup = nl_msgtype_lookup(ops : Pointer(NL_Cache_Ops), msgtype : Int32) : Pointer(Void)

  # ---- Iteration over all cache operations --------------------------------

  fun nl_cache_ops_foreach = nl_cache_ops_foreach(cb : (Pointer(NL_Cache_Ops), Pointer(Void) -> Void), arg : Pointer(Void)) : Void

  # ---- Flags --------------------------------------------------------------

  fun nl_cache_ops_set_flags = nl_cache_ops_set_flags(ops : Pointer(NL_Cache_Ops), flags : UInt32) : Void

  # ---- Registration (for custom cache types) ------------------------------

  fun nl_cache_mngt_register = nl_cache_mngt_register(ops : Pointer(NL_Cache_Ops)) : Int32
  fun nl_cache_mngt_unregister = nl_cache_mngt_unregister(ops : Pointer(NL_Cache_Ops)) : Int32

  # ---- Additional cache operations -----------------------------------------
  fun nl_cache_nitems = nl_cache_nitems(
    cache : Pointer(NL_Cache),
  ) : Int32

  fun nl_cache_nitems_filter = nl_cache_nitems_filter(
    cache : Pointer(NL_Cache),
    filter : Pointer(NL_Object),
  ) : Int32

  fun nl_cache_get_ops = nl_cache_get_ops(
    cache : Pointer(NL_Cache),
  ) : Pointer(NL_Cache_Ops)

  fun nl_cache_get_first = nl_cache_get_first(
    cache : Pointer(NL_Cache),
  ) : Pointer(NL_Object)

  fun nl_cache_get_last = nl_cache_get_last(
    cache : Pointer(NL_Cache),
  ) : Pointer(NL_Object)

  fun nl_cache_get_next = nl_cache_get_next(
    obj : Pointer(NL_Object),
  ) : Pointer(NL_Object)

  fun nl_cache_get_prev = nl_cache_get_prev(
    obj : Pointer(NL_Object),
  ) : Pointer(NL_Object)

  fun nl_cache_alloc_and_fill = nl_cache_alloc_and_fill(
    ops : Pointer(NL_Cache_Ops),
    sk : Pointer(NL_Sock),
    result : Pointer(Pointer(NL_Cache)),
  ) : Int32

  fun nl_cache_subset = nl_cache_subset(
    cache : Pointer(NL_Cache),
    filter : Pointer(NL_Object),
  ) : Pointer(NL_Cache)

  fun nl_cache_clone = nl_cache_clone(
    cache : Pointer(NL_Cache),
  ) : Pointer(NL_Cache)

  fun nl_cache_get = nl_cache_get(
    cache : Pointer(NL_Cache),
  ) : Void

  fun nl_cache_put = nl_cache_put(
    cache : Pointer(NL_Cache),
  ) : Void

  fun nl_cache_add = nl_cache_add(
    cache : Pointer(NL_Cache),
    obj : Pointer(NL_Object),
  ) : Int32

  fun nl_cache_parse_and_add = nl_cache_parse_and_add(
    cache : Pointer(NL_Cache),
    msg : Pointer(NL_Msg),
  ) : Int32

  fun nl_cache_move = nl_cache_move(
    cache : Pointer(NL_Cache),
    obj : Pointer(NL_Object),
  ) : Int32

  fun nl_cache_remove = nl_cache_remove(
    obj : Pointer(NL_Object),
  ) : Void

  fun nl_cache_pickup_checkdup = nl_cache_pickup_checkdup(
    sk : Pointer(NL_Sock),
    cache : Pointer(NL_Cache),
  ) : Int32

  fun nl_cache_resync_v2 = nl_cache_resync_v2(
    sk : Pointer(NL_Sock),
    cache : Pointer(NL_Cache),
    cb : ChangeFuncV2T,
    arg : Pointer(Void),
  ) : Int32

  fun nl_cache_include = nl_cache_include(
    cache : Pointer(NL_Cache),
    obj : Pointer(NL_Object),
    cb : ChangeFuncT,
    arg : Pointer(Void),
  ) : Int32

  fun nl_cache_include_v2 = nl_cache_include_v2(
    cache : Pointer(NL_Cache),
    obj : Pointer(NL_Object),
    cb : ChangeFuncV2T,
    arg : Pointer(Void),
  ) : Int32

  fun nl_cache_set_arg1 = nl_cache_set_arg1(
    cache : Pointer(NL_Cache),
    arg : Int32,
  ) : Void

  fun nl_cache_set_arg2 = nl_cache_set_arg2(
    cache : Pointer(NL_Cache),
    arg : Int32,
  ) : Void

  fun nl_cache_set_flags = nl_cache_set_flags(
    cache : Pointer(NL_Cache),
    flags : UInt32,
  ) : Void

  fun nl_cache_is_empty = nl_cache_is_empty(
    cache : Pointer(NL_Cache),
  ) : Int32

  fun nl_cache_search = nl_cache_search(
    cache : Pointer(NL_Cache),
    needle : Pointer(NL_Object),
  ) : Pointer(NL_Object)

  fun nl_cache_find = nl_cache_find(
    cache : Pointer(NL_Cache),
    filter : Pointer(NL_Object),
  ) : Pointer(NL_Object)

  fun nl_cache_mark_all = nl_cache_mark_all(
    cache : Pointer(NL_Cache),
  ) : Void

  fun nl_cache_dump = nl_cache_dump(
    cache : Pointer(NL_Cache),
    params : Pointer(NL_DumpParams),
  ) : Void

  fun nl_cache_dump_filter = nl_cache_dump_filter(
    cache : Pointer(NL_Cache),
    params : Pointer(NL_DumpParams),
    filter : Pointer(NL_Object),
  ) : Void

  fun nl_cache_foreach = nl_cache_foreach(
    cache : Pointer(NL_Cache),
    cb : (Pointer(NL_Object), Pointer(Void) -> Void),
    arg : Pointer(Void),
  ) : Void
end
