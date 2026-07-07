# src/nl/genl/family.cr
#
# High‑level wrapper for Generic Netlink families.

module Nl::Genl
  ##
  # A Generic Netlink family.
  #
  # Provides access to family attributes (ID, name, version, header size,
  # maximum attribute), multicast groups, and operations (commands).
  class Family
    @ptr : Pointer(LibNLGenl::GenlFamily)
    @owned : Bool

    # Allocates a new family object.
    def initialize
      @ptr = LibNLGenl.genl_family_alloc
      raise Error.from_ret(-1) if @ptr.null?
      @owned = true
    end

    # Wraps an existing family pointer.
    def initialize(ptr : Pointer(LibNLGenl::GenlFamily), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the family if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLGenl.genl_family_put(@ptr)
        @ptr = Pointer(LibNLGenl::GenlFamily).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Allocate a family cache -----------------------------------------
    #
    # Returns a cache containing all Generic Netlink families.
    def self.cache(sk : Socket) : Cache
      cptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLGenl.genl_ctrl_alloc_cache(sk.to_unsafe, pointerof(cptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cptr)
    end

    # --- Lookup by name or ID --------------------------------------------
    #
    # Looks up a family by name in the cache.
    def self.by_name(cache : Cache, name : String) : Family?
      ptr = LibNLGenl.genl_ctrl_search_by_name(cache.to_unsafe, name.to_unsafe)
      return nil if ptr.null?
      Family.new(ptr, owned: false)
    end

    # Looks up a family by ID in the cache.
    def self.by_id(cache : Cache, id : Int32) : Family?
      ptr = LibNLGenl.genl_ctrl_search_by_id(cache.to_unsafe, id)
      return nil if ptr.null?
      Family.new(ptr, owned: false)
    end

    # --- Resolve name to ID (without cache) -----------------------------
    #
    # Resolves a family name to its numeric ID.
    def self.resolve(sk : Socket, name : String) : Int32
      id = LibNLGenl.genl_ctrl_resolve(sk.to_unsafe, name.to_unsafe)
      raise Error.from_ret(id) if id < 0
      id
    end

    # --- Family attributes (getters) -------------------------------------
    #
    # Returns the family ID.
    def id : UInt16
      LibNLGenl.genl_family_get_id(@ptr)
    end

    # Returns the family name.
    def name : String
      ptr = LibNLGenl.genl_family_get_name(@ptr)
      String.new(ptr)
    end

    # Returns the family version.
    def version : UInt8
      LibNLGenl.genl_family_get_version(@ptr)
    end

    # Returns the header size.
    def hdrsize : UInt32
      LibNLGenl.genl_family_get_hdrsize(@ptr)
    end

    # Returns the maximum attribute type.
    def maxattr : UInt32
      LibNLGenl.genl_family_get_maxattr(@ptr)
    end

    # --- Multicast groups ------------------------------------------------
    #
    # Returns the number of multicast groups.
    def mc_grp_count : UInt32
      LibNLGenl.genl_family_get_mc_grp_count(@ptr)
    end

    # Returns the name of the multicast group at the given index.
    def mc_grp_name(index : UInt32) : String
      ptr = LibNLGenl.genl_family_get_mc_grp_name(@ptr, index)
      String.new(ptr)
    end

    # Returns the ID of the multicast group at the given index.
    def mc_grp_id(index : UInt32) : UInt32
      LibNLGenl.genl_family_get_mc_grp_id(@ptr, index)
    end

    # --- Operations (commands) -------------------------------------------
    #
    # Returns the number of operations (commands) the family supports.
    def ops_count : UInt32
      LibNLGenl.genl_family_get_ops_count(@ptr)
    end

    # Returns the operation ID at the given index.
    def op_id(index : UInt32) : UInt32
      LibNLGenl.genl_family_get_op_id(@ptr, index)
    end

    # Returns the operation flags at the given index.
    def op_flags(index : UInt32) : UInt32
      LibNLGenl.genl_family_get_op_flags(@ptr, index)
    end

    # --- Add / Delete (to kernel) ----------------------------------------
    #
    # Adds a new family to the kernel (requires appropriate privileges).
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLGenl.genl_family_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the family from the kernel.
    def delete(sk : Socket) : Nil
      ret = LibNLGenl.genl_family_delete(sk.to_unsafe, @ptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer -------------------------------------------------------
    def finalize
      free
    end
  end
end
