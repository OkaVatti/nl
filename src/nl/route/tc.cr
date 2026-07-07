# src/nl/route/tc.cr
#
# High‑level Traffic Control (TC) wrapper.

module Nl::Route::TC
  ##
  # Base class for all TC objects (qdiscs, classes, filters).
  #
  # Provides common attributes like `kind`, `handle`, `parent`, `ifindex`.
  # Subclasses must implement `#add` to apply the object to the kernel.
  abstract class TcObject
    @ptr : Pointer(LibNLRoute::Rtnl_Tc)
    @owned : Bool
    @added : Bool = false # tracks if added to kernel

    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Tc), owned : Bool = true)
      @ptr = ptr
      @owned = owned
    end

    def to_unsafe
      @ptr
    end

    def free
      # Subclasses override this to call their specific put/free.
    end

    # Sets the kind (e.g., "htb", "tbf", "sfq").
    def kind=(kind : String) : Nil
      ret = LibNLRoute.rtnl_tc_set_kind(@ptr, kind.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the kind.
    def kind : String
      ptr = LibNLRoute.rtnl_tc_get_kind(@ptr)
      String.new(ptr)
    end

    # Sets the handle.
    def handle=(h : UInt32) : Nil
      LibNLRoute.rtnl_tc_set_handle(@ptr, h)
    end

    # Returns the handle.
    def handle : UInt32
      LibNLRoute.rtnl_tc_get_handle(@ptr)
    end

    # Sets the parent handle.
    def parent=(p : UInt32) : Nil
      LibNLRoute.rtnl_tc_set_parent(@ptr, p)
    end

    # Returns the parent handle.
    def parent : UInt32
      LibNLRoute.rtnl_tc_get_parent(@ptr)
    end

    # Sets the interface index.
    def ifindex=(idx : Int32) : Nil
      LibNLRoute.rtnl_tc_set_ifindex(@ptr, idx)
    end

    # Returns the interface index.
    def ifindex : Int32
      LibNLRoute.rtnl_tc_get_ifindex(@ptr)
    end

    # Subclasses must implement this method to add the object to the kernel.
    abstract def add(sk : Socket, flags : Int32 = 0) : Nil

    # Marks the object as added after successful kernel addition.
    protected def mark_added
      @added = true
    end

    # Ensures the object is added before allowing type‑specific getters/setters.
    protected def ensure_added
      raise TcNotAddedError.new unless @added
    end
  end

  ##
  # A queuing discipline (qdisc).
  class Qdisc < TcObject
    @qptr : Pointer(LibNLRoute::Rtnl_Qdisc)

    # Allocates a new qdisc.
    def initialize
      ptr = LibNLRoute.rtnl_qdisc_alloc
      raise Error.new("Failed to allocate qdisc") if ptr.null?
      @qptr = ptr
      super(ptr.as(Pointer(LibNLRoute::Rtnl_Tc)), owned: true)
      @added = false
    end

    # Wraps an existing qdisc pointer.
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Qdisc), owned : Bool = false)
      @qptr = ptr
      super(ptr.as(Pointer(LibNLRoute::Rtnl_Tc)), owned: owned)
      @added = true # assume existing qdisc is already in kernel
    end

    def free
      if @owned && !@qptr.null?
        LibNLRoute.rtnl_qdisc_put(@qptr)
        @qptr = Pointer(LibNLRoute::Rtnl_Qdisc).null
      end
    end

    # Adds the qdisc to the kernel.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_qdisc_add(sk.to_unsafe, @qptr, flags)
      raise Error.from_ret(ret) if ret < 0
      mark_added
    end

    # Deletes the qdisc from the kernel.
    def delete(sk : Socket) : Nil
      ret = LibNLRoute.rtnl_qdisc_delete(sk.to_unsafe, @qptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- HTB specific -----------------------------------------------------
    # Sets the HTB rate.
    def htb_rate=(rate : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_set_rate(@qptr, rate)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB rate.
    def htb_rate : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_get_rate(@qptr)
    end

    # Sets the HTB ceil.
    def htb_ceil=(ceil : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_set_ceil(@qptr, ceil)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB ceil.
    def htb_ceil : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_get_ceil(@qptr)
    end

    # Sets the HTB priority.
    def htb_prio=(prio : UInt8) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_set_prio(@qptr, prio)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB priority.
    def htb_prio : UInt8
      ensure_added
      LibNLRoute.rtnl_htb_get_prio(@qptr)
    end

    # Sets the HTB MTU.
    def htb_mtu=(mtu : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_set_mtu(@qptr, mtu)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB MTU.
    def htb_mtu : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_get_mtu(@qptr)
    end

    # Sets the HTB r2q (rate to quantum ratio).
    def htb_r2q=(r2q : UInt16) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_set_r2q(@qptr, r2q)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB r2q.
    def htb_r2q : UInt16
      ensure_added
      LibNLRoute.rtnl_htb_get_r2q(@qptr)
    end

    # Sets the HTB direct queue length.
    def htb_direct_qlen=(qlen : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_set_direct_qlen(@qptr, qlen)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB direct queue length.
    def htb_direct_qlen : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_get_direct_qlen(@qptr)
    end

    # --- TBF -------------------------------------------------------------
    # Sets the TBF rate and burst.
    def tbf_rate(rate : UInt32, burst : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_tbf_set_rate(@qptr, rate, burst)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the TBF rate.
    def tbf_rate : UInt32
      ensure_added
      ptr = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_tbf_get_rate(@qptr, ptr)
      raise Error.from_ret(ret) if ret < 0
      ptr.value
    end

    # Returns the TBF burst.
    def tbf_burst : UInt32
      ensure_added
      ptr = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_tbf_get_burst(@qptr, ptr)
      raise Error.from_ret(ret) if ret < 0
      ptr.value
    end

    # Sets the TBF peak rate and MTU.
    def tbf_peakrate(rate : UInt32, mtu : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_tbf_set_peakrate(@qptr, rate, mtu)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the TBF peak rate.
    def tbf_peakrate : UInt32
      ensure_added
      ptr = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_tbf_get_peakrate(@qptr, ptr)
      raise Error.from_ret(ret) if ret < 0
      ptr.value
    end

    # Returns the TBF peak MTU.
    def tbf_peakmtu : UInt32
      ensure_added
      ptr = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_tbf_get_peakmtu(@qptr, ptr)
      raise Error.from_ret(ret) if ret < 0
      ptr.value
    end

    # Sets the TBF limit.
    def tbf_limit=(limit : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_tbf_set_limit(@qptr, limit)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the TBF limit.
    def tbf_limit : UInt32
      ensure_added
      LibNLRoute.rtnl_tbf_get_limit(@qptr)
    end

    # --- SFQ -------------------------------------------------------------
    # Sets the SFQ quantum.
    def sfq_quantum=(q : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_sfq_set_quantum(@qptr, q)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the SFQ quantum.
    def sfq_quantum : UInt32
      ensure_added
      LibNLRoute.rtnl_sfq_get_quantum(@qptr)
    end

    # Sets the SFQ perturb interval.
    def sfq_perturb=(p : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_sfq_set_perturb(@qptr, p)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the SFQ perturb interval.
    def sfq_perturb : UInt32
      ensure_added
      LibNLRoute.rtnl_sfq_get_perturb(@qptr)
    end

    # Sets the SFQ limit.
    def sfq_limit=(l : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_sfq_set_limit(@qptr, l)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the SFQ limit.
    def sfq_limit : UInt32
      ensure_added
      LibNLRoute.rtnl_sfq_get_limit(@qptr)
    end

    # Sets the SFQ number of flows.
    def sfq_flows=(f : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_sfq_set_flows(@qptr, f)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the SFQ number of flows.
    def sfq_flows : UInt32
      ensure_added
      LibNLRoute.rtnl_sfq_get_flows(@qptr)
    end

    # Sets the SFQ divisor.
    def sfq_divisor=(d : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_sfq_set_divisor(@qptr, d)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the SFQ divisor.
    def sfq_divisor : UInt32
      ensure_added
      LibNLRoute.rtnl_sfq_get_divisor(@qptr)
    end

    # --- RED -------------------------------------------------------------
    # Sets the RED limit.
    def red_limit=(l : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_red_set_limit(@qptr, l)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the RED limit.
    def red_limit : UInt32
      ensure_added
      LibNLRoute.rtnl_red_get_limit(@qptr)
    end

    # Sets the RED minimum threshold.
    def red_min=(m : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_red_set_min(@qptr, m)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the RED minimum threshold.
    def red_min : UInt32
      ensure_added
      LibNLRoute.rtnl_red_get_min(@qptr)
    end

    # Sets the RED maximum threshold.
    def red_max=(m : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_red_set_max(@qptr, m)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the RED maximum threshold.
    def red_max : UInt32
      ensure_added
      LibNLRoute.rtnl_red_get_max(@qptr)
    end

    # Sets the RED probability.
    def red_prob=(p : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_red_set_prob(@qptr, p)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the RED probability.
    def red_prob : UInt32
      ensure_added
      LibNLRoute.rtnl_red_get_prob(@qptr)
    end

    # Sets the RED average packet size.
    def red_avpkt=(a : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_red_set_avpkt(@qptr, a)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the RED average packet size.
    def red_avpkt : UInt32
      ensure_added
      LibNLRoute.rtnl_red_get_avpkt(@qptr)
    end

    # Sets the RED flags.
    def red_flags=(f : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_red_set_flags(@qptr, f)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the RED flags.
    def red_flags : UInt32
      ensure_added
      LibNLRoute.rtnl_red_get_flags(@qptr)
    end

    # --- HFSC ------------------------------------------------------------
    # Sets the real‑time service curve.
    def hfsc_set_rt_sc(m1 : UInt32, d : UInt32, m2 : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_hfsc_set_rt_sc(@qptr, m1, d, m2)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the real‑time service curve as a tuple `{m1, d, m2}`.
    def hfsc_get_rt_sc : {UInt32, UInt32, UInt32}
      ensure_added
      m1 = Pointer(UInt32).malloc(1)
      d = Pointer(UInt32).malloc(1)
      m2 = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_hfsc_get_rt_sc(@qptr, m1, d, m2)
      raise Error.from_ret(ret) if ret < 0
      {m1.value, d.value, m2.value}
    end

    # Sets the link‑share service curve.
    def hfsc_set_ls_sc(m1 : UInt32, d : UInt32, m2 : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_hfsc_set_ls_sc(@qptr, m1, d, m2)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the link‑share service curve.
    def hfsc_get_ls_sc : {UInt32, UInt32, UInt32}
      ensure_added
      m1 = Pointer(UInt32).malloc(1)
      d = Pointer(UInt32).malloc(1)
      m2 = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_hfsc_get_ls_sc(@qptr, m1, d, m2)
      raise Error.from_ret(ret) if ret < 0
      {m1.value, d.value, m2.value}
    end

    # Sets a service curve of the given type.
    def hfsc_set_sc(type : UInt8, m1 : UInt32, d : UInt32, m2 : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_hfsc_set_sc(@qptr, type, m1, d, m2)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns a service curve of the given type.
    def hfsc_get_sc(type : UInt8) : {UInt32, UInt32, UInt32}
      ensure_added
      m1 = Pointer(UInt32).malloc(1)
      d = Pointer(UInt32).malloc(1)
      m2 = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_hfsc_get_sc(@qptr, type, m1, d, m2)
      raise Error.from_ret(ret) if ret < 0
      {m1.value, d.value, m2.value}
    end

    # --- FQ_CODEL --------------------------------------------------------
    # Sets the FQ_CODEL limit.
    def fq_codel_limit=(l : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fq_codel_set_limit(@qptr, l)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the FQ_CODEL limit.
    def fq_codel_limit : UInt32
      ensure_added
      LibNLRoute.rtnl_fq_codel_get_limit(@qptr)
    end

    # Sets the number of flows.
    def fq_codel_flows=(f : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fq_codel_set_flows(@qptr, f)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the number of flows.
    def fq_codel_flows : UInt32
      ensure_added
      LibNLRoute.rtnl_fq_codel_get_flows(@qptr)
    end

    # Sets the target delay.
    def fq_codel_target=(t : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fq_codel_set_target(@qptr, t)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the target delay.
    def fq_codel_target : UInt32
      ensure_added
      LibNLRoute.rtnl_fq_codel_get_target(@qptr)
    end

    # Sets the interval.
    def fq_codel_interval=(i : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fq_codel_set_interval(@qptr, i)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the interval.
    def fq_codel_interval : UInt32
      ensure_added
      LibNLRoute.rtnl_fq_codel_get_interval(@qptr)
    end

    # Sets the ECN flag.
    def fq_codel_ecn=(e : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fq_codel_set_ecn(@qptr, e)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the ECN flag.
    def fq_codel_ecn : UInt32
      ensure_added
      LibNLRoute.rtnl_fq_codel_get_ecn(@qptr)
    end

    # Sets the CE threshold.
    def fq_codel_ce_threshold=(t : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fq_codel_set_ce_threshold(@qptr, t)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the CE threshold.
    def fq_codel_ce_threshold : UInt32
      ensure_added
      LibNLRoute.rtnl_fq_codel_get_ce_threshold(@qptr)
    end

    # --- NETEM -----------------------------------------------------------
    # Sets the NETEM delay.
    def netem_delay=(delay : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_delay(@qptr, delay)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the NETEM delay.
    def netem_delay : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_delay(@qptr)
    end

    # Sets the delay jitter.
    def netem_delay_jitter=(jitter : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_delay_jitter(@qptr, jitter)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the delay jitter.
    def netem_delay_jitter : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_delay_jitter(@qptr)
    end

    # Sets the delay correlation.
    def netem_delay_correlation=(corr : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_delay_correlation(@qptr, corr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the delay correlation.
    def netem_delay_correlation : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_delay_correlation(@qptr)
    end

    # Sets the loss probability.
    def netem_loss=(loss : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_loss(@qptr, loss)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the loss probability.
    def netem_loss : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_loss(@qptr)
    end

    # Sets the loss correlation.
    def netem_loss_correlation=(corr : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_loss_correlation(@qptr, corr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the loss correlation.
    def netem_loss_correlation : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_loss_correlation(@qptr)
    end

    # Sets the gap.
    def netem_gap=(gap : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_gap(@qptr, gap)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the gap.
    def netem_gap : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_gap(@qptr)
    end

    # Sets the duplicate probability.
    def netem_duplicate=(dup : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_duplicate(@qptr, dup)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the duplicate probability.
    def netem_duplicate : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_duplicate(@qptr)
    end

    # Sets the duplicate correlation.
    def netem_duplicate_correlation=(corr : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_duplicate_correlation(@qptr, corr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the duplicate correlation.
    def netem_duplicate_correlation : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_duplicate_correlation(@qptr)
    end

    # Sets the corrupt probability.
    def netem_corrupt=(corrupt : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_corrupt(@qptr, corrupt)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the corrupt probability.
    def netem_corrupt : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_corrupt(@qptr)
    end

    # Sets the corrupt correlation.
    def netem_corrupt_correlation=(corr : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_corrupt_correlation(@qptr, corr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the corrupt correlation.
    def netem_corrupt_correlation : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_corrupt_correlation(@qptr)
    end

    # Sets the reorder probability.
    def netem_reorder=(reorder : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_reorder(@qptr, reorder)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the reorder probability.
    def netem_reorder : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_reorder(@qptr)
    end

    # Sets the reorder correlation.
    def netem_reorder_correlation=(corr : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_reorder_correlation(@qptr, corr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the reorder correlation.
    def netem_reorder_correlation : UInt32
      ensure_added
      LibNLRoute.rtnl_netem_get_reorder_correlation(@qptr)
    end

    # Sets the NETEM rate (with overhead parameters).
    def netem_rate(rate : UInt32, packet_overhead : Int32, cell_size : Int32, cell_overhead : Int32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_netem_set_rate(@qptr, rate, packet_overhead, cell_size, cell_overhead)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the NETEM rate.
    def netem_rate : UInt32
      ensure_added
      ptr = Pointer(UInt32).malloc(1)
      ret = LibNLRoute.rtnl_netem_get_rate(@qptr, ptr)
      raise Error.from_ret(ret) if ret < 0
      ptr.value
    end

    # --- Statistics -------------------------------------------------------
    # Returns a statistic counter for the qdisc.
    def stat(id : RtnlTcStatsId) : UInt64
      LibNLRoute.rtnl_tc_get_stat(@ptr, id)
    end
  end

  ##
  # A TC class.
  class Class < TcObject
    @cptr : Pointer(LibNLRoute::Rtnl_Class)

    # Allocates a new class.
    def initialize
      ptr = LibNLRoute.rtnl_class_alloc
      raise Error.new("Failed to allocate class") if ptr.null?
      @cptr = ptr
      super(ptr.as(Pointer(LibNLRoute::Rtnl_Tc)), owned: true)
      @added = false
    end

    # Wraps an existing class pointer.
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Class), owned : Bool = false)
      @cptr = ptr
      super(ptr.as(Pointer(LibNLRoute::Rtnl_Tc)), owned: owned)
      @added = true
    end

    def free
      if @owned && !@cptr.null?
        LibNLRoute.rtnl_class_put(@cptr)
        @cptr = Pointer(LibNLRoute::Rtnl_Class).null
      end
    end

    # Adds the class to the kernel.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_class_add(sk.to_unsafe, @cptr, flags)
      raise Error.from_ret(ret) if ret < 0
      mark_added
    end

    # Deletes the class from the kernel.
    def delete(sk : Socket) : Nil
      ret = LibNLRoute.rtnl_class_delete(sk.to_unsafe, @cptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- HTB class -------------------------------------------------------
    # Sets the HTB rate.
    def htb_rate=(rate : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_class_set_rate(@cptr, rate)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB rate.
    def htb_rate : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_class_get_rate(@cptr)
    end

    # Sets the HTB ceil.
    def htb_ceil=(ceil : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_class_set_ceil(@cptr, ceil)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB ceil.
    def htb_ceil : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_class_get_ceil(@cptr)
    end

    # Sets the HTB priority.
    def htb_prio=(prio : UInt8) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_class_set_prio(@cptr, prio)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB priority.
    def htb_prio : UInt8
      ensure_added
      LibNLRoute.rtnl_htb_class_get_prio(@cptr)
    end

    # Sets the HTB level.
    def htb_level=(level : UInt8) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_class_set_level(@cptr, level)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB level.
    def htb_level : UInt8
      ensure_added
      LibNLRoute.rtnl_htb_class_get_level(@cptr)
    end

    # Sets the HTB buffer.
    def htb_buffer=(buffer : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_class_set_buffer(@cptr, buffer)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB buffer.
    def htb_buffer : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_class_get_buffer(@cptr)
    end

    # Sets the HTB cbuffer (ceil buffer).
    def htb_cbuffer=(cbuffer : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_htb_class_set_cbuffer(@cptr, cbuffer)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the HTB cbuffer.
    def htb_cbuffer : UInt32
      ensure_added
      LibNLRoute.rtnl_htb_class_get_cbuffer(@cptr)
    end
  end

  ##
  # A TC filter.
  class Filter < TcObject
    @fptr : Pointer(LibNLRoute::Rtnl_Filter)

    # Allocates a new filter.
    def initialize
      ptr = LibNLRoute.rtnl_filter_alloc
      raise Error.new("Failed to allocate filter") if ptr.null?
      @fptr = ptr
      super(ptr.as(Pointer(LibNLRoute::Rtnl_Tc)), owned: true)
      @added = false
    end

    # Wraps an existing filter pointer.
    def initialize(ptr : Pointer(LibNLRoute::Rtnl_Filter), owned : Bool = false)
      @fptr = ptr
      super(ptr.as(Pointer(LibNLRoute::Rtnl_Tc)), owned: owned)
      @added = true # assume existing
    end

    def free
      if @owned && !@fptr.null?
        LibNLRoute.rtnl_filter_put(@fptr)
        @fptr = Pointer(LibNLRoute::Rtnl_Filter).null
      end
    end

    # Adds the filter to the kernel.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLRoute.rtnl_filter_add(sk.to_unsafe, @fptr, flags)
      raise Error.from_ret(ret) if ret < 0
      mark_added
    end

    # Deletes the filter from the kernel.
    def delete(sk : Socket) : Nil
      ret = LibNLRoute.rtnl_filter_delete(sk.to_unsafe, @fptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- U32 filter ------------------------------------------------------
    # Sets the U32 handle.
    def u32_handle=(h : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_u32_set_handle(@fptr, h)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the U32 handle.
    def u32_handle : UInt32
      ensure_added
      LibNLRoute.rtnl_u32_get_handle(@fptr)
    end

    # Sets the U32 hash.
    def u32_hash=(hash : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_u32_set_hash(@fptr, hash)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the U32 hash.
    def u32_hash : UInt32
      ensure_added
      LibNLRoute.rtnl_u32_get_hash(@fptr)
    end

    # Sets the U32 classid.
    def u32_classid=(classid : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_u32_set_classid(@fptr, classid)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the U32 classid.
    def u32_classid : UInt32
      ensure_added
      LibNLRoute.rtnl_u32_get_classid(@fptr)
    end

    # Sets the U32 divisor.
    def u32_divisor=(divisor : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_u32_set_divisor(@fptr, divisor)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the U32 divisor.
    def u32_divisor : UInt32
      ensure_added
      LibNLRoute.rtnl_u32_get_divisor(@fptr)
    end

    # Sets the U32 order.
    def u32_order=(order : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_u32_set_order(@fptr, order)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the U32 order.
    def u32_order : UInt32
      ensure_added
      LibNLRoute.rtnl_u32_get_order(@fptr)
    end

    # --- Basic filter ----------------------------------------------------
    # Sets the basic filter's classid.
    def basic_classid=(classid : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_basic_set_classid(@fptr, classid)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the basic filter's classid.
    def basic_classid : UInt32
      ensure_added
      LibNLRoute.rtnl_basic_get_classid(@fptr)
    end

    # Sets the basic filter's ematch.
    def basic_ematch=(ematch : Pointer(Void)) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_basic_set_ematch(@fptr, ematch)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the basic filter's ematch.
    def basic_ematch : Pointer(Void)
      ensure_added
      LibNLRoute.rtnl_basic_get_ematch(@fptr)
    end

    # --- FW filter -------------------------------------------------------
    # Sets the FW filter's classid.
    def fw_classid=(classid : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fw_set_classid(@fptr, classid)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the FW filter's classid.
    def fw_classid : UInt32
      ensure_added
      LibNLRoute.rtnl_fw_get_classid(@fptr)
    end

    # Sets the FW filter's mask.
    def fw_mask=(mask : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fw_set_mask(@fptr, mask)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the FW filter's mask.
    def fw_mask : UInt32
      ensure_added
      LibNLRoute.rtnl_fw_get_mask(@fptr)
    end

    # Sets the FW filter's police action.
    def fw_police=(police : UInt32) : Nil
      ensure_added
      ret = LibNLRoute.rtnl_fw_set_police(@fptr, police)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the FW filter's police action.
    def fw_police : UInt32
      ensure_added
      LibNLRoute.rtnl_fw_get_police(@fptr)
    end
  end
end
