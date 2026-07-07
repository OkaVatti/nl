# spec/spec_helper.cr
require "spec"
require "../src/libnl/core"
require "../src/libnl/core/message"
require "../src/libnl/core/attr"
require "../src/libnl/genl/msg"
require "../src/libnl/route"
require "../src/libnl/genl"
require "../src/libnl/nf"
require "../src/libnl/xfrm"

# Helper module for checking test prerequisites
module NLSpecHelpers
  # Check if we have permission to connect to a given netlink protocol
  def self.can_connect?(protocol : Int32) : Bool
    sk = LibNL.nl_socket_alloc
    return false if sk.null?
    result = LibNL.nl_connect(sk, protocol)
    LibNL.nl_socket_free(sk)
    result == 0
  rescue
    false
  end

  # Check if we have root privileges (effective UID 0)
  def self.root? : Bool
    Process.uid == 0
  end
end
