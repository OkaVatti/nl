# spec/xfrm/sa_spec.cr
require "../spec_helper"

describe "LibNLXfrm security association" do
  it "allocates and frees an SA object" do
    sa = LibNLXfrm.xfrmnl_sa_alloc
    sa.should_not be_nil
    LibNLXfrm.xfrmnl_sa_put(sa)
  end

  it "sets and gets SA SPI" do
    sa = LibNLXfrm.xfrmnl_sa_alloc
    sa.should_not be_nil
    LibNLXfrm.xfrmnl_sa_set_spi(sa, 0x1000_u32).should eq(0)
    LibNLXfrm.xfrmnl_sa_get_spi(sa).should eq(0x1000_u32)
    LibNLXfrm.xfrmnl_sa_put(sa)
  end

  it "sets and gets SA family" do
    sa = LibNLXfrm.xfrmnl_sa_alloc
    sa.should_not be_nil
    LibNLXfrm.xfrmnl_sa_set_family(sa, LibNLXfrm::XFRM_AF_INET).should eq(0)
    LibNLXfrm.xfrmnl_sa_get_family(sa).should eq(LibNLXfrm::XFRM_AF_INET)
    LibNLXfrm.xfrmnl_sa_put(sa)
  end
end
