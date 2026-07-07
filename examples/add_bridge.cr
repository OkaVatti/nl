#!/usr/bin/env crystal
# examples/add_bridge.cr
# Create a bridge interface (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to create a bridge."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

bridge = Nl::Route::Link.new
bridge.name = "br0"
bridge.bridge_set_ageing_time(300_u32) # optional
bridge.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

puts "Bridge 'br0' created successfully"
