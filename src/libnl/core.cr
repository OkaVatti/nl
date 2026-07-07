# src/libnl/core.cr
#
# Main entry point for the libnl core bindings.
# Requires all core sub‑modules.

require "./core/types"
require "./core/error"
require "./core/socket"
require "./core/message"
require "./core/attr"
require "./core/send_recv"
require "./core/callback"
require "./core/object"
require "./core/cache"
require "./core/addr"
require "./core/data"
require "./core/helpers"
