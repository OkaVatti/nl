#!/usr/bin/env crystal
# examples/tc_filter_u32.cr
# Add a U32 filter to classify traffic (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to configure TC."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

ifindex = 1
parent = 0x10000_u32 # 1:0 (HTB root handle)

filter = Nl::Route::TC::Filter.new
filter.ifindex = ifindex
filter.parent = parent
filter.kind = "u32"
filter.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

filter.u32_handle = 0x800
filter.u32_classid = 0x10001 # send to class 1:1
# In practice, you'd add match rules via attributes (not directly in this wrapper).

puts "U32 filter added (basic parameters set)"
