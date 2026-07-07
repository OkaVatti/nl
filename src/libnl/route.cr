# src/libnl/route.cr
#
# Main entry point for the libnl‑route bindings.
# Requires all route sub‑modules.

require "./route/types"
require "./route/link"
require "./route/addr"
require "./route/route"
require "./route/neighbour"
require "./route/tc"
require "./route/rule"
