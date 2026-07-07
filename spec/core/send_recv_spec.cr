# spec/core/send_recv_spec.cr
require "../spec_helper"

describe "LibNL send/recv" do
  it "sends a GETLINK request and receives a response" do
    # Only run if we can connect to NETLINK_ROUTE
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)

      # Build a GETLINK request (dump all links)
      msg = LibNL.nlmsg_alloc
      msg.should_not be_nil
      hdr = LibNL.nlmsg_put(msg, 0, 0, LibNL::RTM_GETLINK, 0, LibNL::NLM_F_REQUEST | LibNL::NLM_F_DUMP)
      hdr.should_not be_nil

      # Send the message
      ret = LibNL.nl_send_auto(sk, msg)
      ret.should be >= 0

      # Receive and process the response using default callbacks
      # We'll just check that it returns success (0) – this covers nl_recvmsgs_default
      ret = LibNL.nl_recvmsgs_default(sk)
      ret.should eq(0)

      LibNL.nlmsg_free(msg)
      LibNL.nl_socket_free(sk)
    end
  end

  it "sends a simple message and waits for ACK" do
    if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE).should eq(0)

      # Build a GETLINK request with NLM_F_ACK to force an ACK
      msg = LibNL.nlmsg_alloc
      msg.should_not be_nil
      hdr = LibNL.nlmsg_put(msg, 0, 0, LibNL::RTM_GETLINK, 0, LibNL::NLM_F_REQUEST | LibNL::NLM_F_ACK)
      hdr.should_not be_nil

      ret = LibNL.nl_send_auto(sk, msg)
      ret.should be >= 0

      # Wait for ACK (this will block until ACK is received or timeout)
      # We'll just check that it returns 0 (success) or -NLE_* error
      ret = LibNL.nl_wait_for_ack(sk)
      ret.should eq(0)

      LibNL.nlmsg_free(msg)
      LibNL.nl_socket_free(sk)
    end
  end
end
