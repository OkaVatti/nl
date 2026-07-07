# src/libnl/genl.cr
#
# Main entry point for the libnl‑genl bindings.
# Requires all genl sub‑modules.

require "./genl/types"
require "./genl/family"
require "./genl/msg"
require "./genl/ctrl"
require "./genl/helpers" # new
