# src/libnl/core/socket.cr
#
# Netlink socket allocation, configuration, connection, and teardown.

@[Link("nl-3")]
lib LibNL
  # ---- Allocation / Free --------------------------------------------------

  fun nl_socket_alloc = nl_socket_alloc : Pointer(NL_Sock)
  fun nl_socket_alloc_cb = nl_socket_alloc_cb(cb : Pointer(NL_Cb)) : Pointer(NL_Sock)
  fun nl_socket_free = nl_socket_free(sk : Pointer(NL_Sock)) : Void

  # ---- Connection / Close -------------------------------------------------

  fun nl_connect = nl_connect(sk : Pointer(NL_Sock), protocol : Int32) : Int32
  fun nl_close = nl_close(sk : Pointer(NL_Sock)) : Void

  # ---- Socket options -----------------------------------------------------

  fun nl_socket_set_cb = nl_socket_set_cb(sk : Pointer(NL_Sock), cb : Pointer(NL_Cb)) : Void
  fun nl_socket_get_cb = nl_socket_get_cb(sk : Pointer(NL_Sock)) : Pointer(NL_Cb)

  fun nl_socket_set_local_port = nl_socket_set_local_port(sk : Pointer(NL_Sock), port : UInt32) : Void
  fun nl_socket_get_local_port = nl_socket_get_local_port(sk : Pointer(NL_Sock)) : UInt32

  fun nl_socket_set_peer_port = nl_socket_set_peer_port(sk : Pointer(NL_Sock), port : UInt32) : Void
  fun nl_socket_get_peer_port = nl_socket_get_peer_port(sk : Pointer(NL_Sock)) : UInt32

  fun nl_socket_set_peer_groups = nl_socket_set_peer_groups(sk : Pointer(NL_Sock), groups : UInt32) : Void
  fun nl_socket_get_peer_groups = nl_socket_get_peer_groups(sk : Pointer(NL_Sock)) : UInt32

  fun nl_socket_set_nonblocking = nl_socket_set_nonblocking(sk : Pointer(NL_Sock)) : Void

  fun nl_socket_enable_auto_ack = nl_socket_enable_auto_ack(sk : Pointer(NL_Sock)) : Void
  fun nl_socket_disable_auto_ack = nl_socket_disable_auto_ack(sk : Pointer(NL_Sock)) : Void

  fun nl_socket_enable_seq_check = nl_socket_enable_seq_check(sk : Pointer(NL_Sock)) : Void
  fun nl_socket_disable_seq_check = nl_socket_disable_seq_check(sk : Pointer(NL_Sock)) : Void

  fun nl_socket_set_buffer_size = nl_socket_set_buffer_size(sk : Pointer(NL_Sock), rxbuf : Int32, txbuf : Int32) : Int32
  fun nl_socket_set_msg_buf_size = nl_socket_set_msg_buf_size(sk : Pointer(NL_Sock), bufsize : LibC::SizeT) : Void
  fun nl_socket_get_msg_buf_size = nl_socket_get_msg_buf_size(sk : Pointer(NL_Sock)) : LibC::SizeT

  fun nl_socket_set_fd = nl_socket_set_fd(
    sk : Pointer(NL_Sock),
    protocol : Int32,
    fd : Int32,
  ) : Int32
  fun nl_socket_get_fd = nl_socket_get_fd(sk : Pointer(NL_Sock)) : Int32

  # ---- Membership groups --------------------------------------------------

  fun nl_socket_add_membership = nl_socket_add_membership(sk : Pointer(NL_Sock), group : Int32) : Int32
  fun nl_socket_add_memberships = nl_socket_add_memberships(sk : Pointer(NL_Sock), group : Int32, ...) : Int32
  fun nl_socket_drop_membership = nl_socket_drop_membership(sk : Pointer(NL_Sock), group : Int32) : Int32
  fun nl_socket_drop_memberships = nl_socket_drop_memberships(sk : Pointer(NL_Sock), group : Int32, ...) : Int32

  # ---- Sequence numbers ---------------------------------------------------

  fun nl_socket_use_seq = nl_socket_use_seq(sk : Pointer(NL_Sock)) : UInt32

  # ---- Additional socket operations ----------------------------------------
  fun nl_socket_modify_cb = nl_socket_modify_cb(
    sk : Pointer(NL_Sock),
    type : NlCbType,
    kind : NlCbKind,
    func : NlRecvMsgCb,
    arg : Pointer(Void),
  ) : Int32

  fun nl_socket_modify_err_cb = nl_socket_modify_err_cb(
    sk : Pointer(NL_Sock),
    kind : NlCbKind,
    func : NlRecvErrCb,
    arg : Pointer(Void),
  ) : Int32

  fun nl_socket_set_passcred = nl_socket_set_passcred(
    sk : Pointer(NL_Sock),
    state : Int32,
  ) : Int32

  fun nl_socket_recv_pktinfo = nl_socket_recv_pktinfo(
    sk : Pointer(NL_Sock),
    state : Int32,
  ) : Int32

  fun nl_socket_enable_msg_peek = nl_socket_enable_msg_peek(
    sk : Pointer(NL_Sock),
  ) : Void

  fun nl_socket_disable_msg_peek = nl_socket_disable_msg_peek(
    sk : Pointer(NL_Sock),
  ) : Void

  fun nl_join_groups = nl_join_groups(
    sk : Pointer(NL_Sock),
    groups : Int32,
  ) : Void
end
