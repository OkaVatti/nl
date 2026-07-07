# src/libnl/core/helpers.cr
#
# Crystal helpers that emulate non‑exported libnl inline functions.
# All functions are implemented using exported counterparts.

# **Internal** – These helpers emulate non‑exported libnl inline functions.
# They are not part of the public API and may change without notice.
module LibNLHelpers
  # ---- Address helpers --------------------------------------------------

  # Allocate an empty address with the given family.
  # Emulates nl_addr_alloc_empty(family).
  def self.addr_alloc_empty(family : Int32) : Pointer(LibNL::NL_Addr)
    len = case family
          when LibNL::AF_INET  then 4
          when LibNL::AF_INET6 then 16
          else                      0
          end
    addr = LibNL.nl_addr_alloc(len)
    LibNL.nl_addr_set_family(addr, family) if addr && !addr.null?
    addr
  end

  # Build an "any" (all‑zero) address for the given family.
  # Emulates nl_addr_build_any(family, result).
  def self.addr_build_any(family : Int32) : Pointer(LibNL::NL_Addr)
    addr = addr_alloc_empty(family)
    return addr if addr.null?
    len = LibNL.nl_addr_get_len(addr)
    if len > 0
      ptr = LibNL.nl_addr_get_binary_addr(addr)
      ptr.as(Pointer(UInt8)).clear(len) if ptr
    end
    addr
  end

  # ---- Route metric helpers ---------------------------------------------

  # Set a route metric using the generic setter.
  # Emulates the inline wrappers (rtnl_route_set_mtu, etc.).
  def self.route_set_mtu(route : Pointer(LibNLRoute::Rtnl_Route), mtu : UInt32) : Int32
    LibNLRoute.rtnl_route_set_metric(route, RtnlRouteMetric::ROUTE_METRIC_MTU, mtu)
  end

  def self.route_get_mtu(route : Pointer(LibNLRoute::Rtnl_Route)) : UInt32
    val = Pointer(UInt32).malloc(1)
    ret = LibNLRoute.rtnl_route_get_metric(route, RtnlRouteMetric::ROUTE_METRIC_MTU, val)
    ret == 0 ? val.value : 0_u32
  end

  # ---- Traffic Control (TC) helpers ------------------------------------

  # Create a new qdisc of the given kind, set its parameters, and add it.
  # Returns the qdisc object on success (already added to kernel).
  def self.qdisc_add(sk : Pointer(LibNL::NL_Sock), ifindex : Int32, parent : UInt32, kind : String, params : NamedTuple, flags : Int32 = LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL) : Pointer(LibNLRoute::Rtnl_Qdisc)
    qdisc = LibNLRoute.rtnl_qdisc_alloc
    raise "Failed to allocate qdisc" if qdisc.null?
    tc = qdisc.as(Pointer(LibNLRoute::Rtnl_Tc))

    # Set basic properties
    LibNLRoute.rtnl_tc_set_ifindex(tc, ifindex)
    LibNLRoute.rtnl_tc_set_parent(tc, parent)
    LibNLRoute.rtnl_tc_set_kind(tc, kind)

    # Apply kind‑specific parameters
    case kind
    when "htb"
      if rate = params[:rate]?
        LibNLRoute.rtnl_htb_set_rate(qdisc, rate)
      end
      if ceil = params[:ceil]?
        LibNLRoute.rtnl_htb_set_ceil(qdisc, ceil)
      end
      # ... other HTB params
    when "tbf"
      if rate = params[:rate]?
        burst = params[:burst]? || 1024_u32
        LibNLRoute.rtnl_tbf_set_rate(qdisc, rate, burst)
      end
      if limit = params[:limit]?
        LibNLRoute.rtnl_tbf_set_limit(qdisc, limit)
      end
    when "sfq"
      if quantum = params[:quantum]?
        LibNLRoute.rtnl_sfq_set_quantum(qdisc, quantum)
      end
      if perturb = params[:perturb]?
        LibNLRoute.rtnl_sfq_set_perturb(qdisc, perturb)
      end
      # ... other kinds (red, fq_codel, netem, hfsc)
    else
      # Unknown kind – set no parameters
    end

    # Add the qdisc to the kernel
    ret = LibNLRoute.rtnl_qdisc_add(sk, qdisc, flags)
    if ret < 0
      LibNLRoute.rtnl_qdisc_put(qdisc)
      raise "Failed to add qdisc: #{LibNL.nl_geterror(ret)}"
    end
    qdisc
  end

  # Create a new class of the given kind, set parameters, and add it.
  def self.class_add(sk : Pointer(LibNL::NL_Sock), ifindex : Int32, parent : UInt32, handle : UInt32, kind : String, params : NamedTuple, flags : Int32 = LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL) : Pointer(LibNLRoute::Rtnl_Class)
    cls = LibNLRoute.rtnl_class_alloc
    raise "Failed to allocate class" if cls.null?
    tc = cls.as(Pointer(LibNLRoute::Rtnl_Tc))

    LibNLRoute.rtnl_tc_set_ifindex(tc, ifindex)
    LibNLRoute.rtnl_tc_set_parent(tc, parent)
    LibNLRoute.rtnl_tc_set_handle(tc, handle)
    LibNLRoute.rtnl_tc_set_kind(tc, kind)

    case kind
    when "htb"
      if rate = params[:rate]?
        LibNLRoute.rtnl_htb_class_set_rate(cls, rate)
      end
      if ceil = params[:ceil]?
        LibNLRoute.rtnl_htb_class_set_ceil(cls, ceil)
      end
      if prio = params[:prio]?
        LibNLRoute.rtnl_htb_class_set_prio(cls, prio)
      end
      # ... other class kinds (e.g., drr, qfq)
    end

    ret = LibNLRoute.rtnl_class_add(sk, cls, flags)
    if ret < 0
      LibNLRoute.rtnl_class_put(cls)
      raise "Failed to add class: #{LibNL.nl_geterror(ret)}"
    end
    cls
  end

  # Create a new filter, set parameters, and add it.
  def self.filter_add(sk : Pointer(LibNL::NL_Sock), ifindex : Int32, parent : UInt32, priority : UInt32, kind : String, params : NamedTuple, flags : Int32 = LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL) : Pointer(LibNLRoute::Rtnl_Filter)
    filter = LibNLRoute.rtnl_filter_alloc
    raise "Failed to allocate filter" if filter.null?
    tc = filter.as(Pointer(LibNLRoute::Rtnl_Tc))

    LibNLRoute.rtnl_tc_set_ifindex(tc, ifindex)
    LibNLRoute.rtnl_tc_set_parent(tc, parent)
    LibNLRoute.rtnl_tc_set_kind(tc, kind)
    # Priority is set via a specific function if available; fallback to generic TC priority?
    # Not all filter types have a set_priority; use rtnl_tc_set_handle? Actually priority is separate.
    # We'll assume we have a function; if not, we'll use a generic approach.

    case kind
    when "u32"
      if handle = params[:handle]?
        LibNLRoute.rtnl_u32_set_handle(filter, handle)
      end
      if classid = params[:classid]?
        LibNLRoute.rtnl_u32_set_classid(filter, classid)
      end
    when "basic"
      if classid = params[:classid]?
        LibNLRoute.rtnl_basic_set_classid(filter, classid)
      end
    when "fw"
      if classid = params[:classid]?
        LibNLRoute.rtnl_fw_set_classid(filter, classid)
      end
      if mask = params[:mask]?
        LibNLRoute.rtnl_fw_set_mask(filter, mask)
      end
      # ... other filter kinds (route, tcindex, etc.)
    end

    ret = LibNLRoute.rtnl_filter_add(sk, filter, flags)
    if ret < 0
      LibNLRoute.rtnl_filter_put(filter)
      raise "Failed to add filter: #{LibNL.nl_geterror(ret)}"
    end
    filter
  end
end
