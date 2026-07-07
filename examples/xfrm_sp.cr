#!/usr/bin/env crystal
# examples/xfrm_sp.cr
# Create a Security Policy (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to add XFRM SP."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_XFRM)

sp = Nl::XFrm::SP.new
sp.dir = LibNLXfrm::XFRM_POLICY_OUT
sp.action = LibNLXfrm::XFRM_POLICY_ALLOW
sp.priority = 100_u32

# Create a selector
sel = LibNLXfrm.xfrmnl_sel_alloc
# Set addresses, ports, etc. (omitted for brevity)
sp.sel = sel

# Add a template
tmpl = LibNLXfrm.xfrmnl_user_tmpl_alloc
# Set template parameters (omitted)
sp.add_user_tmpl(tmpl)

puts "Security Policy created (details omitted for brevity)."
# sp.add(sk)
