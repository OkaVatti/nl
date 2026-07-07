# spec/route/link_spec.cr
require "../spec_helper"

describe "LibNLRoute link" do
  it "allocates and frees a link" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    LibNLRoute.rtnl_link_put(link)
  end

  it "allocates a link cache (if route connection available)" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)

      cache = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_link_alloc_cache(sk, 0, pointerof(cache))
      ret.should eq(0)
      cache.should_not be_nil
      LibNL.nl_cache_free(cache)
      LibNL.nl_socket_free(sk)
    end
  end

  it "sets and gets link MTU" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    LibNLRoute.rtnl_link_set_mtu(link, 1500_u32)
    LibNLRoute.rtnl_link_get_mtu(link).should eq(1500_u32)
    LibNLRoute.rtnl_link_put(link)
  end

  it "sets and gets link flags" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    LibNLRoute.rtnl_link_set_flags(link, 0x1_u32)
    LibNLRoute.rtnl_link_get_flags(link).should eq(0x1_u32)
    LibNLRoute.rtnl_link_unset_flags(link, 0x1_u32)
    LibNLRoute.rtnl_link_get_flags(link).should eq(0_u32)
    LibNLRoute.rtnl_link_put(link)
  end

  it "detects link types (should be 0 for newly allocated link)" do
    link = LibNLRoute.rtnl_link_alloc
    link.should_not be_nil
    LibNLRoute.rtnl_link_is_vlan(link).should eq(0)
    LibNLRoute.rtnl_link_is_bridge(link).should eq(0)
    LibNLRoute.rtnl_link_is_bond(link).should eq(0)
    LibNLRoute.rtnl_link_is_vxlan(link).should eq(0)
    LibNLRoute.rtnl_link_put(link)
  end

  # spec/route/link_spec.cr (add at end)
  it "retrieves a link by ifindex from cache" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)

      ops = LibNL.nl_cache_ops_lookup("route/link")
      ops.should_not be_nil
      cache = LibNL.nl_cache_alloc(ops)
      cache.should_not be_nil
      LibNL.nl_cache_refill(sk, cache).should eq(0)

      # Find loopback (ifindex 1 is typically lo)
      link = LibNLRoute.rtnl_link_get(cache, 1)
      if !link.null?
        name = LibNLRoute.rtnl_link_get_name(link)
        if name
          String.new(name).should eq("lo")
        end
        mtu = LibNLRoute.rtnl_link_get_mtu(link)
        mtu.should be > 0
        flags = LibNLRoute.rtnl_link_get_flags(link)
        flags.should be >= 0
      end

      LibNL.nl_cache_free(cache)
      LibNL.nl_cache_ops_put(ops)
      LibNL.nl_socket_free(sk)
    end
  end

  it "creates VLAN link object (alloc only)" do
    vlan = LibNLRoute.rtnl_link_vlan_alloc
    vlan.should_not be_nil
    LibNLRoute.rtnl_link_vlan_set_id(vlan, 100_u16).should eq(0)
    LibNLRoute.rtnl_link_vlan_get_id(vlan).should eq(100_u16)
    LibNLRoute.rtnl_link_put(vlan)
  end

  it "creates bridge link object" do
    bridge = LibNLRoute.rtnl_link_bridge_alloc
    bridge.should_not be_nil
    LibNLRoute.rtnl_link_put(bridge)
  end

  it "sets and gets VLAN ID" do
    vlan = LibNLRoute.rtnl_link_vlan_alloc
    vlan.should_not be_nil
    LibNLRoute.rtnl_link_vlan_set_id(vlan, 100_u16).should eq(0)
    LibNLRoute.rtnl_link_vlan_get_id(vlan).should eq(100_u16)
    LibNLRoute.rtnl_link_put(vlan)
  end
end
