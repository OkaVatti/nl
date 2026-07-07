# src/libnl/core/data.cr
#
# Netlink data container for arbitrary binary data.

@[Link("nl-3")]
lib LibNL
  # ---- Allocation / Free / Reference counting ----------------------------

  fun nl_data_alloc = nl_data_alloc(data : Pointer(Void), len : LibC::SizeT) : Pointer(NL_Data)
  fun nl_data_alloc_attr = nl_data_alloc_attr(attr : Pointer(NL_Attr)) : Pointer(NL_Data)
  fun nl_data_clone = nl_data_clone(orig : Pointer(NL_Data)) : Pointer(NL_Data)
  fun nl_data_get = nl_data_get(data : Pointer(NL_Data)) : Void
  fun nl_data_put = nl_data_put(data : Pointer(NL_Data)) : Void
  fun nl_data_free = nl_data_free(data : Pointer(NL_Data)) : Void

  # ---- Accessors ---------------------------------------------------------

  fun nl_data_get_size = nl_data_get_size(data : Pointer(NL_Data)) : LibC::SizeT
  fun nl_data_get_pointer = nl_data_get_pointer(data : Pointer(NL_Data)) : Pointer(Void)

  # ---- Appending ---------------------------------------------------------

  fun nl_data_append = nl_data_append(data : Pointer(NL_Data), bytes : Pointer(Void), len : LibC::SizeT) : Int32
  fun nl_data_append_data = nl_data_append_data(data : Pointer(NL_Data), bytes : Pointer(Void), len : LibC::SizeT) : Int32 # same as above

  # ---- Comparison --------------------------------------------------------

  fun nl_data_cmp = nl_data_cmp(a : Pointer(NL_Data), b : Pointer(NL_Data)) : Int32

  # ---- Convert from/to attr ----------------------------------------------

  fun nl_data_from_attr = nl_data_from_attr(attr : Pointer(NL_Attr)) : Pointer(NL_Data)
end

# Also need to define the opaque NL_Data struct in types.cr if not already present.
# Add to src/libnl/core/types.cr:
# @[Extern]
# struct NL_Data
#   _unused : UInt8
# end
