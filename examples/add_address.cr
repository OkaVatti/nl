#!/usr/bin/env crystal
# examples/add_address.cr
# Add an IP address to an interface (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to add an address."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# Find the interface (e.g., eth0)
link_cache = Nl::Route::Link.cache(sk)
link = Nl::Route::Link.get_by_name(link_cache, "eth0")
unless link
  puts "Interface 'eth0' not found."
  exit 1
end

# Create the address
addr = Nl::Route::Address.new
addr.ifindex = link.ifindex
addr.family = LibNL::AF_INET
addr.prefixlen = 24

# Parse the IP address
local = Pointer(LibNL::NL_Addr).null
ret = LibNL.nl_addr_parse("192.168.100.10", LibNL::AF_INET, pointerof(local))
raise "Failed to parse address" if ret < 0
addr.local = local

# Add it
addr.add(sk)
puts "Address 192.168.100.10/24 added to eth0"

LibNL.nl_addr_put(local)
