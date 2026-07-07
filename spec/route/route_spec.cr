# spec/route/route_spec.cr
require "../spec_helper"

describe "LibNLRoute route" do
  it "allocates and frees a route" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    LibNLRoute.rtnl_route_put(route)
  end

  it "allocates a route cache (requires route connection)" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)
      cache = Pointer(LibNL::NL_Cache).null
      LibNLRoute.rtnl_route_alloc_cache(sk, LibNL::AF_UNSPEC, 0, pointerof(cache)).should eq(0)
      cache.should_not be_nil
      LibNL.nl_cache_free(cache)
      LibNL.nl_socket_free(sk)
    end
  end

  it "sets and gets route table" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    LibNLRoute.rtnl_route_set_table(route, 254_u32)
    LibNLRoute.rtnl_route_get_table(route).should eq(254_u32)
    LibNLRoute.rtnl_route_put(route)
  end

  it "sets and gets route scope" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    LibNLRoute.rtnl_route_set_scope(route, 0_u8)
    LibNLRoute.rtnl_route_get_scope(route).should eq(0_u8)
    LibNLRoute.rtnl_route_put(route)
  end

  it "sets and gets route type" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    LibNLRoute.rtnl_route_set_type(route, 1_u8) # RTN_UNICAST
    LibNLRoute.rtnl_route_get_type(route).should eq(1_u8)
    LibNLRoute.rtnl_route_put(route)
  end

  it "sets and gets route metric (using generic set_metric/get_metric)" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    # rtnl_route_set_mtu/get_mtu are inline wrappers; use generic metric functions
    LibNLRoute.rtnl_route_set_metric(route, RtnlRouteMetric::ROUTE_METRIC_MTU, 1500_u32).should eq(0)
    val_ptr = Pointer(UInt32).malloc(1)
    LibNLRoute.rtnl_route_get_metric(route, RtnlRouteMetric::ROUTE_METRIC_MTU, val_ptr).should eq(0)
    val_ptr.value.should eq(1500_u32)
    LibNLRoute.rtnl_route_put(route)
  end

  it "sets and gets route metric via generic set_metric (window)" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    LibNLRoute.rtnl_route_set_metric(route, RtnlRouteMetric::ROUTE_METRIC_WINDOW, 65535_u32).should eq(0)
    val_ptr = Pointer(UInt32).malloc(1)
    LibNLRoute.rtnl_route_get_metric(route, RtnlRouteMetric::ROUTE_METRIC_WINDOW, val_ptr).should eq(0)
    val_ptr.value.should eq(65535_u32)
    LibNLRoute.rtnl_route_put(route)
  end

  it "sets and gets destination address (requires nl_addr)" do
    route = LibNLRoute.rtnl_route_alloc
    route.should_not be_nil
    dst = Pointer(LibNL::NL_Addr).null
    LibNL.nl_addr_parse("10.0.0.0", LibNL::AF_INET, pointerof(dst)).should eq(0)
    dst.should_not be_nil
    LibNL.nl_addr_set_prefixlen(dst, 8)
    LibNLRoute.rtnl_route_set_dst(route, dst).should eq(0)
    get_dst = LibNLRoute.rtnl_route_get_dst(route)
    get_dst.should_not be_nil
    LibNL.nl_addr_put(dst)
    LibNLRoute.rtnl_route_put(route)
  end
end
