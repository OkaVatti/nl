#!/usr/bin/env crystal
# examples/nf_conntrack.cr
# Add a conntrack entry (simplified; requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to add conntrack entries."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_NETFILTER)

# Create a conntrack entry
ct = Nl::NF::Conntrack::Entry.new
ct.status = LibNLNf::IPS_SEEN_REPLY | LibNLNf::IPS_ASSURED
ct.mark = 0x12345678_u32
ct.timeout = 300_u32

# To set the tuple (orig/reply), you need to build nested attributes.
# This is more complex; for a full example see the low‑level helpers.
# We'll just add a placeholder and note that the tuple must be set.
puts "Conntrack entry created (tuple not set – this example is incomplete)."
puts "See libnl documentation for how to set tuples."

# ct.add(sk)
