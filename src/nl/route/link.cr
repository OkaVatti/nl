# src/nl/route/link.cr
#
# High‑level wrapper for network links (interfaces).

module Nl::Route
  ##
  # A network link (interface).
  #
  # Represents a network interface, providing access to its attributes
  # (name, MTU, flags, address, etc.) and supporting operations like
  # add/delete/change for virtual links (VLAN, bridge, bond, VXLAN, etc.).
  class Link
    @ptr : Pointer(LibNLRoute::Rtnl_Link)
    @owned : Bool

    # Allocates a new link object.
    def initialize
      @ptr = LibNLRoute.rtnl_link_alloc
      raise Error.new("Failed to allocate link") if @ptr.null?
      @owned = true
    end

    # Wraps an existing link pointer (e.g., from a cache).
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Link), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the link if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_link_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Link).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Allocate a link cache --------------------------------------------
    #
    # Returns a cache containing all network links.
    def self.cache(sk : Socket, family : Int32 = LibNL::AF_UNSPEC) : Cache
      cache_ptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_link_alloc_cache(sk.to_unsafe, family, pointerof(cache_ptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cache_ptr)
    end

    # --- Get link by ifindex or name from cache ---------------------------
    #
    # Look up a link by its interface index.
    def self.get(cache : Cache, ifindex : Int32) : Link?
      link_ptr = LibNLRoute.rtnl_link_get(cache.to_unsafe, ifindex)
      return nil if link_ptr.null?
      Link.new(link_ptr, owned: false)
    end

    # Look up a link by its name.
    def self.get_by_name(cache : Cache, name : String) : Link?
      link_ptr = LibNLRoute.rtnl_link_get_by_name(cache.to_unsafe, name.to_unsafe)
      return nil if link_ptr.null?
      Link.new(link_ptr, owned: false)
    end

    # --- Basic getters / setters -------------------------------------------
    #
    # Sets the name of the link.
    def name=(name : String) : Nil
      ret = LibNLRoute.rtnl_link_set_name(@ptr, name.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the name of the link, or `nil` if not set.
    def name : String?
      ptr = LibNLRoute.rtnl_link_get_name(@ptr)
      ptr.null? ? nil : String.new(ptr)
    end

    # Sets the interface index.
    def ifindex=(idx : Int32) : Nil
      LibNLRoute.rtnl_link_set_ifindex(@ptr, idx)
    end

    # Returns the interface index.
    def ifindex : Int32
      LibNLRoute.rtnl_link_get_ifindex(@ptr)
    end

    # Sets the MTU.
    def mtu=(mtu : UInt32) : Nil
      LibNLRoute.rtnl_link_set_mtu(@ptr, mtu)
    end

    # Returns the MTU.
    def mtu : UInt32
      LibNLRoute.rtnl_link_get_mtu(@ptr)
    end

    # Sets the link flags.
    def flags=(flags : UInt32) : Nil
      LibNLRoute.rtnl_link_set_flags(@ptr, flags)
    end

    # Returns the link flags.
    def flags : UInt32
      LibNLRoute.rtnl_link_get_flags(@ptr)
    end

    # Unsets the given flags.
    def unset_flags(flags : UInt32) : Nil
      LibNLRoute.rtnl_link_unset_flags(@ptr, flags)
    end

    # Sets the administrative state (UP/DOWN).
    def state=(state : UInt8) : Nil
      LibNLRoute.rtnl_link_set_state(@ptr, state)
    end

    # Returns the administrative state.
    def state : UInt8
      LibNLRoute.rtnl_link_get_state(@ptr)
    end

    # Returns the operational state.
    def operstate : UInt8
      LibNLRoute.rtnl_link_get_operstate(@ptr)
    end

    # Sets the hardware address.
    def address=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_link_set_addr(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the hardware address.
    def address : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_link_get_addr(@ptr)
    end

    # --- Link type detection ----------------------------------------------
    #
    # Returns `true` if the link is a VLAN.
    def vlan? : Bool
      LibNLRoute.rtnl_link_is_vlan(@ptr) == 1
    end

    # Returns `true` if the link is a bridge.
    def bridge? : Bool
      LibNLRoute.rtnl_link_is_bridge(@ptr) == 1
    end

    # Returns `true` if the link is a bond.
    def bond? : Bool
      LibNLRoute.rtnl_link_is_bond(@ptr) == 1
    end

    # Returns `true` if the link is a VXLAN.
    def vxlan? : Bool
      LibNLRoute.rtnl_link_is_vxlan(@ptr) == 1
    end

    # --- Add / Delete / Change --------------------------------------------
    #
    # Adds the link (must be a virtual link type, e.g., VLAN, bridge, etc.).
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_link_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the link.
    def delete(sk : Socket) : Nil
      ret = LibNLRoute.rtnl_link_delete(sk.to_unsafe, @ptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- VLAN specific ----------------------------------------------------
    #
    # Sets the VLAN ID.
    def vlan_set_id(id : UInt16) : Nil
      ret = LibNLRoute.rtnl_link_vlan_set_id(@ptr, id)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the VLAN ID.
    def vlan_id : UInt16
      LibNLRoute.rtnl_link_vlan_get_id(@ptr)
    end

    # --- Bridge specific --------------------------------------------------
    #
    # Sets the bridge ageing time.
    def bridge_set_ageing_time(time : UInt32) : Nil
      ret = LibNLRoute.rtnl_link_bridge_set_ageing_time(@ptr, time)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the bridge ageing time.
    def bridge_ageing_time : UInt32
      LibNLRoute.rtnl_link_bridge_get_ageing_time(@ptr)
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
