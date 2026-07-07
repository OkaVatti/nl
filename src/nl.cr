# The `nl` shard provides Crystal bindings and a high‑level wrapper for the
# **libnl** C library, enabling interaction with the Linux kernel's netlink
# socket interface.
#
# It supports:
# - Core netlink operations (sockets, messages, attributes, caches)
# - Routing (links, addresses, routes, neighbours, traffic control)
# - Generic Netlink (family discovery, message construction)
# - Netfilter (conntrack, logging, queueing)
# - XFRM (security associations, policies)
#
# ## Usage
#
# ```
# require "nl"
#
# # Create a netlink socket and connect to the route protocol
# sk = Nl::Socket.new
# sk.connect(LibNL::NETLINK_ROUTE)
#
# # Get a cache of all network links
# cache = Nl::Route::Link.cache(sk)
#
# # Iterate over links
# cache.each do |obj|
#   link = Nl::Route::Link.new(obj, owned: false)
#   puts "#{link.ifindex}: #{link.name} (MTU: #{link.mtu})"
# end
# ```
#
# For advanced usage, see the submodules under `Nl`.
module Nl
end

# ---- Low-level FFI bindings ----------------------------------------------
require "./libnl/core"
require "./libnl/route"
require "./libnl/genl"
require "./libnl/nf"
require "./libnl/xfrm"

# ---- High-level error handling -------------------------------------------
require "./nl/error"

# ---- High-level core classes ---------------------------------------------
require "./nl/core/socket"
require "./nl/core/message"
require "./nl/core/attribute"
require "./nl/core/cache"

# ---- High-level route classes --------------------------------------------
require "./nl/route/link"
require "./nl/route/address"
require "./nl/route/route"
require "./nl/route/tc"
require "./nl/route/neighbour"
require "./nl/route/rule"

# ---- High-level Generic Netlink ------------------------------------------
require "./nl/genl"
require "./nl/genl/family"

# ---- High-level Netfilter ------------------------------------------------
require "./nl/nf/conntrack"

# ---- High-level XFRM -----------------------------------------------------
require "./nl/xfrm/sa"
