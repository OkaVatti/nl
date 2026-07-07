# src/libnl/xfrm/types.cr
#
# XFRM‑specific type aliases, opaque structs, and constants.
# All opaque structs have a dummy `_unused` field to satisfy Crystal.

@[Link("nl-xfrm-3")]
lib LibNLXfrm
  # ---- Opaque handle types ------------------------------------------------

  @[Extern]
  struct XfrmnlSa
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlSp
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlAe
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlLtimeCfg
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlSel
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlUserTmpl
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlMark
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlId
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlLifetimeCur
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlStats
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlUserSecCtx
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlAlgo
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlAlgoAuth
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlAlgoAead
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlEncapTmpl
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlUserOffload
    _unused : UInt8
  end

  @[Extern]
  struct XfrmnlUserpolicyType
    _unused : UInt8
  end

  # ---- XFRM protocol families (from <linux/xfrm.h>) ----------------------

  XFRM_AF_UNSPEC = 0
  XFRM_AF_INET   = 1
  XFRM_AF_INET6  = 2

  # ---- XFRM modes (from <linux/xfrm.h>) ----------------------------------

  XFRM_MODE_TRANSPORT         = 0
  XFRM_MODE_TUNNEL            = 1
  XFRM_MODE_ROUTEOPTIMIZATION = 2
  XFRM_MODE_IN_TRIGGER        = 3
  XFRM_MODE_BEET              = 4

  # ---- XFRM security protocol types (from <linux/xfrm.h>) ----------------

  XFRM_PROTO_ESP     =  50
  XFRM_PROTO_AH      =  51
  XFRM_PROTO_COMP    = 108
  XFRM_PROTO_IPIP    =   4
  XFRM_PROTO_IPV6    =  41
  XFRM_PROTO_ROUTING =  43
  XFRM_PROTO_DSTOPTS =  60

  # ---- XFRM SA flags (from <linux/xfrm.h>) -------------------------------

  XFRM_SA_FLAG_DONT_ENCAP_DSCP = 1

  # ---- XFRM policy directions (from <linux/xfrm.h>) ----------------------

  XFRM_POLICY_IN  = 0
  XFRM_POLICY_OUT = 1
  XFRM_POLICY_FWD = 2
  XFRM_POLICY_MAX = 3

  # ---- XFRM policy actions (from <linux/xfrm.h>) -------------------------

  XFRM_POLICY_ALLOW = 0
  XFRM_POLICY_BLOCK = 1

  # ---- XFRM policy flags (from <linux/xfrm.h>) ---------------------------

  XFRM_POLICY_LOCALOK = 1
  XFRM_POLICY_ICMP    = 2

  # ---- XFRM policy share (from <linux/xfrm.h>) ---------------------------

  XFRM_SHARE_ANY     = 0
  XFRM_SHARE_SESSION = 1
  XFRM_SHARE_USER    = 2
  XFRM_SHARE_UNIQUE  = 3

  # ---- XFRM AE flags (from <linux/xfrm.h>) -------------------------------

  XFRM_AE_UNSPEC =  0
  XFRM_AE_RTHR   =  1
  XFRM_AE_RVAL   =  2
  XFRM_AE_LVAL   =  4
  XFRM_AE_ETHR   =  8
  XFRM_AE_CR     = 16
  XFRM_AE_CE     = 32
  XFRM_AE_CU     = 64

  # ---- XFRM mark (from <linux/xfrm.h>) – this struct has fields, so no dummy needed
  @[Extern]
  struct XfrmMark
    v : UInt32
    m : UInt32
  end

  # ---- XFRM ID (from <linux/xfrm.h>) – this struct has fields, so no dummy needed
  @[Extern]
  struct XfrmId
    daddr : Pointer(LibNL::NL_Addr)
    spi : UInt32
    proto : UInt8
  end

  # ---- XFRM lifetime current (from <linux/xfrm.h>) – this struct has fields
  @[Extern]
  struct XfrmLifetimeCur
    bytes : UInt64
    packets : UInt64
    add_time : UInt64
    use_time : UInt64
  end

  # ---- XFRM statistics (from <linux/xfrm.h>) – this struct has fields
  @[Extern]
  struct XfrmStats
    replay_window : UInt32
    replay : UInt32
    integrity_failed : UInt32
  end
end
