# spec/core/addr_spec.cr
require "../spec_helper"

describe "LibNL address" do
  it "parses and formats IPv4 address" do
    addr_ptr = Pointer(LibNL::NL_Addr).null
    ret = LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(addr_ptr))
    ret.should eq(0)
    addr_ptr.should_not be_nil
    buf = Bytes.new(64)
    buf_ptr = buf.to_unsafe.as(LibC::Char*)
    LibNL.nl_addr2str(addr_ptr, buf_ptr, 64_u64)
    String.new(buf_ptr).should eq("192.168.1.1")
    LibNL.nl_addr_put(addr_ptr)
  end

  it "parses and formats IPv6 address" do
    addr_ptr = Pointer(LibNL::NL_Addr).null
    ret = LibNL.nl_addr_parse("::1", LibNL::AF_INET6, pointerof(addr_ptr))
    ret.should eq(0)
    addr_ptr.should_not be_nil
    buf = Bytes.new(64)
    buf_ptr = buf.to_unsafe.as(LibC::Char*)
    LibNL.nl_addr2str(addr_ptr, buf_ptr, 64_u64)
    String.new(buf_ptr).should contain("::1")
    LibNL.nl_addr_put(addr_ptr)
  end

  it "sets and gets prefix length" do
    addr_ptr = Pointer(LibNL::NL_Addr).null
    LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(addr_ptr)).should eq(0)
    addr_ptr.should_not be_nil
    LibNL.nl_addr_set_prefixlen(addr_ptr, 24)
    LibNL.nl_addr_get_prefixlen(addr_ptr).should eq(24)
    LibNL.nl_addr_put(addr_ptr)
  end

  it "sets and gets family" do
    # Use the helper that emulates nl_addr_alloc_empty
    addr_ptr = LibNLHelpers.addr_alloc_empty(LibNL::AF_INET)
    addr_ptr.should_not be_nil
    LibNL.nl_addr_get_family(addr_ptr).should eq(LibNL::AF_INET)
    LibNL.nl_addr_set_family(addr_ptr, LibNL::AF_INET6)
    LibNL.nl_addr_get_family(addr_ptr).should eq(LibNL::AF_INET6)
    LibNL.nl_addr_put(addr_ptr)
  end

  it "checks zero address" do
    addr_ptr = LibNLHelpers.addr_alloc_empty(LibNL::AF_INET)
    addr_ptr.should_not be_nil
    LibNL.nl_addr_iszero(addr_ptr).should eq(1)
    data = Bytes[1, 2, 3, 4]
    LibNL.nl_addr_set_binary_addr(addr_ptr, data.to_unsafe, 4).should eq(0)
    LibNL.nl_addr_iszero(addr_ptr).should eq(0)
    LibNL.nl_addr_put(addr_ptr)
  end

  it "compares addresses" do
    addr1 = Pointer(LibNL::NL_Addr).null
    addr2 = Pointer(LibNL::NL_Addr).null
    LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(addr1)).should eq(0)
    LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(addr2)).should eq(0)
    LibNL.nl_addr_cmp(addr1, addr2).should eq(0)
    addr3 = Pointer(LibNL::NL_Addr).null
    LibNL.nl_addr_parse("192.168.1.2", LibNL::AF_INET, pointerof(addr3)).should eq(0)
    LibNL.nl_addr_cmp(addr1, addr3).should_not eq(0)
    LibNL.nl_addr_put(addr1)
    LibNL.nl_addr_put(addr2)
    LibNL.nl_addr_put(addr3)
  end

  it "builds any address" do
    # Use the helper that emulates nl_addr_build_any
    addr_ptr = LibNLHelpers.addr_build_any(LibNL::AF_INET)
    addr_ptr.should_not be_nil
    # The address should be zero
    LibNL.nl_addr_iszero(addr_ptr).should eq(1)
    LibNL.nl_addr_put(addr_ptr)
  end
end
