# spec/nf/conntrack_spec.cr
require "../spec_helper"

describe "LibNLNf conntrack" do
  it "allocates and frees a conntrack object" do
    ct = LibNLNf.nfnl_ct_alloc
    ct.should_not be_nil
    LibNLNf.nfnl_ct_put(ct)
  end

  it "sets and gets conntrack status" do
    ct = LibNLNf.nfnl_ct_alloc
    ct.should_not be_nil
    LibNLNf.nfnl_ct_set_status(ct, LibNLNf::IPS_SEEN_REPLY)
    LibNLNf.nfnl_ct_get_status(ct).should eq(LibNLNf::IPS_SEEN_REPLY)
    LibNLNf.nfnl_ct_put(ct)
  end

  it "sets and gets conntrack mark" do
    ct = LibNLNf.nfnl_ct_alloc
    ct.should_not be_nil
    LibNLNf.nfnl_ct_set_mark(ct, 0x12345678_u32)
    LibNLNf.nfnl_ct_get_mark(ct).should eq(0x12345678_u32)
    LibNLNf.nfnl_ct_put(ct)
  end
end
