# src/libnl/core/callback.cr
#
# Callback handle management and registration.

@[Link("nl-3")]
lib LibNL
  # ---- Allocation / Free / Clone ------------------------------------------

  fun nl_cb_alloc = nl_cb_alloc(kind : NlCbKind) : Pointer(NL_Cb)
  fun nl_cb_clone = nl_cb_clone(orig : Pointer(NL_Cb)) : Pointer(NL_Cb)
  fun nl_cb_get = nl_cb_get(cb : Pointer(NL_Cb)) : Pointer(NL_Cb)
  fun nl_cb_put = nl_cb_put(cb : Pointer(NL_Cb)) : Void

  # ---- Active callback type -----------------------------------------------

  fun nl_cb_active_type = nl_cb_active_type(cb : Pointer(NL_Cb)) : NlCbType

  # ---- Setting callbacks --------------------------------------------------

  fun nl_cb_set = nl_cb_set(
    cb : Pointer(NL_Cb),
    type : NlCbType,
    kind : NlCbKind,
    func : NlRecvMsgCb,
    arg : Pointer(Void),
  ) : Int32

  fun nl_cb_set_all = nl_cb_set_all(
    cb : Pointer(NL_Cb),
    kind : NlCbKind,
    func : NlRecvMsgCb,
    arg : Pointer(Void),
  ) : Int32

  fun nl_cb_err = nl_cb_err(
    cb : Pointer(NL_Cb),
    kind : NlCbKind,
    func : NlRecvErrCb,
    arg : Pointer(Void),
  ) : Int32

  # ---- Overwriting internal send function ---------------------------------

  fun nl_cb_overwrite_send = nl_cb_overwrite_send(cb : Pointer(NL_Cb), func : NlCbSend) : Void
  fun nl_cb_overwrite_recvmsgs = nl_cb_overwrite_recvmsgs(cb : Pointer(NL_Cb), func : (Pointer(NL_Sock), Pointer(NL_Cb) -> Int32)) : Void
end
