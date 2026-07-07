# src/libnl/nf/types.cr
#
# Netfilter‑specific type aliases, opaque structs, and constants.
# All opaque structs have a dummy `_unused` field to satisfy Crystal.

@[Link("nl-nf-3")]
lib LibNLNf
  # ---- Opaque handle types ------------------------------------------------

  @[Extern]
  struct NfnlCt
    _unused : UInt8
  end

  @[Extern]
  struct NfnlLog
    _unused : UInt8
  end

  @[Extern]
  struct NfnlQueue
    _unused : UInt8
  end

  # ---- Conntrack attribute types (CTA_*) from nfnetlink_conntrack.h -----

  enum NfCtAttr : Int32
    CTA_UNSPEC                       =  0
    CTA_TUPLE_ORIG                   =  1
    CTA_TUPLE_REPLY                  =  2
    CTA_STATUS                       =  3
    CTA_PROTOINFO                    =  4
    CTA_HELP                         =  5
    CTA_NAT_SRC                      =  6
    CTA_TIMEOUT                      =  7
    CTA_MARK                         =  8
    CTA_COUNTERS_ORIG                =  9
    CTA_COUNTERS_REPLY               = 10
    CTA_USE                          = 11
    CTA_ID                           = 12
    CTA_NAT_DST                      = 13
    CTA_TUPLE_MASTER                 = 14
    CTA_SEQ_ADJ_ORIG                 = 15
    CTA_NAT_SEQ_ADJ_ORIG             = 16
    CTA_NAT_SEQ_ADJ_REPLY            = 17
    CTA_SECMARK                      = 18
    CTA_ZONE                         = 19
    CTA_TUPLE_ORIG_UNSPEC            = 20
    CTA_TUPLE_REPLY_UNSPEC           = 21
    CTA_TUPLE_MASTER_UNSPEC          = 22
    CTA_TIMESTAMP                    = 23
    CTA_PROTOINFO_UNSPEC             = 24
    CTA_HELP_UNSPEC                  = 25
    CTA_NAT_SRC_UNSPEC               = 26
    CTA_NAT_DST_UNSPEC               = 27
    CTA_COUNTERS_ORIG_UNSPEC         = 28
    CTA_COUNTERS_REPLY_UNSPEC        = 29
    CTA_STATS_UNSPEC                 = 30
    CTA_STATS                        = 31
    CTA_FILTER                       = 32
    CTA_FILTER_UNSPEC                = 33
    CTA_FILTER_ORIG                  = 34
    CTA_FILTER_REPLY                 = 35
    CTA_FILTER_MASTER                = 36
    CTA_FILTER_SRC                   = 37
    CTA_FILTER_DST                   = 38
    CTA_FILTER_PROTO                 = 39
    CTA_FILTER_PORT                  = 40
    CTA_FILTER_PORT_SRC              = 41
    CTA_FILTER_PORT_DST              = 42
    CTA_FILTER_ICMP_TYPE             = 43
    CTA_FILTER_ICMP_CODE             = 44
    CTA_FILTER_TCP_FLAGS             = 45
    CTA_FILTER_TCP_STATE             = 46
    CTA_FILTER_IP                    = 47
    CTA_FILTER_IPV4                  = 48
    CTA_FILTER_IPV6                  = 49
    CTA_FILTER_HANDLE                = 50
    CTA_FILTER_RAW                   = 51
    CTA_FILTER_EXPECT                = 52
    CTA_FILTER_EXPECT_MASTER         = 53
    CTA_FILTER_EXPECT_ORIG           = 54
    CTA_FILTER_EXPECT_REPLY          = 55
    CTA_FILTER_EXPECT_MASK           = 56
    CTA_FILTER_EXPECT_TIMEOUT        = 57
    CTA_FILTER_EXPECT_ID             = 58
    CTA_FILTER_EXPECT_NAT            = 59
    CTA_FILTER_EXPECT_NAT_TUPLE      = 60
    CTA_FILTER_EXPECT_NAT_MASK       = 61
    CTA_FILTER_EXPECT_NAT_ORIG       = 62
    CTA_FILTER_EXPECT_NAT_REPLY      = 63
    CTA_FILTER_EXPECT_NAT_MASTER     = 64
    CTA_FILTER_EXPECT_NAT_UNSPEC     = 65
    CTA_FILTER_EXPECT_NAT_DIR        = 66
    CTA_FILTER_EXPECT_NAT_PROTO      = 67
    CTA_FILTER_EXPECT_NAT_SRC        = 68
    CTA_FILTER_EXPECT_NAT_DST        = 69
    CTA_FILTER_EXPECT_NAT_ANY        = 70
    CTA_FILTER_EXPECT_NAT_ANY_UNSPEC = 71
  end

  # ---- Tuple attributes (CTA_TUPLE_*) -----------------------------------

  enum NfTupleAttr : Int32
    TUPLE_UNSPEC          =  0
    TUPLE_IP              =  1
    TUPLE_IPV4            =  2
    TUPLE_IPV6            =  3
    TUPLE_IP_PROTO        =  4
    TUPLE_IP_SRC          =  5
    TUPLE_IP_DST          =  6
    TUPLE_IP_SRC_MASK     =  7
    TUPLE_IP_DST_MASK     =  8
    TUPLE_IP_SRC_PREFIX   =  9
    TUPLE_IP_DST_PREFIX   = 10
    TUPLE_IP_ORIG         = 11
    TUPLE_IP_REPLY        = 12
    TUPLE_IP_MASTER       = 13
    TUPLE_IP_NAT          = 14
    TUPLE_IP_NAT_ORIG     = 15
    TUPLE_IP_NAT_REPLY    = 16
    TUPLE_IP_NAT_MASTER   = 17
    TUPLE_IP_NAT_UNSPEC   = 18
    TUPLE_IP_NAT_PROTO    = 19
    TUPLE_IP_NAT_SRC      = 20
    TUPLE_IP_NAT_DST      = 21
    TUPLE_IP_NAT_ANY      = 22
    TUPLE_PROTO_UNSPEC    = 23
    TUPLE_PROTO_NUM       = 24
    TUPLE_PROTO_SRC_PORT  = 25
    TUPLE_PROTO_DST_PORT  = 26
    TUPLE_PROTO_ICMP_TYPE = 27
    TUPLE_PROTO_ICMP_CODE = 28
    TUPLE_PROTO_ICMP_ID   = 29
    TUPLE_PROTO_SCTP_VTAG = 30
    TUPLE_PROTO_DCCP_REQ  = 31
    TUPLE_PROTO_GRE_KEY   = 32
  end

  # ---- Conntrack status bits (IPS_* from include/uapi/linux/netfilter.h) -

  IPS_EXPECTED      = 0x00000001
  IPS_SEEN_REPLY    = 0x00000002
  IPS_ASSURED       = 0x00000004
  IPS_CONFIRMED     = 0x00000008
  IPS_SRC_NAT       = 0x00000010
  IPS_DST_NAT       = 0x00000020
  IPS_NAT_MASK      = 0x00000030
  IPS_SEQ_ADJUST    = 0x00000040
  IPS_SRC_NAT_DONE  = 0x00000080
  IPS_DST_NAT_DONE  = 0x00000100
  IPS_NAT_DONE_MASK = 0x00000180
  IPS_DYING         = 0x00000200
  IPS_FIXED_TIMEOUT = 0x00000400
  IPS_TEMPLATE      = 0x00000800
  IPS_UNTRACKED     = 0x00001000
  IPS_HELPER        = 0x00002000

  # ---- Conntrack directions ---------------------------------------------

  enum NfCtDir : Int32
    CT_DIR_ORIG  = 0
    CT_DIR_REPLY = 1
    CT_DIR_MAX   = 2
  end

  # ---- Netfilter log attributes (NFLOG) ---------------------------------

  enum NfLogAttr : Int32
    NFLOG_UNSPEC          =  0
    NFLOG_GROUP           =  1
    NFLOG_COPY_MODE       =  2
    NFLOG_COPY_RANGE      =  3
    NFLOG_QUEUE_THRESHOLD =  4
    NFLOG_FLAGS           =  5
    NFLOG_PREFIX          =  6
    NFLOG_SNAPLEN         =  7
    NFLOG_QTHRESHOLD      =  8
    NFLOG_TIMESTAMP       =  9
    NFLOG_UID             = 10
    NFLOG_GID             = 11
    NFLOG_PID             = 12
    NFLOG_IFINDEX         = 13
    NFLOG_IFNAME          = 14
  end

  enum NfLogCopyMode : Int32
    NFLOG_COPY_NONE   = 0
    NFLOG_COPY_META   = 1
    NFLOG_COPY_PACKET = 2
  end

  # ---- Netfilter queue attributes (NFQUEUE) -----------------------------

  enum NfQueueAttr : Int32
    NFQUEUE_UNSPEC      =  0
    NFQUEUE_QUEUE_NUM   =  1
    NFQUEUE_COPY_MODE   =  2
    NFQUEUE_COPY_RANGE  =  3
    NFQUEUE_VERDICT     =  4
    NFQUEUE_VERDICT_RAW =  5
    NFQUEUE_DATA        =  6
    NFQUEUE_UID         =  7
    NFQUEUE_GID         =  8
    NFQUEUE_PID         =  9
    NFQUEUE_IFINDEX     = 10
    NFQUEUE_IFNAME      = 11
    NFQUEUE_CAP_LEN     = 12
    NFQUEUE_MARK        = 13
    NFQUEUE_HWADDR      = 14
  end

  enum NfQueueCopyMode : Int32
    NFQUEUE_COPY_NONE   = 0
    NFQUEUE_COPY_META   = 1
    NFQUEUE_COPY_PACKET = 2
  end

  # ---- Verdicts (for queue) ---------------------------------------------

  NF_DROP        = 0
  NF_ACCEPT      = 1
  NF_STOLEN      = 2
  NF_QUEUE       = 3
  NF_REPEAT      = 4
  NF_STOP        = 5
  NF_MAX_VERDICT = NF_STOP

  # ---- Conntrack event types (for monitoring) --------------------------

  enum NfCtEvent : Int32
    CT_EVENT_NEW     = 1
    CT_EVENT_UPDATE  = 2
    CT_EVENT_DESTROY = 4
  end

  # ---- Conntrack timestamp (from netlink/netfilter/ct.h) ------------------
  @[Extern]
  struct NfnlCtTimestamp
    start : UInt64
    stop : UInt64
  end

  # ---- TCP states (from netlink/netfilter/ct.h) ---------------------------
  enum NfnlCtTcpState : Int32
    TCP_CONNTRACK_NONE        =  0
    TCP_CONNTRACK_SYN_SENT    =  1
    TCP_CONNTRACK_SYN_RECV    =  2
    TCP_CONNTRACK_ESTABLISHED =  3
    TCP_CONNTRACK_FIN_WAIT    =  4
    TCP_CONNTRACK_CLOSE_WAIT  =  5
    TCP_CONNTRACK_LAST_ACK    =  6
    TCP_CONNTRACK_TIME_WAIT   =  7
    TCP_CONNTRACK_CLOSE       =  8
    TCP_CONNTRACK_LISTEN      =  9
    TCP_CONNTRACK_MAX         = 10
    TCP_CONNTRACK_IGNORE      = 11
  end
end
