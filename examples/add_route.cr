#!/usr/bin/env crystal
# examples/add_route.cr
# Add a static route (requires root).

require "../src/nl"

# Check if running as root
unless Process.uid == 0
  puts "This example requires root privileges to add a route."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# Destination network: 10.0.0.0/8
dst = Pointer(LibNL::NL_Addr).null
ret = LibNL.nl_addr_parse("10.0.0.0", LibNL::AF_INET, pointerof(dst))
raise "Failed to parse destination address" if ret < 0
LibNL.nl_addr_set_prefixlen(dst, 8)

# Gateway: 192.168.1.1
gw = Pointer(LibNL::NL_Addr).null
ret = LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(gw))
raise "Failed to parse gateway address" if ret < 0

# Create the route object
route = Nl::Route::Route.new
route.dst = dst
route.table = 254_u32 # main routing table
route.scope = 0_u8    # RT_SCOPE_UNIVERSE
route.type = 1_u8     # RTN_UNICAST

# Add a nexthop
nh = Nl::Route::Nexthop.new
nh.gateway = gw
route.add_nexthop(nh)

# Add the route
route.add(sk)
puts "Route added successfully"

# Cleanup
LibNL.nl_addr_put(dst)
LibNL.nl_addr_put(gw)
