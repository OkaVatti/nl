# spec/core/message_spec.cr
require "../spec_helper"

describe "LibNL message" do
  it "allocates and frees a message" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    LibNL.nlmsg_free(msg)
  end

  it "allocates a message with a specific size" do
    msg = LibNL.nlmsg_alloc_size(1024_u64)
    msg.should_not be_nil
    LibNL.nlmsg_free(msg)
  end

  it "allocates a simple message" do
    msg = LibNL.nlmsg_alloc_simple(42, LibNL::NLM_F_REQUEST)
    msg.should_not be_nil
    LibNL.nlmsg_free(msg)
  end

  it "puts a netlink header" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0_u32, 0_u32, 1, 0, LibNL::NLM_F_REQUEST)
    hdr.should_not be_nil
    data = LibNLHelpers.nlmsg_data(hdr)
    data.should_not be_nil
    LibNL.nlmsg_free(msg)
  end

  it "calculates message sizes" do
    payload = 64
    size = LibNL.nlmsg_size(payload)
    total = LibNL.nlmsg_total_size(payload)
    pad = LibNL.nlmsg_padlen(payload)
    size.should be > 0
    total.should be >= size
    pad.should be >= 0
  end

  it "sets default size" do
    LibNL.nlmsg_set_default_size(2048_u64)
  end

  it "parses message headers (basic)" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 16, LibNL::NLM_F_REQUEST)
    len = LibNLHelpers.nlmsg_len(hdr)
    len.should be > 0
    datalen = LibNLHelpers.nlmsg_datalen(hdr)
    datalen.should eq(16)
    LibNL.nlmsg_free(msg)
  end

  it "finds attributes in message" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 0, LibNL::NLM_F_REQUEST)
    ret = LibNL.nla_put_u32(msg, 1, 12345_u32)
    ret.should eq(0)
    attr = LibNL.nlmsg_find_attr(hdr, 0, 1)
    attr.should_not be_nil
    val = LibNL.nla_get_u32(attr)
    val.should eq(12345_u32)
    LibNL.nlmsg_free(msg)
  end

  it "validates message header" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 0, LibNL::NLM_F_REQUEST)
    valid = LibNLHelpers.nlmsg_valid_hdr(hdr, 0)
    valid.should eq(1)
    LibNL.nlmsg_free(msg)
  end

  it "checks message ok and next (single message)" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 0, LibNL::NLM_F_REQUEST)
    remaining = LibNLHelpers.nlmsg_len(hdr).to_i32
    ok = LibNLHelpers.nlmsg_ok(hdr, remaining)
    ok.should eq(1)
    LibNL.nlmsg_free(msg)
  end
end
