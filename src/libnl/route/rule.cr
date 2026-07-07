# src/libnl/route/rule.cr
#
# Routing rules (policy-based routing) – allocation, cache, addition/deletion,
# and attribute getters/setters.

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Allocation / Free / Reference counting ---------------------------

  fun rtnl_rule_alloc = rtnl_rule_alloc : Pointer(Rtnl_Rule)
  fun rtnl_rule_put = rtnl_rule_put(rule : Pointer(Rtnl_Rule)) : Void
  fun rtnl_rule_get = rtnl_rule_get(rule : Pointer(Rtnl_Rule)) : Void
  fun rtnl_rule_alloc_cache = rtnl_rule_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32

  # ---- Rule addition / deletion ----------------------------------------

  fun rtnl_rule_add = rtnl_rule_add(sk : Pointer(LibNL::NL_Sock), rule : Pointer(Rtnl_Rule), flags : Int32) : Int32
  fun rtnl_rule_build_add_request = rtnl_rule_build_add_request(
    rule : Pointer(Rtnl_Rule),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_rule_delete = rtnl_rule_delete(sk : Pointer(LibNL::NL_Sock), rule : Pointer(Rtnl_Rule)) : Int32
  fun rtnl_rule_build_delete_request = rtnl_rule_build_delete_request(
    rule : Pointer(Rtnl_Rule),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Basic attributes (getters / setters) -----------------------------

  fun rtnl_rule_set_family = rtnl_rule_set_family(rule : Pointer(Rtnl_Rule), family : Int32) : Void
  fun rtnl_rule_get_family = rtnl_rule_get_family(rule : Pointer(Rtnl_Rule)) : Int32

  fun rtnl_rule_set_table = rtnl_rule_set_table(rule : Pointer(Rtnl_Rule), table : UInt32) : Void
  fun rtnl_rule_get_table = rtnl_rule_get_table(rule : Pointer(Rtnl_Rule)) : UInt32

  fun rtnl_rule_set_priority = rtnl_rule_set_priority(rule : Pointer(Rtnl_Rule), priority : UInt32) : Void
  fun rtnl_rule_get_priority = rtnl_rule_get_priority(rule : Pointer(Rtnl_Rule)) : UInt32

  fun rtnl_rule_set_tos = rtnl_rule_set_tos(rule : Pointer(Rtnl_Rule), tos : UInt8) : Void
  fun rtnl_rule_get_tos = rtnl_rule_get_tos(rule : Pointer(Rtnl_Rule)) : UInt8

  fun rtnl_rule_set_protocol = rtnl_rule_set_protocol(rule : Pointer(Rtnl_Rule), protocol : UInt8) : Void
  fun rtnl_rule_get_protocol = rtnl_rule_get_protocol(rule : Pointer(Rtnl_Rule)) : UInt8

  fun rtnl_rule_set_action = rtnl_rule_set_action(rule : Pointer(Rtnl_Rule), action : RtnlRuleAction) : Void
  fun rtnl_rule_get_action = rtnl_rule_get_action(rule : Pointer(Rtnl_Rule)) : RtnlRuleAction

  # ---- Addresses --------------------------------------------------------

  fun rtnl_rule_set_dst = rtnl_rule_set_dst(rule : Pointer(Rtnl_Rule), dst : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_rule_get_dst = rtnl_rule_get_dst(rule : Pointer(Rtnl_Rule)) : Pointer(LibNL::NL_Addr)

  fun rtnl_rule_set_src = rtnl_rule_set_src(rule : Pointer(Rtnl_Rule), src : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_rule_get_src = rtnl_rule_get_src(rule : Pointer(Rtnl_Rule)) : Pointer(LibNL::NL_Addr)

  # ---- Interfaces -------------------------------------------------------

  fun rtnl_rule_set_iif = rtnl_rule_set_iif(rule : Pointer(Rtnl_Rule), iif : LibC::Char*) : Int32
  fun rtnl_rule_get_iif = rtnl_rule_get_iif(rule : Pointer(Rtnl_Rule)) : LibC::Char*

  fun rtnl_rule_set_oif = rtnl_rule_set_oif(rule : Pointer(Rtnl_Rule), oif : LibC::Char*) : Int32
  fun rtnl_rule_get_oif = rtnl_rule_get_oif(rule : Pointer(Rtnl_Rule)) : LibC::Char*

  # ---- Firewall mark ----------------------------------------------------

  fun rtnl_rule_set_fwmark = rtnl_rule_set_fwmark(rule : Pointer(Rtnl_Rule), mark : UInt32) : Void
  fun rtnl_rule_get_fwmark = rtnl_rule_get_fwmark(rule : Pointer(Rtnl_Rule)) : UInt32

  fun rtnl_rule_set_fwmask = rtnl_rule_set_fwmask(rule : Pointer(Rtnl_Rule), mask : UInt32) : Void
  fun rtnl_rule_get_fwmask = rtnl_rule_get_fwmask(rule : Pointer(Rtnl_Rule)) : UInt32

  # ---- Goto -------------------------------------------------------------

  fun rtnl_rule_set_goto = rtnl_rule_set_goto(rule : Pointer(Rtnl_Rule), target : UInt32) : Void
  fun rtnl_rule_get_goto = rtnl_rule_get_goto(rule : Pointer(Rtnl_Rule)) : UInt32
end

# ---- Rule action enum (from <netlink/route/rule.h>) ---------------------

enum RtnlRuleAction : Int32
  FR_ACT_TO_TBL      = 0 # Route to table
  FR_ACT_GOTO        = 1 # Goto rule
  FR_ACT_NOP         = 2 # No operation
  FR_ACT_RES3        = 3 # Reserved
  FR_ACT_RES4        = 4 # Reserved
  FR_ACT_BLACKHOLE   = 5 # Drop without notice
  FR_ACT_UNREACHABLE = 6 # Drop with ICMP unreachable
  FR_ACT_PROHIBIT    = 7 # Drop with ICMP prohibited
end
