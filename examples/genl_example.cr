#!/usr/bin/env crystal
# examples/genl_example.cr
# List all Generic Netlink families.

require "../src/nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_GENERIC)

cache = Nl::Genl.cache(sk)

puts "%-20s %-6s %-8s %s" % ["Family", "ID", "Version", "Multicast Groups"]
cache.each do |obj|
  fam = Nl::Genl::Family.new(obj.as(Pointer(LibNLGenl::GenlFamily)), owned: false)
  groups = (0...fam.mc_grp_count).map { |i| "#{fam.mc_grp_name(i)} (#{fam.mc_grp_id(i)})" }.join(", ")
  puts "%-20s %-6d %-8d %s" % [fam.name, fam.id, fam.version, groups]
end
