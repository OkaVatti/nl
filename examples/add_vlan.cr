#!/usr/bin/env crystal
# examples/add_vlan.cr
# Create a VLAN interface (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to create a VLAN."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# We need the physical interface (e.g., eth0) to attach the VLAN to.
# For simplicity, we assume eth0 exists.
link_cache = Nl::Route::Link.cache(sk)
parent = Nl::Route::Link.get_by_name(link_cache, "eth0")
unless parent
  puts "Parent interface 'eth0' not found. Please adjust the name."
  exit 1
end

# Create the VLAN link
vlan = Nl::Route::Link.new
vlan.name = "vlan100"
vlan.set_link = parent.ifindex # attach to parent
vlan.vlan_set_id(100_u16)

# Add it (NLM_F_CREATE | NLM_F_EXCL ensures it's new)
vlan.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)
puts "VLAN interface 'vlan100' created successfully"
