# src/nl/xfrm/sa.cr
#
# High‑level wrapper for XFRM Security Associations.

module Nl::XFrm
  ##
  # A Security Association (SA).
  class SA
    @ptr : Pointer(LibNLXfrm::XfrmnlSa)
    @owned : Bool

    # Allocates a new SA object.
    def initialize
      @ptr = LibNLXfrm.xfrmnl_sa_alloc
      raise Error.new("Failed to allocate SA") if @ptr.null?
      @owned = true
    end

    # Wraps an existing SA pointer.
    def initialize(ptr : Pointer(LibNLXfrm::XfrmnlSa), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the SA if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNLXfrm.xfrmnl_sa_put(@ptr)
        @ptr = Pointer(LibNLXfrm::XfrmnlSa).null
      end
    end

    def to_unsafe
      @ptr
    end

    # --- SPI / Protocol / Family / Mode ------------------------------------
    #
    # Sets the SPI (Security Parameters Index).
    def spi=(spi : UInt32) : Nil
      ret = LibNLXfrm.xfrmnl_sa_set_spi(@ptr, spi)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the SPI.
    def spi : UInt32
      LibNLXfrm.xfrmnl_sa_get_spi(@ptr)
    end

    # Sets the protocol (e.g., `XFRM_PROTO_ESP`, `XFRM_PROTO_AH`).
    def proto=(proto : UInt8) : Nil
      ret = LibNLXfrm.xfrmnl_sa_set_proto(@ptr, proto)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the protocol.
    def proto : UInt8
      LibNLXfrm.xfrmnl_sa_get_proto(@ptr)
    end

    # Sets the address family (e.g., `XFRM_AF_INET`).
    def family=(fam : UInt8) : Nil
      ret = LibNLXfrm.xfrmnl_sa_set_family(@ptr, fam)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the address family.
    def family : UInt8
      LibNLXfrm.xfrmnl_sa_get_family(@ptr)
    end

    # Sets the mode (e.g., `XFRM_MODE_TUNNEL`, `XFRM_MODE_TRANSPORT`).
    def mode=(mode : UInt8) : Nil
      ret = LibNLXfrm.xfrmnl_sa_set_mode(@ptr, mode)
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the mode.
    def mode : UInt8
      LibNLXfrm.xfrmnl_sa_get_mode(@ptr)
    end

    # --- Add / Update / Delete --------------------------------------------
    #
    # Adds the SA.
    def add(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLXfrm.xfrmnl_sa_add(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Updates the SA.
    def update(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLXfrm.xfrmnl_sa_update(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # Deletes the SA.
    def delete(sk : Socket, flags : Int32 = 0) : Nil
      ret = LibNLXfrm.xfrmnl_sa_delete(sk.to_unsafe, @ptr, flags)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free
    end
  end
end
