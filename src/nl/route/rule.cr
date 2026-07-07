# src/nl/route/rule.cr
#
# High‑level wrapper for routing rules (policy‑based routing).

module Nl::Route
  ##
  # A routing rule.
  class Rule
    @ptr : Pointer(LibNLRoute::Rtnl_Rule)
    @owned : Bool

    # Allocates a new rule object.
    def initialize
      @ptr = LibNLRoute.rtnl_rule_alloc
      raise Error.from_ret(-1) if @ptr.null?
      @owned = true
    end

    # Wraps an existing rule pointer.
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Rule), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the rule if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLRoute.rtnl_rule_put(@ptr)
        @ptr = Pointer(LibNLRoute::Rtnl_Rule).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Allocate a rule cache -------------------------------------------
    #
    # Returns a cache containing all routing rules.
    def self.cache(sk : Socket) : Cache
      cache_ptr = Pointer(LibNL::NL_Cache).null
      ret = LibNLRoute.rtnl_rule_alloc_cache(sk.to_unsafe, pointerof(cache_ptr))
      raise Error.from_ret(ret) if ret < 0
      Cache.new(cache_ptr)
    end

    # --- Basic attributes (getters/setters) -----------------------------
    #
    # Sets the address family.
    def family=(fam : Int32) : Nil
      LibNLRoute.rtnl_rule_set_family(@ptr, fam)
    end

    # Returns the address family.
    def family : Int32
      LibNLRoute.rtnl_rule_get_family(@ptr)
    end

    # Sets the routing table ID.
    def table=(tbl : UInt32) : Nil
      LibNLRoute.rtnl_rule_set_table(@ptr, tbl)
    end

    # Returns the routing table ID.
    def table : UInt32
      LibNLRoute.rtnl_rule_get_table(@ptr)
    end

    # Sets the priority (order) of the rule.
    def priority=(prio : UInt32) : Nil
      LibNLRoute.rtnl_rule_set_priority(@ptr, prio)
    end

    # Returns the priority.
    def priority : UInt32
      LibNLRoute.rtnl_rule_get_priority(@ptr)
    end

    # Sets the TOS (Type of Service).
    def tos=(tos : UInt8) : Nil
      LibNLRoute.rtnl_rule_set_tos(@ptr, tos)
    end

    # Returns the TOS.
    def tos : UInt8
      LibNLRoute.rtnl_rule_get_tos(@ptr)
    end

    # Sets the protocol (e.g., `RTPROT_STATIC`, `RTPROT_KERNEL`).
    def protocol=(proto : UInt8) : Nil
      LibNLRoute.rtnl_rule_set_protocol(@ptr, proto)
    end

    # Returns the protocol.
    def protocol : UInt8
      LibNLRoute.rtnl_rule_get_protocol(@ptr)
    end

    # Sets the action (e.g., `RtnlRuleAction::FR_ACT_TO_TBL`).
    def action=(act : RtnlRuleAction) : Nil
      LibNLRoute.rtnl_rule_set_action(@ptr, act)
    end

    # Returns the action.
    def action : RtnlRuleAction
      LibNLRoute.rtnl_rule_get_action(@ptr)
    end

    # --- Addresses -------------------------------------------------------
    #
    # Sets the destination address.
    def dst=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_rule_set_dst(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the destination address.
    def dst : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_rule_get_dst(@ptr)
    end

    # Sets the source address.
    def src=(addr : Pointer(LibNL::NL_Addr)) : Nil
      ret = LibNLRoute.rtnl_rule_set_src(@ptr, addr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the source address.
    def src : Pointer(LibNL::NL_Addr)
      LibNLRoute.rtnl_rule_get_src(@ptr)
    end

    # --- Interfaces ------------------------------------------------------
    #
    # Sets the incoming interface name.
    def iif=(name : String) : Nil
      ret = LibNLRoute.rtnl_rule_set_iif(@ptr, name.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the incoming interface name.
    def iif : String
      ptr = LibNLRoute.rtnl_rule_get_iif(@ptr)
      String.new(ptr)
    end

    # Sets the outgoing interface name.
    def oif=(name : String) : Nil
      ret = LibNLRoute.rtnl_rule_set_oif(@ptr, name.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the outgoing interface name.
    def oif : String
      ptr = LibNLRoute.rtnl_rule_get_oif(@ptr)
      String.new(ptr)
    end

    # --- Firewall mark ---------------------------------------------------
    #
    # Sets the firewall mark.
    def fwmark=(mark : UInt32) : Nil
      LibNLRoute.rtnl_rule_set_fwmark(@ptr, mark)
    end

    # Returns the firewall mark.
    def fwmark : UInt32
      LibNLRoute.rtnl_rule_get_fwmark(@ptr)
    end

    # Sets the firewall mark mask.
    def fwmask=(mask : UInt32) : Nil
      LibNLRoute.rtnl_rule_set_fwmask(@ptr, mask)
    end

    # Returns the firewall mark mask.
    def fwmask : UInt32
      LibNLRoute.rtnl_rule_get_fwmask(@ptr)
    end

    # --- Goto ------------------------------------------------------------
    #
    # Sets the target rule index for `FR_ACT_GOTO`.
    def goto=(target : UInt32) : Nil
      LibNLRoute.rtnl_rule_set_goto(@ptr, target)
    end

    # Returns the target rule index.
    def goto : UInt32
      LibNLRoute.rtnl_rule_get_goto(@ptr)
    end

    # --- Add / Delete ----------------------------------------------------
    #
    # Adds the rule to the kernel.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_rule_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the rule from the kernel.
    def delete(sk : Socket) : Nil
      ret = LibNLRoute.rtnl_rule_delete(sk.to_unsafe, @ptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer -------------------------------------------------------
    def finalize
      free
    end
  end
end
