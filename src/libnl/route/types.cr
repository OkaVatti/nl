# src/libnl/route/types.cr
#
# Route‑specific type aliases and opaque structs for libnl‑route.
# All opaque structs have a dummy `_unused` field to satisfy Crystal.

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Opaque handle types ------------------------------------------------

  @[Extern]
  struct Rtnl_Link
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Addr
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Route
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Neigh
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Tc
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Qdisc
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Class
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Act
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Rule
    _unused : UInt8
  end

  @[Extern]
  struct Rtnl_Nexthop
    _unused : UInt8
  end

  # ---- Rtnl_Rtcacheinfo has fields, so it's fine as is --------------------
  @[Extern]
  struct Rtnl_Rtcacheinfo
    rtci_clntref : UInt32
    rtci_last_use : UInt32
    rtci_expires : UInt32
    rtci_error : Int32
    rtci_used : UInt32
    rtci_id : UInt32
    rtci_ts : UInt32
    rtci_tsage : UInt32
  end

  # ---- Route cache flags --------------------------------------------------

  ROUTE_CACHE_CONTENT = 1

  # ---- TC statistics identifiers (from <netlink/route/tc.h>) -------------

  enum RtnlTcStatsId : Int32
    RTNL_TC_PACKETS    = 0
    RTNL_TC_BYTES      = 1
    RTNL_TC_RATE_BPS   = 2
    RTNL_TC_RATE_PPS   = 3
    RTNL_TC_QLEN       = 4
    RTNL_TC_BACKLOG    = 5
    RTNL_TC_DROPS      = 6
    RTNL_TC_REQUEUES   = 7
    RTNL_TC_OVERLIMITS = 8
  end

  RTNL_TC_STATS_MAX = 8

  # ---- TC handle utilities ------------------------------------------------

  fun rtnl_tc_handle2str = rtnl_tc_handle2str(handle : UInt32, buf : LibC::Char*, len : LibC::SizeT) : LibC::Char*
  fun rtnl_tc_str2handle = rtnl_tc_str2handle(str : LibC::Char*, handle : UInt32*) : Int32

  # ---- TC transmission time helpers ---------------------------------------

  fun rtnl_tc_calc_txtime = rtnl_tc_calc_txtime(size : Int32, rate : Int32) : Int32
  fun rtnl_tc_calc_bufsize = rtnl_tc_calc_bufsize(rate : Int32, latency : Int32) : Int32
  fun rtnl_tc_calc_cell_log = rtnl_tc_calc_cell_log(size : Int32) : Int32

  RTNL_TC_RTABLE_SIZE = 256

  fun rtnl_tc_build_rate_table = rtnl_tc_build_rate_table(
    table : UInt32*,
    cell_log : UInt8,
    mpu : UInt8,
    rate : Int32,
    size : Int32,
  ) : Int32

  # ---- Link statistics (from netlink/route/link.h) -------------------------
  enum RtnlLinkStat : Int32
    RTNL_LINK_RX_PACKETS           =  0
    RTNL_LINK_TX_PACKETS           =  1
    RTNL_LINK_RX_BYTES             =  2
    RTNL_LINK_TX_BYTES             =  3
    RTNL_LINK_RX_ERRORS            =  4
    RTNL_LINK_TX_ERRORS            =  5
    RTNL_LINK_RX_DROPPED           =  6
    RTNL_LINK_TX_DROPPED           =  7
    RTNL_LINK_RX_COMPRESSED        =  8
    RTNL_LINK_TX_COMPRESSED        =  9
    RTNL_LINK_RX_FIFO_ERR          = 10
    RTNL_LINK_TX_FIFO_ERR          = 11
    RTNL_LINK_RX_LEN_ERR           = 12
    RTNL_LINK_RX_OVER_ERR          = 13
    RTNL_LINK_RX_CRC_ERR           = 14
    RTNL_LINK_RX_FRAME_ERR         = 15
    RTNL_LINK_RX_MISSED_ERR        = 16
    RTNL_LINK_TX_ABORT_ERR         = 17
    RTNL_LINK_TX_CARRIER_ERR       = 18
    RTNL_LINK_TX_HBEAT_ERR         = 19
    RTNL_LINK_TX_WIN_ERR           = 20
    RTNL_LINK_COLLISIONS           = 21
    RTNL_LINK_MULTICAST            = 22
    RTNL_LINK_IP6_INPKTS           = 23
    RTNL_LINK_IP6_INHDRERRORS      = 24
    RTNL_LINK_IP6_INTOOBIGERRORS   = 25
    RTNL_LINK_IP6_INNOROUTES       = 26
    RTNL_LINK_IP6_INADDRERRORS     = 27
    RTNL_LINK_IP6_INUNKNOWNPROTOS  = 28
    RTNL_LINK_IP6_INTRUNCATEDPKTS  = 29
    RTNL_LINK_IP6_INDISCARDS       = 30
    RTNL_LINK_IP6_INDELIVERS       = 31
    RTNL_LINK_IP6_OUTFORWDATAGRAMS = 32
    RTNL_LINK_IP6_OUTPKTS          = 33
    RTNL_LINK_IP6_OUTDISCARDS      = 34
    RTNL_LINK_IP6_OUTNOROUTES      = 35
    RTNL_LINK_IP6_REASMTIMEOUT     = 36
    RTNL_LINK_IP6_REASMREQDS       = 37
    RTNL_LINK_IP6_REASMOKS         = 38
    RTNL_LINK_IP6_REASMFAILS       = 39
    RTNL_LINK_IP6_FRAGOKS          = 40
    RTNL_LINK_IP6_FRAGFAILS        = 41
    RTNL_LINK_IP6_FRAGCREATES      = 42
    RTNL_LINK_IP6_INMCASTPKTS      = 43
    RTNL_LINK_IP6_OUTMCASTPKTS     = 44
    RTNL_LINK_IP6_INBCASTPKTS      = 45
    RTNL_LINK_IP6_OUTBCASTPKTS     = 46
    RTNL_LINK_IP6_INOCTETS         = 47
    RTNL_LINK_IP6_OUTOCTETS        = 48
    RTNL_LINK_IP6_INMCASTOCTETS    = 49
    RTNL_LINK_IP6_OUTMCASTOCTETS   = 50
    RTNL_LINK_IP6_INBCASTOCTETS    = 51
    RTNL_LINK_IP6_OUTBCASTOCTETS   = 52
    RTNL_LINK_IP6_CSUMERRORS       = 53
    RTNL_LINK_IP6_NOECTPKTS        = 54
    RTNL_LINK_IP6_ECT1PKTS         = 55
    RTNL_LINK_IP6_ECT0PKTS         = 56
    RTNL_LINK_IP6_CEPKTS           = 57
  end

  # ---- Neighbour state flags (from netlink/route/neighbour.h) -------------
  enum RtnlNeighState : Int32
    NUD_INCOMPLETE = 0x01
    NUD_REACHABLE  = 0x02
    NUD_STALE      = 0x04
    NUD_DELAY      = 0x08
    NUD_PROBE      = 0x10
    NUD_FAILED     = 0x20
    NUD_NOARP      = 0x40
    NUD_PERMANENT  = 0x80
    NUD_NONE       = 0x00
  end

  # ---- Neighbour flags (from netlink/route/neighbour.h) --------------------
  enum RtnlNeighFlag : Int32
    NTF_USE         = 0x01
    NTF_SELF        = 0x02
    NTF_MASTER      = 0x04
    NTF_PROXY       = 0x08
    NTF_EXT_LEARNED = 0x10
    NTF_OFFLOADED   = 0x20
    NTF_ROUTER      = 0x40
  end

  # src/libnl/route/types.cr (add after other opaque structs)
  @[Extern]
  struct Rtnl_Filter
    _unused : UInt8
  end
end
