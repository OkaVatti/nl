#!/usr/bin/env crystal
# examples/add_neighbour.cr
# Add a static ARP entry (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to add a neighbour."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# Parse the destination IP
dst = Pointer(LibNL::NL_Addr).null
ret = LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(dst))
raise "Failed to parse destination IP" if ret < 0

# Parse the MAC address (using AF_UNSPEC for hardware addresses)
ll = Pointer(LibNL::NL_Addr).null
ret = LibNL.nl_addr_parse("00:11:22:33:44:55", LibNL::AF_UNSPEC, pointerof(ll))
raise "Failed to parse MAC address" if ret < 0

neigh = Nl::Route::Neighbour.new
neigh.ifindex = 1 # assuming eth0; adjust as needed
neigh.family = LibNL::AF_INET
neigh.dst = dst
neigh.lladdr = ll
neigh.state = LibNLRoute::NUD_PERMANENT

neigh.add(sk)
puts "Static ARP entry added"

LibNL.nl_addr_put(dst)
LibNL.nl_addr_put(ll)
