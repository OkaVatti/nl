# src/libnl/core/object.cr
#
# Generic cacheable object management.

@[Link("nl-3")]
lib LibNL
  # ---- Allocation / Free / Clone ------------------------------------------

  fun nl_object_alloc = nl_object_alloc(ops : Pointer(NL_Object_Ops)) : Pointer(NL_Object)
  fun nl_object_alloc_name = nl_object_alloc_name(kind : LibC::Char*, result : Pointer(Pointer(NL_Object))) : Int32
  fun nl_object_clone = nl_object_clone(obj : Pointer(NL_Object)) : Pointer(NL_Object)
  fun nl_object_free = nl_object_free(obj : Pointer(NL_Object)) : Void

  # ---- Reference counting -------------------------------------------------

  fun nl_object_get = nl_object_get(obj : Pointer(NL_Object)) : Void
  fun nl_object_put = nl_object_put(obj : Pointer(NL_Object)) : Void
  fun nl_object_shared = nl_object_shared(obj : Pointer(NL_Object)) : Int32

  # ---- Marks --------------------------------------------------------------

  fun nl_object_mark = nl_object_mark(obj : Pointer(NL_Object)) : Void
  fun nl_object_unmark = nl_object_unmark(obj : Pointer(NL_Object)) : Void
  fun nl_object_is_marked = nl_object_is_marked(obj : Pointer(NL_Object)) : Int32

  # ---- Update / merge -----------------------------------------------------

  fun nl_object_update = nl_object_update(dst : Pointer(NL_Object), src : Pointer(NL_Object)) : Int32

  # ---- Dump / pretty‑print ------------------------------------------------

  fun nl_object_dump = nl_object_dump(obj : Pointer(NL_Object), params : Pointer(Void)) : Void
  fun nl_object_dump_buf = nl_object_dump_buf(obj : Pointer(NL_Object), buf : LibC::Char*, len : LibC::SizeT) : Void

  # ---- Additional object operations ----------------------------------------
  fun nl_object_get_refcnt = nl_object_get_refcnt(
    obj : Pointer(NL_Object),
  ) : Int32

  fun nl_object_get_cache = nl_object_get_cache(
    obj : Pointer(NL_Object),
  ) : Pointer(NL_Cache)

  fun nl_object_get_type = nl_object_get_type(
    obj : Pointer(NL_Object),
  ) : LibC::Char*

  fun nl_object_get_msgtype = nl_object_get_msgtype(
    obj : Pointer(NL_Object),
  ) : Int32

  fun nl_object_get_ops = nl_object_get_ops(
    obj : Pointer(NL_Object),
  ) : Pointer(NL_Object_Ops)

  fun nl_object_get_id_attrs = nl_object_get_id_attrs(
    obj : Pointer(NL_Object),
  ) : UInt32

  fun nl_object_identical = nl_object_identical(
    a : Pointer(NL_Object),
    b : Pointer(NL_Object),
  ) : Int32

  fun nl_object_diff = nl_object_diff(
    a : Pointer(NL_Object),
    b : Pointer(NL_Object),
  ) : UInt32

  fun nl_object_diff64 = nl_object_diff64(
    a : Pointer(NL_Object),
    b : Pointer(NL_Object),
  ) : UInt64

  fun nl_object_match_filter = nl_object_match_filter(
    obj : Pointer(NL_Object),
    filter : Pointer(NL_Object),
  ) : Int32

  fun nl_object_attrs2str = nl_object_attrs2str(
    obj : Pointer(NL_Object),
    attrs : UInt32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun nl_object_attr_list = nl_object_attr_list(
    obj : Pointer(NL_Object),
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun nl_object_keygen = nl_object_keygen(
    obj : Pointer(NL_Object),
    key : Pointer(UInt32),
    key_size : UInt32,
  ) : Void
end
