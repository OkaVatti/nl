# src/nl/route/neighbour.cr
#
# High‑level wrapper for neighbour (ARP/NDP) entries.

module Nl::Route
  ##
  # A neighbour (ARP/NDP) entry.
  class Neighbour
    @ptr : Pointer(LibNLRoute::Rtnl_Neigh)
    @owned : Bool

    # Allocates a new neighbour object.
    def initialize
      @ptr = LibNLRoute.rtnl_neigh_alloc
      raise Error.from_ret(-1) if @ptr.null? # allocation failure
      @owned = true
    end

    # Wraps an existing neighbour pointer.
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Neigh), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the neighbour if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_neigh_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Neigh).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Allocate a neighbour cache ---------------------------------------
    #
    # Returns a cache containing all neighbour entries.
    def self.cache(sk : Socket) : Cache
      cache_ptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_neigh_alloc_cache(sk.to_unsafe, pointerof(cache_ptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cache_ptr)
    end

    # --- Lookup a neighbour by ifindex and destination address ------------
    #
    # Returns the neighbour entry matching the given interface and destination.
    def self.get(cache : Cache, ifindex : Int32, dst : Pointer(LibNL::NL_Addr)) : Neighbour?
      ptr = LibNLRoute.rtnl_neigh_get(cache.to_unsafe, ifindex, dst)
      return nil if ptr.null?
      Neighbour.new(ptr, owned: false)
    end

    # --- Basic attributes (getters/setters) -----------------------------
    #
    # Sets the address family.
    def family=(fam : Int32) : Nil
      LibNLRoute.rtnl_neigh_set_family(@ptr, fam)
    end

    # Returns the address family.
    def family : Int32
      LibNLRoute.rtnl_neigh_get_family(@ptr)
    end

    # Sets the interface index.
    def ifindex=(idx : Int32) : Nil
      LibNLRoute.rtnl_neigh_set_ifindex(@ptr, idx)
    end

    # Returns the interface index.
    def ifindex : Int32
      LibNLRoute.rtnl_neigh_get_ifindex(@ptr)
    end

    # Sets the neighbour state (a combination of `RtnlNeighState` bits).
    def state=(st : UInt16) : Nil
      LibNLRoute.rtnl_neigh_set_state(@ptr, st)
    end

    # Returns the neighbour state.
    def state : UInt16
      LibNLRoute.rtnl_neigh_get_state(@ptr)
    end

    # Sets the neighbour flags (a combination of `RtnlNeighFlag` bits).
    def flags=(fl : UInt8) : Nil
      LibNLRoute.rtnl_neigh_set_flags(@ptr, fl)
    end

    # Returns the neighbour flags.
    def flags : UInt8
      LibNLRoute.rtnl_neigh_get_flags(@ptr)
    end

    # Sets the neighbour type (e.g., `RTN_UNICAST`).
    def type=(typ : UInt8) : Nil
      LibNLRoute.rtnl_neigh_set_type(@ptr, typ)
    end

    # Returns the neighbour type.
    def type : UInt8
      LibNLRoute.rtnl_neigh_get_type(@ptr)
    end

    # Sets the destination address.
    def dst=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_neigh_set_dst(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the destination address.
    def dst : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_neigh_get_dst(@ptr)
    end

    # Sets the link‑layer address.
    def lladdr=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_neigh_set_lladdr(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the link‑layer address.
    def lladdr : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_neigh_get_lladdr(@ptr)
    end

    # --- Add / Delete ----------------------------------------------------
    #
    # Adds the neighbour entry.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_neigh_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the neighbour entry.
    def delete(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_neigh_delete(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Cache info (read‑only) ------------------------------------------
    #
    # Returns the confirmation timestamp.
    def confirmed : UInt32
      LibNLRoute.rtnl_neigh_get_confirmed(@ptr)
    end

    # Returns the last used timestamp.
    def used : UInt32
      LibNLRoute.rtnl_neigh_get_used(@ptr)
    end

    # Returns the last updated timestamp.
    def updated : UInt32
      LibNLRoute.rtnl_neigh_get_updated(@ptr)
    end

    # Returns the reference count.
    def refcnt : Int32
      LibNLRoute.rtnl_neigh_get_refcnt(@ptr)
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
