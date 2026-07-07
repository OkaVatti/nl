# spec/core/cache_spec.cr
require "../spec_helper"

private LINK_CALLBACK = ->(obj : Pointer(LibNL::NL_Object), arg : Pointer(Void)) {
  link = obj.as(Pointer(LibNLRoute::Rtnl_Link))
  name = LibNLRoute.rtnl_link_get_name(link)
  if name && String.new(name) == "lo"
    arg.as(Int32*).value = 1
  end
}

describe "LibNL cache" do
  it "allocates and frees a cache (if route/link ops available)" do
    ops = LibNL.nl_cache_ops_lookup("route/link")
    if !ops.null?
      cache = LibNL.nl_cache_alloc(ops)
      cache.should_not be_nil
      LibNL.nl_cache_free(cache)
      LibNL.nl_cache_ops_put(ops)
    end
  end

  it "gets cache operations (if route/link ops available)" do
    ops = LibNL.nl_cache_ops_lookup("route/link")
    if !ops.null?
      ops.should_not be_nil
      LibNL.nl_cache_ops_get(ops)
      LibNL.nl_cache_ops_put(ops)
      LibNL.nl_cache_ops_put(ops) # should free
    end
  end

  it "refills a link cache (if route connection available)" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)

      ops = LibNL.nl_cache_ops_lookup("route/link")
      ops.should_not be_nil
      cache = LibNL.nl_cache_alloc(ops)
      cache.should_not be_nil

      ret = LibNL.nl_cache_refill(sk, cache)
      ret.should eq(0)

      nitems = LibNL.nl_cache_nitems(cache)
      nitems.should be > 0

      found_ptr = Pointer(Int32).malloc(1)
      found_ptr.value = 0
      LibNL.nl_cache_foreach(cache, LINK_CALLBACK, found_ptr)
      found_ptr.value.should eq(1)

      LibNL.nl_cache_free(cache)
      LibNL.nl_cache_ops_put(ops)
      LibNL.nl_socket_free(sk)
    end
  end
end
