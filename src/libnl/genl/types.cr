# src/libnl/genl/types.cr
#
# Generic Netlink‑specific type aliases and opaque structs.
# All opaque structs have a dummy `_unused` field to satisfy Crystal.

@[Link("nl-genl-3")]
lib LibNLGenl
  # ---- Opaque handle types ------------------------------------------------

  @[Extern]
  struct GenlFamily
    _unused : UInt8
  end

  @[Extern]
  struct GenlOps
    _unused : UInt8
  end

  @[Extern]
  struct GenlCtrl
    _unused : UInt8
  end

  # ---- Generic Netlink constants (from <linux/genetlink.h>) -------------

  GENL_ID_CTRL = 0x10_u32

  # ---- Generic Netlink message header (part of nl_msg) -------------------

  @[Extern]
  struct Genlmsghdr
    cmd : UInt8     # command
    version : UInt8 # version
    reserved : UInt16
  end

  # ---- Netlink family attributes (for ctrl) ------------------------------

  enum GenlCtrlAttr : Int32
    CTRL_ATTR_UNSPEC       = 0
    CTRL_ATTR_FAMILY_ID    = 1
    CTRL_ATTR_FAMILY_NAME  = 2
    CTRL_ATTR_VERSION      = 3
    CTRL_ATTR_HDRSIZE      = 4
    CTRL_ATTR_MAXATTR      = 5
    CTRL_ATTR_OPS          = 6
    CTRL_ATTR_MCAST_GROUPS = 7
  end

  enum GenlCtrlCmd : Int32
    CTRL_CMD_UNSPEC       = 0
    CTRL_CMD_NEWFAMILY    = 1
    CTRL_CMD_DELFAMILY    = 2
    CTRL_CMD_GETFAMILY    = 3
    CTRL_CMD_NEWOPS       = 4
    CTRL_CMD_DELOPS       = 5
    CTRL_CMD_GETOPS       = 6
    CTRL_CMD_NEWMCAST_GRP = 7
    CTRL_CMD_DELMCAST_GRP = 8
    CTRL_CMD_GETMCAST_GRP = 9
  end

  # ---- Multicast group attribute (for ctrl) ------------------------------

  enum GenlCtrlMcastGrpAttr : Int32
    CTRL_ATTR_MCAST_GRP_UNSPEC = 0
    CTRL_ATTR_MCAST_GRP_NAME   = 1
    CTRL_ATTR_MCAST_GRP_ID     = 2
  end

  # ---- Ops attribute (for ctrl) -----------------------------------------

  enum GenlCtrlOpsAttr : Int32
    CTRL_ATTR_OP_UNSPEC = 0
    CTRL_ATTR_OP_ID     = 1
    CTRL_ATTR_OP_FLAGS  = 2
  end

  # ---- Operation flags ---------------------------------------------------

  GENL_OP_FLAG_F          = 1 # requires CAP_NET_ADMIN
  GENL_OP_FLAG_DO         = 2 # supports do/dump
  GENL_OP_FLAG_HAS_POLICY = 4

  # ---- genl_info struct (from netlink/genl/mngt.h) ------------------------
  @[Extern]
  struct GenlInfo
    _unused : UInt8
  end
end
