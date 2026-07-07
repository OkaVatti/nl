# src/nl/route/link.cr
#
# High-level wrapper for network links (interfaces).

module Nl::Route
  class Link
    @ptr : Pointer(LibNLRoute::Rtnl_Link)
    @owned : Bool

    # Allocates a new link object.
    def initialize
      @ptr = LibNLRoute.rtnl_link_alloc
      raise Error.new("Failed to allocate link") if @ptr.null?
      @owned = true
    end

    # Wraps an existing link pointer (e.g., from cache).
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Link), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the link if owned.
    def free
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_link_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Link).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Allocate a link cache --------------------------------------------
    def self.cache(sk : Socket, family : Int32 = LibNL::AF_UNSPEC) : Cache
      cache_ptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_link_alloc_cache(sk.to_unsafe, family, pointerof(cache_ptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cache_ptr)
    end

    # --- Get link by ifindex or name from cache ---------------------------
    def self.get(cache : Cache, ifindex : Int32) : Link?
      link_ptr = LibNLRoute.rtnl_link_get(cache.to_unsafe, ifindex)
      return nil if link_ptr.null?
      Link.new(link_ptr, owned: false)
    end

    def self.get_by_name(cache : Cache, name : String) : Link?
      link_ptr = LibNLRoute.rtnl_link_get_by_name(cache.to_unsafe, name.to_unsafe)
      return nil if link_ptr.null?
      Link.new(link_ptr, owned: false)
    end

    # --- Basic getters / setters -------------------------------------------
    def name=(name : String)
      ret = LibNLRoute.rtnl_link_set_name(@ptr, name.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    def name : String?
      ptr = LibNLRoute.rtnl_link_get_name(@ptr)
      ptr.null? ? nil : String.new(ptr)
    end

    def ifindex=(idx : Int32)
      LibNLRoute.rtnl_link_set_ifindex(@ptr, idx)
    end

    def ifindex : Int32
      LibNLRoute.rtnl_link_get_ifindex(@ptr)
    end

    def mtu=(mtu : UInt32)
      LibNLRoute.rtnl_link_set_mtu(@ptr, mtu)
    end

    def mtu : UInt32
      LibNLRoute.rtnl_link_get_mtu(@ptr)
    end

    def flags=(flags : UInt32)
      LibNLRoute.rtnl_link_set_flags(@ptr, flags)
    end

    def flags : UInt32
      LibNLRoute.rtnl_link_get_flags(@ptr)
    end

    def unset_flags(flags : UInt32)
      LibNLRoute.rtnl_link_unset_flags(@ptr, flags)
    end

    def state=(state : UInt8)
      LibNLRoute.rtnl_link_set_state(@ptr, state)
    end

    def state : UInt8
      LibNLRoute.rtnl_link_get_state(@ptr)
    end

    def operstate : UInt8
      LibNLRoute.rtnl_link_get_operstate(@ptr)
    end

    def address=(addr : Pointer(LibNL::NL_Addr))
      ret = LibNLRoute.rtnl_link_set_addr(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    def address : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_link_get_addr(@ptr)
    end

    # --- Link type detection ----------------------------------------------
    #
    # Returns the kind string (e.g., "vlan", "bridge", "bond", "vxlan", etc.)
    # or nil if the link is not a virtual type.
    def kind : String?
      LibNLRouteHelpers.link_get_kind(@ptr)
    end

    # Returns true if the link is a VLAN.
    def vlan? : Bool
      kind == "vlan"
    end

    # Returns true if the link is a bridge.
    def bridge? : Bool
      kind == "bridge"
    end

    # Returns true if the link is a bond.
    def bond? : Bool
      kind == "bond"
    end

    # Returns true if the link is a VXLAN.
    def vxlan? : Bool
      kind == "vxlan"
    end

    # Returns true if the link is a MACVLAN.
    def macvlan? : Bool
      kind == "macvlan"
    end

    # Returns true if the link is a VETH.
    def veth? : Bool
      kind == "veth"
    end

    # Returns true if the link is a dummy.
    def dummy? : Bool
      kind == "dummy"
    end

    # Returns true if the link is a CAN.
    def can? : Bool
      kind == "can"
    end

    # Returns true if the link is a SIT tunnel.
    def sit? : Bool
      kind == "sit"
    end

    # Returns true if the link is an IP6TNL tunnel.
    def ip6tnl? : Bool
      kind == "ip6tnl"
    end

    # --- Add / Delete / Change --------------------------------------------
    def add(sk : Socket, flags : Int32 = 0)
      ret = LibNLRoute.rtnl_link_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    def delete(sk : Socket)
      ret = LibNLRoute.rtnl_link_delete(sk.to_unsafe, @ptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- VLAN specific ----------------------------------------------------
    def vlan_set_id(id : UInt16)
      ret = LibNLRoute.rtnl_link_vlan_set_id(@ptr, id)
      raise Error.from_ret(ret) if ret < 0
    end

    def vlan_id : UInt16
      LibNLRoute.rtnl_link_vlan_get_id(@ptr)
    end

    # --- Bridge specific --------------------------------------------------
    def bridge_set_ageing_time(time : UInt32)
      ret = LibNLRoute.rtnl_link_bridge_set_ageing_time(@ptr, time)
      raise Error.from_ret(ret) if ret < 0
    end

    def bridge_ageing_time : UInt32
      LibNLRoute.rtnl_link_bridge_get_ageing_time(@ptr)
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
