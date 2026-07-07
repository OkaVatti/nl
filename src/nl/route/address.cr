# src/nl/route/address.cr
#
# High‑level wrapper for network addresses (IP addresses).

module Nl::Route
  ##
  # A network address (IP address with optional prefix length, scope, flags).
  class Address
    @ptr : Pointer(LibNLRoute::Rtnl_Addr)
    @owned : Bool

    # Allocates a new address object.
    def initialize
      @ptr = LibNLRoute.rtnl_addr_alloc
      raise Error.new("Failed to allocate address") if @ptr.null?
      @owned = true
    end

    # Wraps an existing address pointer (e.g., from a cache).
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Addr), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the address if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_addr_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Addr).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Allocate a cache ------------------------------------------------
    #
    # Returns a cache containing all network addresses.
    def self.cache(sk : Socket) : Cache
      cache_ptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_addr_alloc_cache(sk.to_unsafe, pointerof(cache_ptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cache_ptr)
    end

    # --- Getters / Setters ------------------------------------------------
    #
    # Sets the interface label (e.g., "eth0:1").
    def label=(label : String) : Nil
      ret = LibNLRoute.rtnl_addr_set_label(@ptr, label.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the interface label, or `nil` if not set.
    def label : String?
      ptr = LibNLRoute.rtnl_addr_get_label(@ptr)
      ptr.null? ? nil : String.new(ptr)
    end

    # Sets the interface index.
    def ifindex=(idx : Int32) : Nil
      LibNLRoute.rtnl_addr_set_ifindex(@ptr, idx)
    end

    # Returns the interface index.
    def ifindex : Int32
      LibNLRoute.rtnl_addr_get_ifindex(@ptr)
    end

    # Sets the address family (e.g., `LibNL::AF_INET`).
    def family=(fam : Int32) : Nil
      LibNLRoute.rtnl_addr_set_family(@ptr, fam)
    end

    # Returns the address family.
    def family : Int32
      LibNLRoute.rtnl_addr_get_family(@ptr)
    end

    # Sets the prefix length (netmask).
    def prefixlen=(len : Int32) : Nil
      LibNLRoute.rtnl_addr_set_prefixlen(@ptr, len)
    end

    # Returns the prefix length.
    def prefixlen : Int32
      LibNLRoute.rtnl_addr_get_prefixlen(@ptr)
    end

    # Sets the scope (e.g., `RT_SCOPE_UNIVERSE`, `RT_SCOPE_LINK`).
    def scope=(sc : Int32) : Nil
      LibNLRoute.rtnl_addr_set_scope(@ptr, sc)
    end

    # Returns the scope.
    def scope : Int32
      LibNLRoute.rtnl_addr_get_scope(@ptr)
    end

    # Sets the address flags.
    def flags=(fl : UInt32) : Nil
      LibNLRoute.rtnl_addr_set_flags(@ptr, fl)
    end

    # Returns the address flags.
    def flags : UInt32
      LibNLRoute.rtnl_addr_get_flags(@ptr)
    end

    # Sets the local IP address (the address itself).
    def local=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_addr_set_local(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the local IP address.
    def local : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_addr_get_local(@ptr)
    end

    # --- Add / Delete ----------------------------------------------------
    #
    # Adds the address to the kernel.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_addr_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the address from the kernel.
    def delete(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_addr_delete(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
