#!/usr/bin/env crystal
# examples/tc_htb.cr
# Create an HTB qdisc and a class (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to configure TC."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# We'll work on eth0 (ifindex 1)
ifindex = 1

# 1. Create HTB qdisc at root (handle 1:0)
qdisc = Nl::Route::TC::Qdisc.new
qdisc.ifindex = ifindex
qdisc.parent = 0_u32 # root
qdisc.kind = "htb"
qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

# Now we can set HTB parameters
qdisc.htb_rate = 1000000_u32 # 1 Mbps
qdisc.htb_ceil = 2000000_u32 # 2 Mbps
qdisc.htb_prio = 0_u8
qdisc.htb_r2q = 10_u16

puts "HTB qdisc added at root (handle 1:0)"

# 2. Create a class under the qdisc (handle 1:1)
cls = Nl::Route::TC::Class.new
cls.ifindex = ifindex
cls.parent = 0x10000_u32 # 1:0
cls.handle = 0x10001_u32 # 1:1
cls.kind = "htb"
cls.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

cls.htb_rate = 500000_u32
cls.htb_ceil = 1000000_u32
cls.htb_prio = 1_u8

puts "HTB class 1:1 created"
