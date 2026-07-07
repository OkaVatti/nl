# src/libnl/xfrm.cr
#
# Main entry point for the libnl‑xfrm bindings.
# Requires all xfrm sub‑modules.

require "./xfrm/types"
require "./xfrm/sa"
require "./xfrm/sp"
require "./xfrm/ae"
require "./xfrm/lifetime"
require "./xfrm/selector"
require "./xfrm/template"
