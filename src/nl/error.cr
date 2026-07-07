# src/nl/error.cr
#
# Custom exception classes for the high‑level netlink wrapper.

module Nl
  ##
  # Base error for all netlink operations.
  #
  # All methods in the high‑level wrapper raise an instance of this class
  # (or a subclass) when an operation fails. The `#code` attribute holds
  # the raw libnl error code.
  class Error < Exception
    getter code : Int32

    def initialize(msg : String, @code : Int32 = 0)
      super(msg)
    end

    # Creates an error from a libnl return code.
    #
    # The error message is retrieved using `LibNL.nl_geterror`.
    def self.from_ret(ret : Int32) : Error
      msg = String.new(LibNL.nl_geterror(ret))
      new(msg, ret)
    end
  end

  ##
  # Raised when a requested object (family, link, etc.) is not found.
  class NotFoundError < Error
  end

  ##
  # Raised when an operation is attempted on a TC object that hasn't been
  # added to the kernel yet.
  #
  # TC objects (qdiscs, classes, filters) must be added via `#add` before
  # their type‑specific setters can be used.
  class TcNotAddedError < Error
    def initialize
      super("TC object not added to kernel yet; call #add first")
    end
  end
end
