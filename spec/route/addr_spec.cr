# spec/route/addr_spec.cr
require "../spec_helper"

describe "LibNLRoute address" do
  it "allocates and frees an address object" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "allocates an address cache (requires route connection)" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)
      cache = Pointer(LibNL::NL_Cache).null
      LibNLRoute.rtnl_addr_alloc_cache(sk, pointerof(cache)).should eq(0)
      cache.should_not be_nil
      LibNL.nl_cache_free(cache)
      LibNL.nl_socket_free(sk)
    end
  end

  it "sets and gets address label" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    label = "test_label"
    LibNLRoute.rtnl_addr_set_label(addr, label).should eq(0)
    get = LibNLRoute.rtnl_addr_get_label(addr)
    get.should_not be_nil
    String.new(get).should eq(label)
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "sets and gets ifindex" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    LibNLRoute.rtnl_addr_set_ifindex(addr, 1)
    LibNLRoute.rtnl_addr_get_ifindex(addr).should eq(1)
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "sets and gets family" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    LibNLRoute.rtnl_addr_set_family(addr, LibNL::AF_INET)
    LibNLRoute.rtnl_addr_get_family(addr).should eq(LibNL::AF_INET)
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "sets and gets prefix length" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    LibNLRoute.rtnl_addr_set_prefixlen(addr, 24)
    LibNLRoute.rtnl_addr_get_prefixlen(addr).should eq(24)
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "sets and gets scope" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    LibNLRoute.rtnl_addr_set_scope(addr, 0)
    LibNLRoute.rtnl_addr_get_scope(addr).should eq(0)
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "sets and gets flags" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    LibNLRoute.rtnl_addr_set_flags(addr, 0x1_u32)
    LibNLRoute.rtnl_addr_get_flags(addr).should eq(0x1_u32)
    LibNLRoute.rtnl_addr_unset_flags(addr, 0x1_u32)
    LibNLRoute.rtnl_addr_get_flags(addr).should eq(0_u32)
    LibNLRoute.rtnl_addr_put(addr)
  end

  it "sets and gets local address (requires nl_addr)" do
    addr = LibNLRoute.rtnl_addr_alloc
    addr.should_not be_nil
    local = Pointer(LibNL::NL_Addr).null
    LibNL.nl_addr_parse("192.168.1.100", LibNL::AF_INET, pointerof(local)).should eq(0)
    local.should_not be_nil
    LibNLRoute.rtnl_addr_set_local(addr, local).should eq(0)
    get_local = LibNLRoute.rtnl_addr_get_local(addr)
    get_local.should_not be_nil
    LibNL.nl_addr_put(local)
    LibNLRoute.rtnl_addr_put(addr)
  end
end
