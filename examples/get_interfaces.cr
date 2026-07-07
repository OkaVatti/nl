#!/usr/bin/env crystal
# examples/get_interfaces.cr
# List all network interfaces using the high‑level Link API.

require "../src/nl"

# Create socket and connect to NETLINK_ROUTE
sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# Retrieve the link cache
cache = Nl::Route::Link.cache(sk)

puts "%-5s %-10s %-8s %s" % ["Index", "Name", "State", "MTU"]
cache.each do |obj|
  link = Nl::Route::Link.new(obj.as(Pointer(LibNLRoute::Rtnl_Link)), owned: false)
  state = link.state == 1 ? "UP" : "DOWN"
  puts "%-5d %-10s %-8s %d" % [link.ifindex, link.name || "unnamed", state, link.mtu]
end
