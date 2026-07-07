# src/nl/genl.cr
#
# High‑level helpers for Generic Netlink family discovery.

module Nl::Genl
  # Resolves a family name to its numeric ID.
  #
  # Sends a request to the kernel and returns the family ID, or raises
  # `Nl::Error` if the family is not found.
  def self.resolve(sk : Socket, name : String) : Int32
    id = LibNLGenl.genl_ctrl_resolve(sk.to_unsafe, name.to_unsafe)
    raise Error.from_ret(id) if id < 0
    id
  end

  # Allocates a cache containing all Generic Netlink families.
  def self.cache(sk : Socket) : Cache
    cptr = Pointer(LibNL::NL_Cache).null
    ret = LibNLGenl.genl_ctrl_alloc_cache(sk.to_unsafe, pointerof(cptr))
    raise Error.from_ret(ret) if ret < 0
    Cache.new(cptr)
  end

  # Looks up a family by name in the given cache.
  #
  # Returns a `Family` object, or raises `Nl::NotFoundError` if not found.
  def self.family_by_name(cache : Cache, name : String) : Family
    fam = LibNLGenl.genl_ctrl_search_by_name(cache.to_unsafe, name.to_unsafe)
    raise NotFoundError.new("Family '#{name}' not found") if fam.null?
    Family.new(fam, owned: false)
  end

  # Looks up a family by ID in the given cache.
  #
  # Returns a `Family` object, or raises `Nl::NotFoundError` if not found.
  def self.family_by_id(cache : Cache, id : Int32) : Family
    fam = LibNLGenl.genl_ctrl_search_by_id(cache.to_unsafe, id)
    raise NotFoundError.new("Family with ID #{id} not found") if fam.null?
    Family.new(fam, owned: false)
  end

  # Resolves a family name and returns the corresponding `Family` object.
  #
  # This is a convenience method that allocates a cache internally.
  def self.get_family(sk : Socket, name : String) : Family
    cache = self.cache(sk)
    family_by_name(cache, name)
  end
end
