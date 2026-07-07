# src/libnl/route/route.cr
#
# Routing table management – allocation, cache, addition, deletion,
# attribute getters/setters, and extended metrics support.

# ---- Route metric enum (from <netlink/route/route.h>) -------------------

enum RtnlRouteMetric : Int32
  ROUTE_METRIC_MTU                =  1
  ROUTE_METRIC_WINDOW             =  2
  ROUTE_METRIC_RTT                =  3
  ROUTE_METRIC_RTTVAR             =  4
  ROUTE_METRIC_SSTHRESH           =  5
  ROUTE_METRIC_CWND               =  6
  ROUTE_METRIC_ADVMSS             =  7
  ROUTE_METRIC_REORDERING         =  8
  ROUTE_METRIC_HOPLIMIT           =  9
  ROUTE_METRIC_INITCWND           = 10
  ROUTE_METRIC_FEATURES           = 11
  ROUTE_METRIC_RTO_MIN            = 12
  ROUTE_METRIC_INITRWND           = 13
  ROUTE_METRIC_QUICKACK           = 14
  ROUTE_METRIC_CONG_CTRL          = 15
  ROUTE_METRIC_NOFQ               = 16
  ROUTE_METRIC_FASTOPEN_NO_COOKIE = 17
  ROUTE_METRIC_TCP_TIMESTAMPS     = 18
end

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Allocation / Free / Reference counting ---------------------------

  fun rtnl_route_alloc = rtnl_route_alloc : Pointer(Rtnl_Route)
  fun rtnl_route_put = rtnl_route_put(route : Pointer(Rtnl_Route)) : Void
  fun rtnl_route_get = rtnl_route_get(route : Pointer(Rtnl_Route)) : Void
  fun rtnl_route_alloc_cache = rtnl_route_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    family : Int32,
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- Route parsing / building -----------------------------------------

  fun rtnl_route_parse = rtnl_route_parse(nlh : Pointer(LibNL::NL_Msg), result : Pointer(Pointer(Rtnl_Route))) : Int32
  fun rtnl_route_build_msg = rtnl_route_build_msg(msg : Pointer(LibNL::NL_Msg), route : Pointer(Rtnl_Route)) : Int32

  # ---- Route addition / deletion ----------------------------------------

  fun rtnl_route_add = rtnl_route_add(sk : Pointer(LibNL::NL_Sock), route : Pointer(Rtnl_Route), flags : Int32) : Int32
  fun rtnl_route_build_add_request = rtnl_route_build_add_request(
    route : Pointer(Rtnl_Route),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_route_delete = rtnl_route_delete(sk : Pointer(LibNL::NL_Sock), route : Pointer(Rtnl_Route), flags : Int32) : Int32
  fun rtnl_route_build_del_request = rtnl_route_build_del_request(
    route : Pointer(Rtnl_Route),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Route lookup -----------------------------------------------------

  fun rtnl_route_lookup = rtnl_route_lookup(
    sk : Pointer(LibNL::NL_Sock),
    dst : Pointer(LibNL::NL_Addr),
    result : Pointer(Pointer(Rtnl_Route)),
  ) : Int32

  # ---- Basic attributes (getters / setters) -----------------------------

  fun rtnl_route_set_table = rtnl_route_set_table(route : Pointer(Rtnl_Route), table : UInt32) : Void
  fun rtnl_route_get_table = rtnl_route_get_table(route : Pointer(Rtnl_Route)) : UInt32
  fun rtnl_route_set_scope = rtnl_route_set_scope(route : Pointer(Rtnl_Route), scope : UInt8) : Void
  fun rtnl_route_get_scope = rtnl_route_get_scope(route : Pointer(Rtnl_Route)) : UInt8
  fun rtnl_route_set_tos = rtnl_route_set_tos(route : Pointer(Rtnl_Route), tos : UInt8) : Void
  fun rtnl_route_get_tos = rtnl_route_get_tos(route : Pointer(Rtnl_Route)) : UInt8
  fun rtnl_route_set_protocol = rtnl_route_set_protocol(route : Pointer(Rtnl_Route), protocol : UInt8) : Void
  fun rtnl_route_get_protocol = rtnl_route_get_protocol(route : Pointer(Rtnl_Route)) : UInt8
  fun rtnl_route_set_priority = rtnl_route_set_priority(route : Pointer(Rtnl_Route), priority : UInt32) : Void
  fun rtnl_route_get_priority = rtnl_route_get_priority(route : Pointer(Rtnl_Route)) : UInt32
  fun rtnl_route_set_family = rtnl_route_set_family(route : Pointer(Rtnl_Route), family : Int32) : Void
  fun rtnl_route_get_family = rtnl_route_get_family(route : Pointer(Rtnl_Route)) : Int32
  fun rtnl_route_set_type = rtnl_route_set_type(route : Pointer(Rtnl_Route), type : UInt8) : Void
  fun rtnl_route_get_type = rtnl_route_get_type(route : Pointer(Rtnl_Route)) : UInt8
  fun rtnl_route_set_flags = rtnl_route_set_flags(route : Pointer(Rtnl_Route), flags : UInt32) : Void
  fun rtnl_route_get_flags = rtnl_route_get_flags(route : Pointer(Rtnl_Route)) : UInt32

  # ---- Destination / source / gateway -----------------------------------

  fun rtnl_route_set_dst = rtnl_route_set_dst(route : Pointer(Rtnl_Route), dst : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_route_get_dst = rtnl_route_get_dst(route : Pointer(Rtnl_Route)) : Pointer(LibNL::NL_Addr)
  fun rtnl_route_set_src = rtnl_route_set_src(route : Pointer(Rtnl_Route), src : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_route_get_src = rtnl_route_get_src(route : Pointer(Rtnl_Route)) : Pointer(LibNL::NL_Addr)
  fun rtnl_route_set_pref_src = rtnl_route_set_pref_src(route : Pointer(Rtnl_Route), pref_src : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_route_get_pref_src = rtnl_route_get_pref_src(route : Pointer(Rtnl_Route)) : Pointer(LibNL::NL_Addr)

  # ---- Nexthop management -----------------------------------------------

  fun rtnl_route_get_nnexthops = rtnl_route_get_nnexthops(route : Pointer(Rtnl_Route)) : Int32
  fun rtnl_route_add_nexthop = rtnl_route_add_nexthop(route : Pointer(Rtnl_Route), nh : Pointer(Rtnl_Nexthop)) : Void
  fun rtnl_route_remove_nexthop = rtnl_route_remove_nexthop(route : Pointer(Rtnl_Route), nh : Pointer(Rtnl_Nexthop)) : Void

  # ---- Nexthop object allocation / free ---------------------------------

  fun rtnl_route_nh_alloc = rtnl_route_nh_alloc : Pointer(Rtnl_Nexthop)
  fun rtnl_route_nh_get = rtnl_route_nh_get(nh : Pointer(Rtnl_Nexthop)) : Void
  fun rtnl_route_nh_put = rtnl_route_nh_put(nh : Pointer(Rtnl_Nexthop)) : Void
  fun rtnl_route_nh_set_gateway = rtnl_route_nh_set_gateway(nh : Pointer(Rtnl_Nexthop), gw : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_route_nh_get_gateway = rtnl_route_nh_get_gateway(nh : Pointer(Rtnl_Nexthop)) : Pointer(LibNL::NL_Addr)
  fun rtnl_route_nh_set_ifindex = rtnl_route_nh_set_ifindex(nh : Pointer(Rtnl_Nexthop), ifindex : Int32) : Void
  fun rtnl_route_nh_get_ifindex = rtnl_route_nh_get_ifindex(nh : Pointer(Rtnl_Nexthop)) : Int32
  fun rtnl_route_nh_set_weight = rtnl_route_nh_set_weight(nh : Pointer(Rtnl_Nexthop), weight : UInt8) : Void
  fun rtnl_route_nh_get_weight = rtnl_route_nh_get_weight(nh : Pointer(Rtnl_Nexthop)) : UInt8
  fun rtnl_route_nh_set_flags = rtnl_route_nh_set_flags(nh : Pointer(Rtnl_Nexthop), flags : UInt32) : Void
  fun rtnl_route_nh_get_flags = rtnl_route_nh_get_flags(nh : Pointer(Rtnl_Nexthop)) : UInt32

  # ---- Cache info -------------------------------------------------------

  fun rtnl_route_get_cache_info = rtnl_route_get_cache_info(route : Pointer(Rtnl_Route)) : Pointer(Rtnl_Rtcacheinfo)

  # ======================================================================
  # Route Metrics (from <netlink/route/route.h>)
  # ======================================================================

  # ---- Generic metric setter/getter --------------------------------------

  # Set a metric value (use enum RtnlRouteMetric for 'metric')
  fun rtnl_route_set_metric = rtnl_route_set_metric(
    route : Pointer(Rtnl_Route),
    metric : RtnlRouteMetric,
    value : UInt32,
  ) : Int32

  # Get a metric value
  fun rtnl_route_get_metric = rtnl_route_get_metric(
    route : Pointer(Rtnl_Route),
    metric : RtnlRouteMetric,
    value : UInt32*,
  ) : Int32

  # ---- Convenience metric setters/getters (macros in C, we bind them) ---

  fun rtnl_route_set_mtu = rtnl_route_set_mtu(route : Pointer(Rtnl_Route), mtu : UInt32) : Int32
  fun rtnl_route_get_mtu = rtnl_route_get_mtu(route : Pointer(Rtnl_Route)) : UInt32

  fun rtnl_route_set_window = rtnl_route_set_window(route : Pointer(Rtnl_Route), window : UInt32) : Int32
  fun rtnl_route_get_window = rtnl_route_get_window(route : Pointer(Rtnl_Route)) : UInt32

  fun rtnl_route_set_rtt = rtnl_route_set_rtt(route : Pointer(Rtnl_Route), rtt : UInt32) : Int32
  fun rtnl_route_get_rtt = rtnl_route_get_rtt(route : Pointer(Rtnl_Route)) : UInt32

  fun rtnl_route_set_hoplimit = rtnl_route_set_hoplimit(route : Pointer(Rtnl_Route), hoplimit : UInt32) : Int32
  fun rtnl_route_get_hoplimit = rtnl_route_get_hoplimit(route : Pointer(Rtnl_Route)) : UInt32
end
