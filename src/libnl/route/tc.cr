# src/libnl/route/tc.cr
#
# Traffic Control (TC) – complete bindings for qdiscs, classes, filters, and actions.
# Includes base operations, rate table helpers, and all common qdisc/filter parameters.

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Base TC object operations ----------------------------------------
  # (from <netlink/route/tc.h>)

  fun rtnl_tc_get_ifindex = rtnl_tc_get_ifindex(tc : Pointer(Rtnl_Tc)) : Int32
  fun rtnl_tc_set_ifindex = rtnl_tc_set_ifindex(tc : Pointer(Rtnl_Tc), ifindex : Int32) : Void
  fun rtnl_tc_get_handle = rtnl_tc_get_handle(tc : Pointer(Rtnl_Tc)) : UInt32
  fun rtnl_tc_set_handle = rtnl_tc_set_handle(tc : Pointer(Rtnl_Tc), handle : UInt32) : Void
  fun rtnl_tc_get_parent = rtnl_tc_get_parent(tc : Pointer(Rtnl_Tc)) : UInt32
  fun rtnl_tc_set_parent = rtnl_tc_set_parent(tc : Pointer(Rtnl_Tc), parent : UInt32) : Void
  fun rtnl_tc_get_kind = rtnl_tc_get_kind(tc : Pointer(Rtnl_Tc)) : LibC::Char*
  fun rtnl_tc_set_kind = rtnl_tc_set_kind(tc : Pointer(Rtnl_Tc), kind : LibC::Char*) : Int32

  fun rtnl_tc_get_link = rtnl_tc_get_link(tc : Pointer(Rtnl_Tc)) : Pointer(Rtnl_Link)
  fun rtnl_tc_set_link = rtnl_tc_set_link(tc : Pointer(Rtnl_Tc), link : Pointer(Rtnl_Link)) : Void

  fun rtnl_tc_get_mtu = rtnl_tc_get_mtu(tc : Pointer(Rtnl_Tc)) : UInt32
  fun rtnl_tc_set_mtu = rtnl_tc_set_mtu(tc : Pointer(Rtnl_Tc), mtu : UInt32) : Void
  fun rtnl_tc_get_mpu = rtnl_tc_get_mpu(tc : Pointer(Rtnl_Tc)) : UInt32
  fun rtnl_tc_set_mpu = rtnl_tc_set_mpu(tc : Pointer(Rtnl_Tc), mpu : UInt32) : Void
  fun rtnl_tc_get_overhead = rtnl_tc_get_overhead(tc : Pointer(Rtnl_Tc)) : UInt32
  fun rtnl_tc_set_overhead = rtnl_tc_set_overhead(tc : Pointer(Rtnl_Tc), overhead : UInt32) : Void
  fun rtnl_tc_get_link_share = rtnl_tc_get_link_share(tc : Pointer(Rtnl_Tc)) : UInt32
  fun rtnl_tc_set_link_share = rtnl_tc_set_link_share(tc : Pointer(Rtnl_Tc), link_share : UInt32) : Void

  # ---- Statistics -------------------------------------------------------
  fun rtnl_tc_get_stat = rtnl_tc_get_stat(tc : Pointer(Rtnl_Tc), id : RtnlTcStatsId) : UInt64

  # ---- Rate table helpers -----------------------------------------------
  fun rtnl_tc_calc_txtime = rtnl_tc_calc_txtime(size : Int32, rate : Int32) : Int32
  fun rtnl_tc_calc_bufsize = rtnl_tc_calc_bufsize(rate : Int32, latency : Int32) : Int32
  fun rtnl_tc_calc_cell_log = rtnl_tc_calc_cell_log(size : Int32) : Int32
  fun rtnl_tc_build_rate_table = rtnl_tc_build_rate_table(
    table : UInt32*,
    cell_log : UInt8,
    mpu : UInt8,
    rate : Int32,
    size : Int32,
  ) : Int32

  # ---- Qdisc operations ------------------------------------------------
  # (from <netlink/route/qdisc.h>)

  fun rtnl_qdisc_alloc = rtnl_qdisc_alloc : Pointer(Rtnl_Qdisc)
  fun rtnl_qdisc_put = rtnl_qdisc_put(qdisc : Pointer(Rtnl_Qdisc)) : Void
  fun rtnl_qdisc_add = rtnl_qdisc_add(sk : Pointer(LibNL::NL_Sock), qdisc : Pointer(Rtnl_Qdisc), flags : Int32) : Int32
  fun rtnl_qdisc_delete = rtnl_qdisc_delete(sk : Pointer(LibNL::NL_Sock), qdisc : Pointer(Rtnl_Qdisc)) : Int32
  fun rtnl_qdisc_build_add_request = rtnl_qdisc_build_add_request(
    qdisc : Pointer(Rtnl_Qdisc),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_qdisc_build_delete_request = rtnl_qdisc_build_delete_request(
    qdisc : Pointer(Rtnl_Qdisc),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Class operations ------------------------------------------------
  # (from <netlink/route/class.h>)

  fun rtnl_class_alloc = rtnl_class_alloc : Pointer(Rtnl_Class)
  fun rtnl_class_put = rtnl_class_put(class : Pointer(Rtnl_Class)) : Void
  fun rtnl_class_add = rtnl_class_add(sk : Pointer(LibNL::NL_Sock), class : Pointer(Rtnl_Class), flags : Int32) : Int32
  fun rtnl_class_delete = rtnl_class_delete(sk : Pointer(LibNL::NL_Sock), class : Pointer(Rtnl_Class)) : Int32
  fun rtnl_class_build_add_request = rtnl_class_build_add_request(
    class : Pointer(Rtnl_Class),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_class_build_delete_request = rtnl_class_build_delete_request(
    class : Pointer(Rtnl_Class),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Filter operations ------------------------------------------------
  # (from <netlink/route/cls.h>) – add if not already present.

  # Note: rtnl_filter_alloc, put, add, delete, build requests are also available.
  # If they were missing, we add them now.
  fun rtnl_filter_alloc = rtnl_filter_alloc : Pointer(Rtnl_Filter)
  fun rtnl_filter_put = rtnl_filter_put(filter : Pointer(Rtnl_Filter)) : Void
  fun rtnl_filter_get = rtnl_filter_get(filter : Pointer(Rtnl_Filter)) : Void

  fun rtnl_filter_add = rtnl_filter_add(
    sk : Pointer(LibNL::NL_Sock),
    filter : Pointer(Rtnl_Filter),
    flags : Int32,
  ) : Int32
  fun rtnl_filter_delete = rtnl_filter_delete(
    sk : Pointer(LibNL::NL_Sock),
    filter : Pointer(Rtnl_Filter),
  ) : Int32
  fun rtnl_filter_build_add_request = rtnl_filter_build_add_request(
    filter : Pointer(Rtnl_Filter),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_filter_build_delete_request = rtnl_filter_build_delete_request(
    filter : Pointer(Rtnl_Filter),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Action operations ------------------------------------------------
  # (from <netlink/route/act.h>)

  fun rtnl_act_alloc = rtnl_act_alloc : Pointer(Rtnl_Act)
  fun rtnl_act_put = rtnl_act_put(act : Pointer(Rtnl_Act)) : Void
  fun rtnl_act_get = rtnl_act_get(act : Pointer(Rtnl_Act)) : Void
  fun rtnl_act_add = rtnl_act_add(sk : Pointer(LibNL::NL_Sock), act : Pointer(Rtnl_Act), flags : Int32) : Int32
  fun rtnl_act_delete = rtnl_act_delete(sk : Pointer(LibNL::NL_Sock), act : Pointer(Rtnl_Act), flags : Int32) : Int32
  fun rtnl_act_change = rtnl_act_change(sk : Pointer(LibNL::NL_Sock), act : Pointer(Rtnl_Act), flags : Int32) : Int32
  fun rtnl_act_build_add_request = rtnl_act_build_add_request(
    act : Pointer(Rtnl_Act),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_act_build_delete_request = rtnl_act_build_delete_request(
    act : Pointer(Rtnl_Act),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_act_build_change_request = rtnl_act_build_change_request(
    act : Pointer(Rtnl_Act),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_act_append = rtnl_act_append(list : Pointer(Rtnl_Act), act : Pointer(Rtnl_Act)) : Void
  fun rtnl_act_remove = rtnl_act_remove(list : Pointer(Rtnl_Act), act : Pointer(Rtnl_Act)) : Void
  fun rtnl_act_put_all = rtnl_act_put_all(list : Pointer(Rtnl_Act)) : Void

  # ======================================================================
  # Qdisc/Class/Filter Parameter Setters (from various headers)
  # ======================================================================

  # ---- HTB (Hierarchical Token Bucket) - Qdisc -------------------------
  # (from <netlink/route/qdisc/htb.h>)

  fun rtnl_htb_set_rate = rtnl_htb_set_rate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32) : Int32
  fun rtnl_htb_get_rate = rtnl_htb_get_rate(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_htb_set_ceil = rtnl_htb_set_ceil(qdisc : Pointer(Rtnl_Qdisc), ceil : UInt32) : Int32
  fun rtnl_htb_get_ceil = rtnl_htb_get_ceil(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_htb_set_prio = rtnl_htb_set_prio(qdisc : Pointer(Rtnl_Qdisc), prio : UInt8) : Int32
  fun rtnl_htb_get_prio = rtnl_htb_get_prio(qdisc : Pointer(Rtnl_Qdisc)) : UInt8

  fun rtnl_htb_set_mtu = rtnl_htb_set_mtu(qdisc : Pointer(Rtnl_Qdisc), mtu : UInt32) : Int32
  fun rtnl_htb_get_mtu = rtnl_htb_get_mtu(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_htb_set_r2q = rtnl_htb_set_r2q(qdisc : Pointer(Rtnl_Qdisc), r2q : UInt16) : Int32
  fun rtnl_htb_get_r2q = rtnl_htb_get_r2q(qdisc : Pointer(Rtnl_Qdisc)) : UInt16

  fun rtnl_htb_set_direct_qlen = rtnl_htb_set_direct_qlen(qdisc : Pointer(Rtnl_Qdisc), qlen : UInt32) : Int32
  fun rtnl_htb_get_direct_qlen = rtnl_htb_get_direct_qlen(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  # ---- HTB - Class ------------------------------------------------------
  fun rtnl_htb_class_set_rate = rtnl_htb_class_set_rate(class : Pointer(Rtnl_Class), rate : UInt32) : Int32
  fun rtnl_htb_class_get_rate = rtnl_htb_class_get_rate(class : Pointer(Rtnl_Class)) : UInt32

  fun rtnl_htb_class_set_ceil = rtnl_htb_class_set_ceil(class : Pointer(Rtnl_Class), ceil : UInt32) : Int32
  fun rtnl_htb_class_get_ceil = rtnl_htb_class_get_ceil(class : Pointer(Rtnl_Class)) : UInt32

  fun rtnl_htb_class_set_prio = rtnl_htb_class_set_prio(class : Pointer(Rtnl_Class), prio : UInt8) : Int32
  fun rtnl_htb_class_get_prio = rtnl_htb_class_get_prio(class : Pointer(Rtnl_Class)) : UInt8

  fun rtnl_htb_class_set_level = rtnl_htb_class_set_level(class : Pointer(Rtnl_Class), level : UInt8) : Int32
  fun rtnl_htb_class_get_level = rtnl_htb_class_get_level(class : Pointer(Rtnl_Class)) : UInt8

  fun rtnl_htb_class_set_buffer = rtnl_htb_class_set_buffer(class : Pointer(Rtnl_Class), buffer : UInt32) : Int32
  fun rtnl_htb_class_get_buffer = rtnl_htb_class_get_buffer(class : Pointer(Rtnl_Class)) : UInt32

  fun rtnl_htb_class_set_cbuffer = rtnl_htb_class_set_cbuffer(class : Pointer(Rtnl_Class), cbuffer : UInt32) : Int32
  fun rtnl_htb_class_get_cbuffer = rtnl_htb_class_get_cbuffer(class : Pointer(Rtnl_Class)) : UInt32

  # ---- TBF (Token Bucket Filter) ----------------------------------------
  fun rtnl_tbf_set_rate = rtnl_tbf_set_rate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32, burst : UInt32) : Int32
  fun rtnl_tbf_get_rate = rtnl_tbf_get_rate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32*) : Int32
  fun rtnl_tbf_get_burst = rtnl_tbf_get_burst(qdisc : Pointer(Rtnl_Qdisc), burst : UInt32*) : Int32

  fun rtnl_tbf_set_peakrate = rtnl_tbf_set_peakrate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32, mtu : UInt32) : Int32
  fun rtnl_tbf_get_peakrate = rtnl_tbf_get_peakrate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32*) : Int32
  fun rtnl_tbf_get_peakmtu = rtnl_tbf_get_peakmtu(qdisc : Pointer(Rtnl_Qdisc), mtu : UInt32*) : Int32

  fun rtnl_tbf_set_limit = rtnl_tbf_set_limit(qdisc : Pointer(Rtnl_Qdisc), limit : UInt32) : Int32
  fun rtnl_tbf_get_limit = rtnl_tbf_get_limit(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  # ---- SFQ (Stochastic Fair Queuing) ------------------------------------
  fun rtnl_sfq_set_quantum = rtnl_sfq_set_quantum(qdisc : Pointer(Rtnl_Qdisc), quantum : UInt32) : Int32
  fun rtnl_sfq_get_quantum = rtnl_sfq_get_quantum(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_sfq_set_perturb = rtnl_sfq_set_perturb(qdisc : Pointer(Rtnl_Qdisc), perturb : UInt32) : Int32
  fun rtnl_sfq_get_perturb = rtnl_sfq_get_perturb(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_sfq_set_limit = rtnl_sfq_set_limit(qdisc : Pointer(Rtnl_Qdisc), limit : UInt32) : Int32
  fun rtnl_sfq_get_limit = rtnl_sfq_get_limit(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_sfq_set_flows = rtnl_sfq_set_flows(qdisc : Pointer(Rtnl_Qdisc), flows : UInt32) : Int32
  fun rtnl_sfq_get_flows = rtnl_sfq_get_flows(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_sfq_set_divisor = rtnl_sfq_set_divisor(qdisc : Pointer(Rtnl_Qdisc), divisor : UInt32) : Int32
  fun rtnl_sfq_get_divisor = rtnl_sfq_get_divisor(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  # ---- RED (Random Early Detection) -------------------------------------
  fun rtnl_red_set_limit = rtnl_red_set_limit(qdisc : Pointer(Rtnl_Qdisc), limit : UInt32) : Int32
  fun rtnl_red_get_limit = rtnl_red_get_limit(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_red_set_min = rtnl_red_set_min(qdisc : Pointer(Rtnl_Qdisc), min : UInt32) : Int32
  fun rtnl_red_get_min = rtnl_red_get_min(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_red_set_max = rtnl_red_set_max(qdisc : Pointer(Rtnl_Qdisc), max : UInt32) : Int32
  fun rtnl_red_get_max = rtnl_red_get_max(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_red_set_prob = rtnl_red_set_prob(qdisc : Pointer(Rtnl_Qdisc), prob : UInt32) : Int32
  fun rtnl_red_get_prob = rtnl_red_get_prob(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_red_set_avpkt = rtnl_red_set_avpkt(qdisc : Pointer(Rtnl_Qdisc), avpkt : UInt32) : Int32
  fun rtnl_red_get_avpkt = rtnl_red_get_avpkt(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_red_set_flags = rtnl_red_set_flags(qdisc : Pointer(Rtnl_Qdisc), flags : UInt32) : Int32
  fun rtnl_red_get_flags = rtnl_red_get_flags(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  # ---- HFSC (Hierarchical Fair Service Curve) ---------------------------
  # (from <netlink/route/qdisc/hfsc.h>)

  fun rtnl_hfsc_set_rt_sc = rtnl_hfsc_set_rt_sc(
    qdisc : Pointer(Rtnl_Qdisc),
    m1 : UInt32,
    d : UInt32,
    m2 : UInt32,
  ) : Int32
  fun rtnl_hfsc_get_rt_sc = rtnl_hfsc_get_rt_sc(
    qdisc : Pointer(Rtnl_Qdisc),
    m1 : UInt32*,
    d : UInt32*,
    m2 : UInt32*,
  ) : Int32

  fun rtnl_hfsc_set_ls_sc = rtnl_hfsc_set_ls_sc(
    qdisc : Pointer(Rtnl_Qdisc),
    m1 : UInt32,
    d : UInt32,
    m2 : UInt32,
  ) : Int32
  fun rtnl_hfsc_get_ls_sc = rtnl_hfsc_get_ls_sc(
    qdisc : Pointer(Rtnl_Qdisc),
    m1 : UInt32*,
    d : UInt32*,
    m2 : UInt32*,
  ) : Int32

  fun rtnl_hfsc_set_sc = rtnl_hfsc_set_sc(
    qdisc : Pointer(Rtnl_Qdisc),
    type : UInt8, # HFSC_* constants
    m1 : UInt32,
    d : UInt32,
    m2 : UInt32,
  ) : Int32
  fun rtnl_hfsc_get_sc = rtnl_hfsc_get_sc(
    qdisc : Pointer(Rtnl_Qdisc),
    type : UInt8,
    m1 : UInt32*,
    d : UInt32*,
    m2 : UInt32*,
  ) : Int32

  # ---- FQ_CODEL (Fair Queuing Controlled Delay) -------------------------
  # (from <netlink/route/qdisc/fq_codel.h>)

  fun rtnl_fq_codel_set_limit = rtnl_fq_codel_set_limit(qdisc : Pointer(Rtnl_Qdisc), limit : UInt32) : Int32
  fun rtnl_fq_codel_get_limit = rtnl_fq_codel_get_limit(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_fq_codel_set_flows = rtnl_fq_codel_set_flows(qdisc : Pointer(Rtnl_Qdisc), flows : UInt32) : Int32
  fun rtnl_fq_codel_get_flows = rtnl_fq_codel_get_flows(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_fq_codel_set_target = rtnl_fq_codel_set_target(qdisc : Pointer(Rtnl_Qdisc), target : UInt32) : Int32
  fun rtnl_fq_codel_get_target = rtnl_fq_codel_get_target(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_fq_codel_set_interval = rtnl_fq_codel_set_interval(qdisc : Pointer(Rtnl_Qdisc), interval : UInt32) : Int32
  fun rtnl_fq_codel_get_interval = rtnl_fq_codel_get_interval(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_fq_codel_set_ecn = rtnl_fq_codel_set_ecn(qdisc : Pointer(Rtnl_Qdisc), ecn : UInt32) : Int32
  fun rtnl_fq_codel_get_ecn = rtnl_fq_codel_get_ecn(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_fq_codel_set_ce_threshold = rtnl_fq_codel_set_ce_threshold(qdisc : Pointer(Rtnl_Qdisc), threshold : UInt32) : Int32
  fun rtnl_fq_codel_get_ce_threshold = rtnl_fq_codel_get_ce_threshold(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  # ---- NETEM (Network Emulator) -----------------------------------------
  # (from <netlink/route/qdisc/netem.h>)

  fun rtnl_netem_set_delay = rtnl_netem_set_delay(qdisc : Pointer(Rtnl_Qdisc), delay : UInt32) : Int32
  fun rtnl_netem_get_delay = rtnl_netem_get_delay(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_delay_jitter = rtnl_netem_set_delay_jitter(qdisc : Pointer(Rtnl_Qdisc), jitter : UInt32) : Int32
  fun rtnl_netem_get_delay_jitter = rtnl_netem_get_delay_jitter(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_delay_correlation = rtnl_netem_set_delay_correlation(qdisc : Pointer(Rtnl_Qdisc), corr : UInt32) : Int32
  fun rtnl_netem_get_delay_correlation = rtnl_netem_get_delay_correlation(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_loss = rtnl_netem_set_loss(qdisc : Pointer(Rtnl_Qdisc), loss : UInt32) : Int32
  fun rtnl_netem_get_loss = rtnl_netem_get_loss(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_loss_correlation = rtnl_netem_set_loss_correlation(qdisc : Pointer(Rtnl_Qdisc), corr : UInt32) : Int32
  fun rtnl_netem_get_loss_correlation = rtnl_netem_get_loss_correlation(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_gap = rtnl_netem_set_gap(qdisc : Pointer(Rtnl_Qdisc), gap : UInt32) : Int32
  fun rtnl_netem_get_gap = rtnl_netem_get_gap(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_duplicate = rtnl_netem_set_duplicate(qdisc : Pointer(Rtnl_Qdisc), dup : UInt32) : Int32
  fun rtnl_netem_get_duplicate = rtnl_netem_get_duplicate(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_duplicate_correlation = rtnl_netem_set_duplicate_correlation(qdisc : Pointer(Rtnl_Qdisc), corr : UInt32) : Int32
  fun rtnl_netem_get_duplicate_correlation = rtnl_netem_get_duplicate_correlation(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_corrupt = rtnl_netem_set_corrupt(qdisc : Pointer(Rtnl_Qdisc), corrupt : UInt32) : Int32
  fun rtnl_netem_get_corrupt = rtnl_netem_get_corrupt(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_corrupt_correlation = rtnl_netem_set_corrupt_correlation(qdisc : Pointer(Rtnl_Qdisc), corr : UInt32) : Int32
  fun rtnl_netem_get_corrupt_correlation = rtnl_netem_get_corrupt_correlation(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_reorder = rtnl_netem_set_reorder(qdisc : Pointer(Rtnl_Qdisc), reorder : UInt32) : Int32
  fun rtnl_netem_get_reorder = rtnl_netem_get_reorder(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_reorder_correlation = rtnl_netem_set_reorder_correlation(qdisc : Pointer(Rtnl_Qdisc), corr : UInt32) : Int32
  fun rtnl_netem_get_reorder_correlation = rtnl_netem_get_reorder_correlation(qdisc : Pointer(Rtnl_Qdisc)) : UInt32

  fun rtnl_netem_set_rate = rtnl_netem_set_rate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32, packet_overhead : Int32, cell_size : Int32, cell_overhead : Int32) : Int32
  fun rtnl_netem_get_rate = rtnl_netem_get_rate(qdisc : Pointer(Rtnl_Qdisc), rate : UInt32*) : Int32

  # ---- Filter parameter setters ------------------------------------------
  # (from various cls/*.h)

  # ---- U32 filter -------------------------------------------------------
  # (from <netlink/route/cls/u32.h>)
  fun rtnl_u32_set_handle = rtnl_u32_set_handle(filter : Pointer(Rtnl_Filter), handle : UInt32) : Int32
  fun rtnl_u32_get_handle = rtnl_u32_get_handle(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_u32_set_hash = rtnl_u32_set_hash(filter : Pointer(Rtnl_Filter), hash : UInt32) : Int32
  fun rtnl_u32_get_hash = rtnl_u32_get_hash(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_u32_set_classid = rtnl_u32_set_classid(filter : Pointer(Rtnl_Filter), classid : UInt32) : Int32
  fun rtnl_u32_get_classid = rtnl_u32_get_classid(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_u32_set_divisor = rtnl_u32_set_divisor(filter : Pointer(Rtnl_Filter), divisor : UInt32) : Int32
  fun rtnl_u32_get_divisor = rtnl_u32_get_divisor(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_u32_set_order = rtnl_u32_set_order(filter : Pointer(Rtnl_Filter), order : UInt32) : Int32
  fun rtnl_u32_get_order = rtnl_u32_get_order(filter : Pointer(Rtnl_Filter)) : UInt32

  # ---- Basic filter -----------------------------------------------------
  # (from <netlink/route/cls/basic.h>)
  fun rtnl_basic_set_classid = rtnl_basic_set_classid(filter : Pointer(Rtnl_Filter), classid : UInt32) : Int32
  fun rtnl_basic_get_classid = rtnl_basic_get_classid(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_basic_set_ematch = rtnl_basic_set_ematch(filter : Pointer(Rtnl_Filter), ematch : Pointer(Void)) : Int32
  fun rtnl_basic_get_ematch = rtnl_basic_get_ematch(filter : Pointer(Rtnl_Filter)) : Pointer(Void)

  # ---- FW (Firewall) filter ---------------------------------------------
  # (from <netlink/route/cls/fw.h>)
  fun rtnl_fw_set_classid = rtnl_fw_set_classid(filter : Pointer(Rtnl_Filter), classid : UInt32) : Int32
  fun rtnl_fw_get_classid = rtnl_fw_get_classid(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_fw_set_mask = rtnl_fw_set_mask(filter : Pointer(Rtnl_Filter), mask : UInt32) : Int32
  fun rtnl_fw_get_mask = rtnl_fw_get_mask(filter : Pointer(Rtnl_Filter)) : UInt32

  fun rtnl_fw_set_police = rtnl_fw_set_police(filter : Pointer(Rtnl_Filter), police : UInt32) : Int32
  fun rtnl_fw_get_police = rtnl_fw_get_police(filter : Pointer(Rtnl_Filter)) : UInt32

  # ======================================================================
  # TC Action specific bindings (from <netlink/route/act/mirred.h> and <netlink/route/act/police.h>)
  # ======================================================================

  # ---- Mirred (mirror/redirect) action -----------------------------------
  # (from <netlink/route/act/mirred.h>)

  fun rtnl_mirred_set_ifindex = rtnl_mirred_set_ifindex(act : Pointer(Rtnl_Act), ifindex : Int32) : Int32
  fun rtnl_mirred_get_ifindex = rtnl_mirred_get_ifindex(act : Pointer(Rtnl_Act)) : Int32

  fun rtnl_mirred_set_action = rtnl_mirred_set_action(act : Pointer(Rtnl_Act), action : UInt8) : Int32 # TCA_EGRESS_REDIR, TCA_EGRESS_MIRROR
  fun rtnl_mirred_get_action = rtnl_mirred_get_action(act : Pointer(Rtnl_Act)) : UInt8

  fun rtnl_mirred_set_policy = rtnl_mirred_set_policy(act : Pointer(Rtnl_Act), policy : UInt8) : Int32
  fun rtnl_mirred_get_policy = rtnl_mirred_get_policy(act : Pointer(Rtnl_Act)) : UInt8

  # ---- Police (policing) action ------------------------------------------
  # (from <netlink/route/act/police.h>)

  fun rtnl_police_set_rate = rtnl_police_set_rate(act : Pointer(Rtnl_Act), rate : UInt32, burst : UInt32) : Int32
  fun rtnl_police_get_rate = rtnl_police_get_rate(act : Pointer(Rtnl_Act), rate : UInt32*) : Int32
  fun rtnl_police_get_burst = rtnl_police_get_burst(act : Pointer(Rtnl_Act), burst : UInt32*) : Int32

  fun rtnl_police_set_peakrate = rtnl_police_set_peakrate(act : Pointer(Rtnl_Act), rate : UInt32, mtu : UInt32) : Int32
  fun rtnl_police_get_peakrate = rtnl_police_get_peakrate(act : Pointer(Rtnl_Act), rate : UInt32*) : Int32
  fun rtnl_police_get_peakmtu = rtnl_police_get_peakmtu(act : Pointer(Rtnl_Act), mtu : UInt32*) : Int32

  fun rtnl_police_set_action = rtnl_police_set_action(act : Pointer(Rtnl_Act), action : UInt8) : Int32 # TC_POLICE_OK, TC_POLICE_RECLASSIFY, etc.
  fun rtnl_police_get_action = rtnl_police_get_action(act : Pointer(Rtnl_Act)) : UInt8

  fun rtnl_police_set_result = rtnl_police_set_result(act : Pointer(Rtnl_Act), result : UInt8) : Int32
  fun rtnl_police_get_result = rtnl_police_get_result(act : Pointer(Rtnl_Act)) : UInt8
end
