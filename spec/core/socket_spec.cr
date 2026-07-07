# spec/core/socket_spec.cr
require "../spec_helper"

describe "LibNL" do
  describe "socket" do
    it "allocates and frees a socket" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_socket_free(sk)
    end

    it "allocates a socket with a callback" do
      cb = LibNL.nl_cb_alloc(LibNL::NlCbKind::NL_CB_DEFAULT)
      cb.should_not be_nil
      sk = LibNL.nl_socket_alloc_cb(cb)
      sk.should_not be_nil
      LibNL.nl_socket_free(sk)
      LibNL.nl_cb_put(cb)
    end

    it "connects to NETLINK_ROUTE (if possible)" do
      # If connection is not possible, we just pass the test silently.
      if NLSpecHelpers.can_connect?(LibNL::NETLINK_ROUTE)
        sk = LibNL.nl_socket_alloc
        sk.should_not be_nil
        ret = LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE)
        ret.should eq(0)
        LibNL.nl_socket_free(sk)
      end
    end

    it "gets and sets local port" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_socket_set_local_port(sk, 12345_u32)
      port = LibNL.nl_socket_get_local_port(sk)
      port.should eq(12345_u32)
      LibNL.nl_socket_free(sk)
    end

    it "gets and sets peer port" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_socket_set_peer_port(sk, 54321_u32)
      port = LibNL.nl_socket_get_peer_port(sk)
      port.should eq(54321_u32)
      LibNL.nl_socket_free(sk)
    end

    it "enables and disables auto-ack" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_socket_enable_auto_ack(sk)
      LibNL.nl_socket_disable_auto_ack(sk)
      LibNL.nl_socket_free(sk)
    end

    it "sets and gets buffer sizes" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      ret = LibNL.nl_socket_set_buffer_size(sk, 32768, 32768)
      ret.should be_a(Int32)
      LibNL.nl_socket_set_msg_buf_size(sk, 8192_u64)
      size = LibNL.nl_socket_get_msg_buf_size(sk)
      size.should eq(8192_u64)
      LibNL.nl_socket_free(sk)
    end

    it "sets non-blocking mode" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      LibNL.nl_socket_set_nonblocking(sk)
      LibNL.nl_socket_free(sk)
    end

    it "manages membership groups" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      ret = LibNL.nl_socket_add_membership(sk, 1)
      ret.should be_a(Int32)
      ret = LibNL.nl_socket_drop_membership(sk, 1)
      ret.should be_a(Int32)
      LibNL.nl_socket_free(sk)
    end

    it "generates a sequence number" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      seq = LibNL.nl_socket_use_seq(sk)
      seq.should be > 0_u32
      LibNL.nl_socket_free(sk)
    end

    it "gets and sets file descriptor (if connected)" do
      sk = LibNL.nl_socket_alloc
      sk.should_not be_nil
      if LibNL.nl_connect(sk, LibNL::NETLINK_ROUTE) == 0
        fd = LibNL.nl_socket_get_fd(sk)
        fd.should be >= 0
        LibNL.nl_socket_set_fd(sk, LibNL::NETLINK_ROUTE, fd)
      end
      LibNL.nl_socket_free(sk)
    end
  end
end
