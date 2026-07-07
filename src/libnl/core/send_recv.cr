# src/libnl/core/send_recv.cr
#
# Sending and receiving netlink messages.

@[Link("nl-3")]
lib LibNL
  # ---- Basic send / receive -----------------------------------------------

  fun nl_sendto = nl_sendto(sk : Pointer(NL_Sock), buf : Pointer(Void), size : LibC::SizeT) : Int32
  fun nl_sendmsg = nl_sendmsg(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg), hdr : Pointer(Void)) : Int32
  fun nl_send_iovec = nl_send_iovec(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg), iov : Pointer(Void), iovlen : UInt32) : Int32
  fun nl_send = nl_send(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg)) : Int32

  fun nl_recv = nl_recv(sk : Pointer(NL_Sock), buf : Pointer(Void), buf_size : LibC::SizeT) : Int32

  # ---- Auto‑complete / finalise -------------------------------------------

  fun nl_complete_msg = nl_complete_msg(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg)) : Void
  fun nl_send_auto = nl_send_auto(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg)) : Int32
  fun nl_send_sync = nl_send_sync(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg)) : Int32
  fun nl_send_simple = nl_send_simple(
    sk : Pointer(NL_Sock),
    type : Int32,
    flags : Int32,
    buf : Pointer(Void),
    size : LibC::SizeT,
  ) : Int32

  # ---- Receive with callbacks ---------------------------------------------

  fun nl_recvmsgs = nl_recvmsgs(sk : Pointer(NL_Sock), cb : Pointer(NL_Cb)) : Int32
  fun nl_recvmsgs_default = nl_recvmsgs_default(sk : Pointer(NL_Sock)) : Int32

  # ---- Wait for ACK -------------------------------------------------------

  fun nl_wait_for_ack = nl_wait_for_ack(sk : Pointer(NL_Sock)) : Int32

  # ---- Auto‑complete (deprecated, but kept for completeness) --------------

  fun nl_send_auto_complete = nl_send_auto_complete(sk : Pointer(NL_Sock), msg : Pointer(NL_Msg)) : Int32

  # ---- Additional send/receive operations ----------------------------------
  fun nl_auto_complete = nl_auto_complete(
    sk : Pointer(NL_Sock),
    msg : Pointer(NL_Msg),
  ) : Void

  fun nl_recvmsgs_report = nl_recvmsgs_report(
    sk : Pointer(NL_Sock),
    cb : Pointer(NL_Cb),
  ) : Int32

  fun nl_pickup = nl_pickup(
    sk : Pointer(NL_Sock),
    parser : (Pointer(NL_Cache_Ops), Pointer(Void), Pointer(Void), Pointer(Void) -> Int32),
    result : Pointer(Pointer(NL_Object)),
  ) : Int32

  fun nl_pickup_keep_syserr = nl_pickup_keep_syserr(
    sk : Pointer(NL_Sock),
    parser : (Pointer(NL_Cache_Ops), Pointer(Void), Pointer(Void), Pointer(Void) -> Int32),
    result : Pointer(Pointer(NL_Object)),
    syserror : Pointer(Int32),
  ) : Int32

  fun nl_nlfamily2str = nl_nlfamily2str(
    family : Int32,
    buf : LibC::Char*,
    len : LibC::SizeT,
  ) : LibC::Char*

  fun nl_str2nlfamily = nl_str2nlfamily(
    str : LibC::Char*,
  ) : Int32
end
