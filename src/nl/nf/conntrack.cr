# src/nl/nf/conntrack.cr
#
# High‑level wrapper for conntrack entries.

module Nl::NF::Conntrack
  ##
  # A conntrack entry.
  class Entry
    @ptr : Pointer(LibNLNf::NfnlCt)
    @owned : Bool

    # Allocates a new conntrack entry.
    def initialize
      @ptr = LibNLNf.nfnl_ct_alloc
      raise Error.new("Failed to allocate conntrack entry") if @ptr.null?
      @owned = true
    end

    # Wraps an existing conntrack entry pointer.
    def initialize(ptr : Pointer(LibNLNf::NfnlCt), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the entry if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLNf.nfnl_ct_put(@ptr)
        @ptr = Pointer(LibNLNf::NfnlCt).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- Status / Mark / Timeout ------------------------------------------
    #
    # Sets the conntrack status bits (e.g., `IPS_SEEN_REPLY`).
    def status=(st : UInt32) : Nil
      LibNLNf.nfnl_ct_set_status(@ptr, st)
    end

    # Returns the status bits.
    def status : UInt32
      LibNLNf.nfnl_ct_get_status(@ptr)
    end

    # Sets the conntrack mark.
    def mark=(m : UInt32) : Nil
      LibNLNf.nfnl_ct_set_mark(@ptr, m)
    end

    # Returns the conntrack mark.
    def mark : UInt32
      LibNLNf.nfnl_ct_get_mark(@ptr)
    end

    # Sets the timeout value (in seconds).
    def timeout=(t : UInt32) : Nil
      LibNLNf.nfnl_ct_set_timeout(@ptr, t)
    end

    # Returns the timeout value.
    def timeout : UInt32
      LibNLNf.nfnl_ct_get_timeout(@ptr)
    end

    # --- Add / Delete / Get / Update --------------------------------------
    #
    # Adds a new conntrack entry.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLNf.nfnl_ct_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the conntrack entry.
    def delete(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLNf.nfnl_ct_delete(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
