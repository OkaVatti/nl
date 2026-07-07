#!/usr/bin/env crystal
# examples/genl_send.cr
# Send a generic netlink request and parse the response.

require "../src/nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_GENERIC)

# Build a request to get information about the "nlctrl" family
family = Nl::Genl.get_family(sk, "nlctrl") # get the family object

msg = Nl::Message.new
genl_hdr = LibNLGenl.genlmsg_put(
  msg.to_unsafe,
  0_u32,
  0_u32,
  family.to_unsafe,
  0,
  LibNL::NLM_F_REQUEST,
  LibNLGenl::CTRL_CMD_GETFAMILY,
  1_u8
)
raise "Failed to put genl header" if genl_hdr.null?

# Add attribute with the family name we want to query (e.g., "nlctrl")
msg.put_string(LibNLGenl::CTRL_ATTR_FAMILY_NAME, "nlctrl")

sk.send_message(msg)
sk.recv_default

puts "Generic netlink request sent and response received."
