# src/libnl/core/types.cr
#
# Core type aliases, opaque structs, and fundamental constants for libnl.
# All structs are opaque – their internal layout is not exposed to Crystal.
# We add a dummy `_unused` field to satisfy Crystal's requirement that structs are non‑empty.

@[Link("nl-3")]
lib LibNL
  # ---- Opaque handle types -------------------------------------------------

  @[Extern]
  struct NL_Sock
    _unused : UInt8
  end

  @[Extern]
  struct NL_Msg
    _unused : UInt8
  end

  @[Extern]
  struct NL_Cache
    _unused : UInt8
  end

  @[Extern]
  struct NL_Object
    _unused : UInt8
  end

  @[Extern]
  struct NL_Cb
    _unused : UInt8
  end

  @[Extern]
  struct NL_Attr
    _unused : UInt8
  end

  @[Extern]
  struct NL_Cache_Ops
    _unused : UInt8
  end

  @[Extern]
  struct NL_Object_Ops
    _unused : UInt8
  end

  @[Extern]
  struct NL_Addr
    _unused : UInt8
  end

  @[Extern]
  struct NL_DumpParams
    _unused : UInt8
  end

  # ---- Concrete structs for netlink headers and attributes ----------------

  @[Extern]
  struct NlMsghdr
    nlmsg_len : UInt32
    nlmsg_type : UInt16
    nlmsg_flags : UInt16
    nlmsg_seq : UInt32
    nlmsg_pid : UInt32
  end

  @[Extern]
  struct NlAttr
    nla_len : UInt16
    nla_type : UInt16
    # payload follows
  end

  # ---- Netlink protocol families (from <linux/netlink.h>) ------------------

  NETLINK_ROUTE          =  0
  NETLINK_UNUSED         =  1
  NETLINK_USERSOCK       =  2
  NETLINK_FIREWALL       =  3
  NETLINK_SOCK_DIAG      =  4
  NETLINK_NFLOG          =  5
  NETLINK_XFRM           =  6
  NETLINK_SELINUX        =  7
  NETLINK_ISCSI          =  8
  NETLINK_AUDIT          =  9
  NETLINK_FIB_LOOKUP     = 10
  NETLINK_CONNECTOR      = 11
  NETLINK_NETFILTER      = 12
  NETLINK_IP6_FW         = 13
  NETLINK_DNRTMSG        = 14
  NETLINK_KOBJECT_UEVENT = 15
  NETLINK_GENERIC        = 16
  NETLINK_SCSITRANSPORT  = 18
  NETLINK_ECRYPTFS       = 19
  NETLINK_RDMA           = 20
  NETLINK_CRYPTO         = 21

  # ---- Standard netlink message flags (from <linux/netlink.h>) -------------

  NLM_F_REQUEST       = 0x001
  NLM_F_MULTI         = 0x002
  NLM_F_ACK           = 0x004
  NLM_F_ECHO          = 0x008
  NLM_F_DUMP_INTR     = 0x010
  NLM_F_DUMP_FILTERED = 0x020

  NLM_F_ROOT   = 0x100
  NLM_F_MATCH  = 0x200
  NLM_F_ATOMIC = 0x400
  NLM_F_DUMP   = (NLM_F_ROOT | NLM_F_MATCH)

  NLM_F_REPLACE = 0x100
  NLM_F_EXCL    = 0x200
  NLM_F_CREATE  = 0x400
  NLM_F_APPEND  = 0x800

  # ---- nl_cb kinds (from <netlink/cb.h>) -----------------------------------

  enum NlCbKind : Int32
    NL_CB_DEFAULT = 0
    NL_CB_VERBOSE = 1
    NL_CB_DEBUG   = 2
    NL_CB_CUSTOM  = 3
  end

  # ---- nl_cb callback types (from <netlink/cb.h>) -------------------------

  enum NlCbType : Int32
    NL_CB_INVALID   = 0
    NL_CB_MSG_IN    = 1
    NL_CB_MSG_OUT   = 2
    NL_CB_SKIPPED   = 3
    NL_CB_ACK       = 4
    NL_CB_FINISH    = 5
    NL_CB_OVERRUN   = 6
    NL_CB_VALID     = 7
    NL_CB_SEQ_CHECK = 8
  end

  # ---- Callback function types (used in callback.cr) ----------------------

  # nl_recvmsg_msg_cb_t
  type NlRecvMsgCb = (Pointer(NL_Sock), Pointer(NL_Msg), Pointer(Void) -> Int32)

  # nl_recvmsg_err_cb_t
  type NlRecvErrCb = (Pointer(NL_Sock), Int32, Pointer(Void) -> Int32)

  # nl_cb_send_cb_t
  type NlCbSend = (Pointer(NL_Sock), Pointer(NL_Msg) -> Int32)

  # ---- Utility type for attribute policies (used in attr.cr) --------------

  @[Extern]
  struct NlaPolicy
    type : Int32 # NLA_* constants (not defined here; user supplies them)
    min_len : Int32
    max_len : Int32
  end

  # ---- NL_AUTO_* constants (from netlink/msg.h) ----------------------------
  NL_AUTO_PORT = 0_u32
  NL_AUTO_PID  = 0_u32
  NL_AUTO_SEQ  = 0_u32
  NL_DONTPAD   =     0

  # ---- Cache action types (from netlink/cache.h) ---------------------------
  enum NlAct : Int32
    NL_ACT_UNSPEC = 0
    NL_ACT_NEW    = 1
    NL_ACT_DEL    = 2
    NL_ACT_GET    = 3
    NL_ACT_SET    = 4
    NL_ACT_CHANGE = 5
  end

  # ---- RTM_* constants from <linux/rtnetlink.h> ----
  RTM_GETLINK  = 18
  RTM_NEWLINK  = 16
  RTM_DELLINK  = 17
  RTM_GETADDR  = 22
  RTM_NEWADDR  = 20
  RTM_GETROUTE = 26
  RTM_NEWROUTE = 24

  # ---- AF_* constants / Address Families (from <sys/socket.h>)
  AF_UNSPEC =  0
  AF_INET   =  2
  AF_INET6  = 10

  # src/libnl/core/types.cr (add after other opaque structs)
  @[Extern]
  struct NL_Data
    _unused : UInt8
  end

  # ---- Change callback types (from netlink/cache.h) ------------------------
  type ChangeFuncT = (Pointer(NL_Cache), Pointer(NL_Object), Int32, Pointer(Void) -> Void)
  type ChangeFuncV2T = (Pointer(NL_Cache), Pointer(NL_Object), Pointer(NL_Object), UInt64, Int32, Pointer(Void) -> Void)
end
