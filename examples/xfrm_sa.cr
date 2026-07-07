#!/usr/bin/env crystal
# examples/xfrm_sa.cr
# Create a Security Association (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to add XFRM SA."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_XFRM)

sa = Nl::XFrm::SA.new
sa.spi = 0x1000_u32
sa.proto = LibNLXfrm::XFRM_PROTO_ESP
sa.family = LibNLXfrm::XFRM_AF_INET
sa.mode = LibNLXfrm::XFRM_MODE_TUNNEL

# Set addresses
src = Pointer(LibNL::NL_Addr).null
dst = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("10.0.0.1", LibNL::AF_INET, pointerof(src))
LibNL.nl_addr_parse("10.0.0.2", LibNL::AF_INET, pointerof(dst))
sa.saddr = src
sa.daddr = dst

# Set algorithms (simplified – real code would need proper algorithm structures)
# This is a placeholder; see libnl documentation for setting algorithms.
puts "SA parameters set (algorithm not configured – this example is incomplete)."

# sa.add(sk)
