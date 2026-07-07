#!/usr/bin/env crystal
# examples/tc_sfq.cr
# Create an SFQ qdisc (requires root).

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
qdisc.kind = "sfq"
qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

qdisc.sfq_quantum = 1514_u32
qdisc.sfq_perturb = 10_u32

puts "SFQ qdisc added"
