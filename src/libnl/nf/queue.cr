# src/libnl/nf/queue.cr
#
# Netfilter queue (NFQUEUE) – allocation, configuration, binding,
# and verdict handling.

@[Link("nl-nf-3")]
lib LibNLNf
  # ---- Queue object allocation / free -----------------------------------

  fun nfnl_queue_alloc = nfnl_queue_alloc : Pointer(NfnlQueue)
  fun nfnl_queue_put = nfnl_queue_put(queue : Pointer(NfnlQueue)) : Void
  fun nfnl_queue_get = nfnl_queue_get(queue : Pointer(NfnlQueue)) : Void

  # ---- Queue configuration setters / getters ----------------------------

  fun nfnl_queue_set_queue_num = nfnl_queue_set_queue_num(
    queue : Pointer(NfnlQueue),
    queuenum : UInt16,
  ) : Void
  fun nfnl_queue_get_queue_num = nfnl_queue_get_queue_num(
    queue : Pointer(NfnlQueue),
  ) : UInt16

  fun nfnl_queue_set_copy_mode = nfnl_queue_set_copy_mode(
    queue : Pointer(NfnlQueue),
    mode : NfQueueCopyMode,
  ) : Void
  fun nfnl_queue_get_copy_mode = nfnl_queue_get_copy_mode(
    queue : Pointer(NfnlQueue),
  ) : NfQueueCopyMode

  fun nfnl_queue_set_copy_range = nfnl_queue_set_copy_range(
    queue : Pointer(NfnlQueue),
    range : UInt32,
  ) : Void
  fun nfnl_queue_get_copy_range = nfnl_queue_get_copy_range(
    queue : Pointer(NfnlQueue),
  ) : UInt32

  # ---- Bind / unbind ---------------------------------------------------

  fun nfnl_queue_bind = nfnl_queue_bind(
    sk : Pointer(LibNL::NL_Sock),
    queue : Pointer(NfnlQueue),
  ) : Int32

  fun nfnl_queue_unbind = nfnl_queue_unbind(
    sk : Pointer(LibNL::NL_Sock),
    queue : Pointer(NfnlQueue),
  ) : Int32

  # ---- Build netlink messages for queue configuration ------------------

  fun nfnl_queue_build_bind_request = nfnl_queue_build_bind_request(
    queue : Pointer(NfnlQueue),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  fun nfnl_queue_build_unbind_request = nfnl_queue_build_unbind_request(
    queue : Pointer(NfnlQueue),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Parse a netlink message into a queue object ----------------------

  fun nfnl_queue_parse = nfnl_queue_parse(
    nlh : Pointer(LibNL::NL_Msg),
    result : Pointer(Pointer(NfnlQueue)),
  ) : Int32

  # ---- Sending verdicts (for queued packets) ---------------------------

  # Build a verdict message for a specific packet (identified by packet ID).
  fun nfnl_queue_build_verdict = nfnl_queue_build_verdict(
    sk : Pointer(LibNL::NL_Sock),
    queue_num : UInt16,
    packet_id : UInt32,
    verdict : Int32,
    data : Pointer(Void),
    data_len : UInt32,
  ) : Int32

  # Send a verdict (simpler version).
  fun nfnl_queue_verdict = nfnl_queue_verdict(
    sk : Pointer(LibNL::NL_Sock),
    queue_num : UInt16,
    packet_id : UInt32,
    verdict : Int32,
  ) : Int32

  # Send verdict with a modified packet payload (for NAT, etc.).
  fun nfnl_queue_verdict_payload = nfnl_queue_verdict_payload(
    sk : Pointer(LibNL::NL_Sock),
    queue_num : UInt16,
    packet_id : UInt32,
    verdict : Int32,
    data : Pointer(Void),
    data_len : UInt32,
  ) : Int32
end
