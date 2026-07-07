# src/nl/core/socket.cr
#
# High‑level wrapper for a Netlink socket.

module Nl
  ##
  # A Netlink socket.
  #
  # This class manages the underlying `NL_Sock` pointer, provides automatic
  # connection to a protocol family, and offers convenience methods for
  # sending/receiving messages and managing socket options.
  class Socket
    @handle : Pointer(LibNL::NL_Sock)

    getter handle : Pointer(LibNL::NL_Sock)

    # Creates a new Netlink socket.
    #
    # Optionally accepts a callback handle (`LibNL::NL_Cb`) to use for
    # receiving messages.
    def initialize(cb : Pointer(LibNL::NL_Cb) | Nil = nil)
      @handle = if cb
                  LibNL.nl_socket_alloc_cb(cb)
                else
                  LibNL.nl_socket_alloc
                end
      raise Error.new("Failed to allocate Netlink socket") if @handle.null?
    end

    # Connects the socket to the given netlink protocol family.
    #
    # Common families are `LibNL::NETLINK_ROUTE`, `LibNL::NETLINK_GENERIC`,
    # etc.
    #
    # Raises `Nl::Error` on failure.
    def connect(protocol : Int32) : self
      ret = LibNL.nl_connect(@handle, protocol)
      raise Error.from_ret(ret) if ret < 0
      self
    end

    # Closes the socket (calls `nl_close`).
    def close : self
      LibNL.nl_close(@handle)
      self
    end

    # Frees the socket (calls `nl_socket_free`).
    #
    # After this call, the socket is no longer usable.
    def free : Nil
      LibNL.nl_socket_free(@handle)
      @handle = Pointer(LibNL::NL_Sock).null
    end

    # Returns the underlying pointer.
    def to_unsafe
      @handle
    end

    # --- Socket options --------------------------------------------------

    # Sets the local port.
    def local_port=(port : UInt32) : Nil
      LibNL.nl_socket_set_local_port(@handle, port)
    end

    # Returns the local port.
    def local_port : UInt32
      LibNL.nl_socket_get_local_port(@handle)
    end

    # Sets the peer port.
    def peer_port=(port : UInt32) : Nil
      LibNL.nl_socket_set_peer_port(@handle, port)
    end

    # Returns the peer port.
    def peer_port : UInt32
      LibNL.nl_socket_get_peer_port(@handle)
    end

    # Sets the peer groups (multicast groups) to listen to.
    def peer_groups=(groups : UInt32) : Nil
      LibNL.nl_socket_set_peer_groups(@handle, groups)
    end

    # Returns the peer groups.
    def peer_groups : UInt32
      LibNL.nl_socket_get_peer_groups(@handle)
    end

    # Makes the socket non‑blocking.
    def nonblocking! : Nil
      LibNL.nl_socket_set_nonblocking(@handle)
    end

    # Enables or disables automatic ACK handling.
    def auto_ack=(enabled : Bool) : Nil
      if enabled
        LibNL.nl_socket_enable_auto_ack(@handle)
      else
        LibNL.nl_socket_disable_auto_ack(@handle)
      end
    end

    # Enables or disables sequence number checking.
    def seq_check=(enabled : Bool) : Nil
      if enabled
        LibNL.nl_socket_enable_seq_check(@handle)
      else
        LibNL.nl_socket_disable_seq_check(@handle)
      end
    end

    # Sets the receive and transmit buffer sizes.
    def buffer_size(rxbuf : Int32, txbuf : Int32) : Nil
      ret = LibNL.nl_socket_set_buffer_size(@handle, rxbuf, txbuf)
      raise Error.from_ret(ret) if ret < 0
    end

    # Sets the message buffer size.
    def msg_buf_size=(size : LibC::SizeT) : Nil
      LibNL.nl_socket_set_msg_buf_size(@handle, size)
    end

    # Returns the current message buffer size.
    def msg_buf_size : LibC::SizeT
      LibNL.nl_socket_get_msg_buf_size(@handle)
    end

    # Sets the file descriptor for the socket (if already connected).
    def fd=(fd : Int32) : Nil
      ret = LibNL.nl_socket_set_fd(@handle, 0, fd) # protocol arg is ignored
      raise Error.from_ret(ret) if ret < 0
    end

    # Returns the file descriptor of the socket.
    def fd : Int32
      LibNL.nl_socket_get_fd(@handle)
    end

    # --- Membership groups -----------------------------------------------

    # Adds the socket to a multicast group.
    def add_membership(group : Int32) : Nil
      ret = LibNL.nl_socket_add_membership(@handle, group)
      raise Error.from_ret(ret) if ret < 0
    end

    # Drops membership of a multicast group.
    def drop_membership(group : Int32) : Nil
      ret = LibNL.nl_socket_drop_membership(@handle, group)
      raise Error.from_ret(ret) if ret < 0
    end

    # --- Sequence numbers ------------------------------------------------

    # Returns a new sequence number for this socket.
    def use_seq : UInt32
      LibNL.nl_socket_use_seq(@handle)
    end

    # --- Send / Receive helpers -----------------------------------------

    # Sends a message (auto‑complete and send).
    #
    # The `msg` is automatically completed (port, sequence, etc.) before sending.
    def send_message(msg : Message) : Int32
      ret = LibNL.nl_send_auto(@handle, msg.to_unsafe)
      raise Error.from_ret(ret) if ret < 0
      ret
    end

    # Receives messages using the default callback set.
    def recv_default : Int32
      ret = LibNL.nl_recvmsgs_default(@handle)
      raise Error.from_ret(ret) if ret < 0
      ret
    end

    # Waits for an ACK (if auto‑ACK is disabled).
    def wait_for_ack : Int32
      ret = LibNL.nl_wait_for_ack(@handle)
      raise Error.from_ret(ret) if ret < 0
      ret
    end

    # --- Finalizer --------------------------------------------------------
    def finalize
      free unless @handle.null?
    end
  end
end
