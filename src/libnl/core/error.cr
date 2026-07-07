# src/libnl/core/error.cr
#
# libnl error codes and the function that returns the last error message.

@[Link("nl-3")]
lib LibNL
  # ---- Error codes (from <netlink/errno.h>) -------------------------------

  NLE_SUCCESS      =  0
  NLE_FAILURE      =  1
  NLE_INTR         =  2
  NLE_BAD_SOCK     =  3
  NLE_AGAIN        =  4
  NLE_NOMEM        =  5
  NLE_EXIST        =  6
  NLE_INVAL        =  7
  NLE_RANGE        =  8
  NLE_MSGSIZE      =  9
  NLE_OPNOTSUPP    = 10
  NLE_AF_NOSUPPORT = 11
  NLE_OBJ_NOTFOUND = 12
  NLE_NOATTR       = 13
  NLE_MISSING_ATTR = 14
  NLE_OUTOF_RANGE  = 15
  NLE_BADMSG       = 16
  NLE_BADFUNC      = 17
  NLE_ROUND_ERR    = 18
  NLE_NOADDR       = 19
  NLE_MULTIPLE     = 20
  NLE_NODEV        = 21
  NLE_NO_CACHE     = 22
  NLE_SRCADDR      = 23
  NLE_UNSPEC       = 24
  NLE_INVAL_SOCK   = 25
  NLE_INVAL_CACHE  = 26
  NLE_INVAL_ATTR   = 27
  NLE_NOMEM_RX     = 28
  NLE_NO_FILE      = 29
  NLE_ALIGN        = 30
  NLE_PERM         = 31

  # ---- Retrieve error message ---------------------------------------------

  fun nl_geterror = nl_geterror(code : Int32) : LibC::Char*
end
