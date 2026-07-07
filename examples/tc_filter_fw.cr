#!/usr/bin/env crystal
# examples/tc_filter_fw.cr
# Add a firewall mark filter (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to configure TC."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

ifindex = 1
parent = 0x10000_u32

filter = Nl::Route::TC::Filter.new
filter.ifindex = ifindex
filter.parent = parent
filter.kind = "fw"
filter.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

filter.fw_classid = 0x10001
filter.fw_mask = 0xffffffff

puts "FW filter added"
