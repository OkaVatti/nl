# spec/core/attr_spec.cr
require "../spec_helper"

describe "LibNL attributes" do
  it "puts and gets basic integer attributes" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil

    LibNL.nla_put_u8(msg, 1, 0x55_u8).should eq(0)
    LibNL.nla_put_u16(msg, 2, 0x1234_u16).should eq(0)
    LibNL.nla_put_u32(msg, 3, 0x12345678_u32).should eq(0)
    LibNL.nla_put_u64(msg, 4, 0x123456789abcdef0_u64).should eq(0)
    LibNL.nla_put_s8(msg, 5, -1_i8).should eq(0)
    LibNL.nla_put_s16(msg, 6, -2_i16).should eq(0)
    LibNL.nla_put_s32(msg, 7, -3_i32).should eq(0)
    LibNL.nla_put_s64(msg, 8, -4_i64).should eq(0)
    LibNL.nla_put_flag(msg, 9).should eq(0)
    LibNL.nla_put_string(msg, 10, "hello").should eq(0)

    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 0, LibNL::NLM_F_REQUEST)
    hdr.should_not be_nil

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 1)
    attr.should_not be_nil
    LibNL.nla_get_u8(attr).should eq(0x55_u8)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 2)
    attr.should_not be_nil
    LibNL.nla_get_u16(attr).should eq(0x1234_u16)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 3)
    attr.should_not be_nil
    LibNL.nla_get_u32(attr).should eq(0x12345678_u32)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 4)
    attr.should_not be_nil
    LibNL.nla_get_u64(attr).should eq(0x123456789abcdef0_u64)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 5)
    attr.should_not be_nil
    LibNL.nla_get_s8(attr).should eq(-1_i8)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 6)
    attr.should_not be_nil
    LibNL.nla_get_s16(attr).should eq(-2_i16)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 7)
    attr.should_not be_nil
    LibNL.nla_get_s32(attr).should eq(-3_i32)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 8)
    attr.should_not be_nil
    LibNL.nla_get_s64(attr).should eq(-4_i64)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 9)
    attr.should_not be_nil
    LibNL.nla_get_flag(attr).should eq(1)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 10)
    attr.should_not be_nil
    str = String.new(LibNL.nla_get_string(attr))
    str.should eq("hello")

    LibNL.nlmsg_free(msg)
  end

  it "uses nested attributes" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 0, LibNL::NLM_F_REQUEST)
    hdr.should_not be_nil

    nested = LibNL.nla_nest_start(msg, 100)
    nested.should_not be_nil
    LibNL.nla_put_u32(msg, 101, 0xdeadbeef_u32).should eq(0)
    LibNL.nla_nest_end(msg, nested).should eq(0)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 100)
    attr.should_not be_nil
    nested_data = LibNLHelpers.nla_data(attr)
    nested_data.should_not be_nil
    LibNL.nlmsg_free(msg)
  end

  it "copies attribute data with nla_get_data" do
    msg = LibNL.nlmsg_alloc
    msg.should_not be_nil
    hdr = LibNL.nlmsg_put(msg, 0, 1, 10, 0, LibNL::NLM_F_REQUEST)
    hdr.should_not be_nil
    data = Bytes[1, 2, 3, 4, 5]
    LibNL.nla_put(msg, 20, data.size, data.to_unsafe).should eq(0)

    attr = LibNL.nla_find(LibNLHelpers.nlmsg_attrdata(hdr, 0), LibNLHelpers.nlmsg_attrlen(hdr, 0), 20)
    attr.should_not be_nil

    # Verify total length (header + payload)
    len = LibNLHelpers.nla_len(attr)
    len.should eq(9) # 4 header + 5 payload

    # Verify payload data
    ptr = LibNLHelpers.nla_data(attr)
    ptr.should_not be_nil
    payload_len = len - 4
    result = ptr.as(Pointer(UInt8)).to_slice(payload_len)
    result.should eq(data)

    LibNL.nlmsg_free(msg)
  end
end
