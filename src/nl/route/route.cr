# src/nl/route/route.cr
#
# High‑level wrapper for routing table entries.

module Nl::Route
  ##
  # A routing table entry.
  class Route
    @ptr : Pointer(LibNLRoute::Rtnl_Route)
    @owned : Bool

    # Allocates a new route object.
    def initialize
      @ptr = LibNLRoute.rtnl_route_alloc
      raise Error.new("Failed to allocate route") if @ptr.null?
      @owned = true
    end

    # Wraps an existing route pointer (e.g., from a cache).
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Route), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the route if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_route_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Route).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Cache allocation ------------------------------------------------
    #
    # Returns a cache containing all routes.
    def self.cache(sk : Socket, family : Int32 = LibNL::AF_UNSPEC, flags : Int32 = 0) : Cache
      cache_ptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_route_alloc_cache(sk.to_unsafe, family, flags, pointerof(cache_ptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cache_ptr)
    end

    # --- Basic attributes ------------------------------------------------
    #
    # Sets the routing table ID (e.g., 254 for main).
    def table=(tbl : UInt32) : Nil
      LibNLRoute.rtnl_route_set_table(@ptr, tbl)
    end

    # Returns the routing table ID.
    def table : UInt32
      LibNLRoute.rtnl_route_get_table(@ptr)
    end

    # Sets the scope.
    def scope=(sc : UInt8) : Nil
      LibNLRoute.rtnl_route_set_scope(@ptr, sc)
    end

    # Returns the scope.
    def scope : UInt8
      LibNLRoute.rtnl_route_get_scope(@ptr)
    end

    # Sets the TOS (Type of Service).
    def tos=(tos : UInt8) : Nil
      LibNLRoute.rtnl_route_set_tos(@ptr, tos)
    end

    # Returns the TOS.
    def tos : UInt8
      LibNLRoute.rtnl_route_get_tos(@ptr)
    end

    # Sets the route type (e.g., `RTN_UNICAST`).
    def type=(typ : UInt8) : Nil
      LibNLRoute.rtnl_route_set_type(@ptr, typ)
    end

    # Returns the route type.
    def type : UInt8
      LibNLRoute.rtnl_route_get_type(@ptr)
    end

    # Sets the address family.
    def family=(fam : Int32) : Nil
      LibNLRoute.rtnl_route_set_family(@ptr, fam)
    end

    # Returns the address family.
    def family : Int32
      LibNLRoute.rtnl_route_get_family(@ptr)
    end

    # --- Destination / Source / Gateway -----------------------------------
    #
    # Sets the destination network.
    def dst=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_route_set_dst(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the destination network.
    def dst : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_route_get_dst(@ptr)
    end

    # Sets the source address (optional).
    def src=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_route_set_src(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the source address.
    def src : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_route_get_src(@ptr)
    end

    # Sets the preferred source address.
    def pref_src=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_route_set_pref_src(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the preferred source address.
    def pref_src : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_route_get_pref_src(@ptr)
    end

    # --- Nexthops ---------------------------------------------------------
    #
    # Adds a nexthop to the route.
    def add_nexthop(nh : Nexthop) : Nil
      LibNLRoute.rtnl_route_add_nexthop(@ptr, nh.to_unsafe)
    end

    # Removes a nexthop from the route.
    def remove_nexthop(nh : Nexthop) : Nil
      LibNLRoute.rtnl_route_remove_nexthop(@ptr, nh.to_unsafe)
    end

    # Returns the number of nexthops.
    def nnexthops : Int32
      LibNLRoute.rtnl_route_get_nnexthops(@ptr)
    end

    # --- Metrics ----------------------------------------------------------
    #
    # Sets a metric value.
    def set_metric(metric : RtnlRouteMetric, value : UInt32) : Nil
      ret = LibNLRoute.rtnl_route_set_metric(@ptr, metric, value)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns a metric value.
    def get_metric(metric : RtnlRouteMetric) : UInt32
      val = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_route_get_metric(@ptr, metric, val)
      raise Error.from_ret(ret) if ret < 0
      val.value
    end

    # --- Add / Delete ----------------------------------------------------
    #
    # Adds the route to the kernel.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_route_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the route from the kernel.
    def delete(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_route_delete(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end

  ##
  # A nexthop used in a route.
  class Nexthop
    @ptr : Pointer(LibNLRoute::Rtnl_Nexthop)
    @owned : Bool

    # Allocates a new nexthop object.
    def initialize
      @ptr = LibNLRoute.rtnl_route_nh_alloc
      raise Error.new("Failed to allocate nexthop") if @ptr.null?
      @owned = true
    end

    # Wraps an existing nexthop pointer.
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Nexthop), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the nexthop if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_route_nh_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Nexthop).null
      end
    end

    def to_unsafe
      @ptr
    end

    # Sets the gateway address.
    def gateway=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_route_nh_set_gateway(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the gateway address.
    def gateway : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_route_nh_get_gateway(@ptr)
    end

    # Sets the outgoing interface index.
    def ifindex=(idx : Int32) : Nil
      LibNLRoute.rtnl_route_nh_set_ifindex(@ptr, idx)
    end

    # Returns the outgoing interface index.
    def ifindex : Int32
      LibNLRoute.rtnl_route_nh_get_ifindex(@ptr)
    end

    # Sets the weight (for multipath).
    def weight=(w : UInt8) : Nil
      LibNLRoute.rtnl_route_nh_set_weight(@ptr, w)
    end

    # Returns the weight.
    def weight : UInt8
      LibNLRoute.rtnl_route_nh_get_weight(@ptr)
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
