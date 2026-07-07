#!/usr/bin/env crystal
# examples/tc_tbf.cr
# Create a TBF qdisc (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to configure TC."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

ifindex = 1

qdisc = Nl::Route::TC::Qdisc.new
qdisc.ifindex = ifindex
qdisc.parent = 0_u32
qdisc.kind = "tbf"
qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

# Set TBF parameters
qdisc.tbf_rate(1000000_u32, 1024_u32) # rate, burst
qdisc.tbf_limit = 10240_u32

puts "TBF qdisc added"
