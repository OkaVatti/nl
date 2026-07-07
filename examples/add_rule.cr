#!/usr/bin/env crystal
# examples/add_rule.cr
# Add a routing rule (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to add a rule."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# Create a rule that routes traffic from 192.168.2.0/24 to table 100
src = Pointer(LibNL::NL_Addr).null
ret = LibNL.nl_addr_parse("192.168.2.0/24", LibNL::AF_INET, pointerof(src))
raise "Failed to parse source network" if ret < 0

rule = Nl::Route::Rule.new
rule.family = LibNL::AF_INET
rule.table = 100_u32
rule.priority = 1000_u32
rule.action = RtnlRuleAction::FR_ACT_TO_TBL
rule.src = src

rule.add(sk)
puts "Routing rule added"

LibNL.nl_addr_put(src)
