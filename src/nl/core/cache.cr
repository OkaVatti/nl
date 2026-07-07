# src/nl/core/cache.cr
#
# High‑level wrapper for netlink caches.

module Nl
  ##
  # A netlink cache, typically used to hold a set of objects (links, routes,
  # addresses, etc.) retrieved from the kernel.
  class Cache
    @ptr : Pointer(LibNL::NL_Cache)
    @owned : Bool

    # Creates a cache from a cache operations pointer.
    #
    # Most users should obtain a cache via the class methods of the specific
    # object type (e.g., `Link.cache`, `Route.cache`).
    def initialize(ops : Pointer(LibNL::NL_Cache_Ops), owned : Bool = true)
      @ptr = LibNL.nl_cache_alloc(ops)
      raise Error.new("Failed to allocate cache") if @ptr.null?
      @owned = owned
    end

    # Wraps an existing cache pointer.
    def initialize(ptr : Pointer(LibNL::NL_Cache), owned : Bool = false)
      @ptr = ptr
      @owned = owned
    end

    # Frees the cache if owned.
    def free : Nil
      if @owned && !@ptr.null?
        LibNL.nl_cache_free(@ptr)
        @ptr = Pointer(LibNL::NL_Cache).null
      end
    end

    def to_unsafe
      @ptr
    end

    # Refills the cache from the kernel.
    def refill(sk : Socket) : Nil
      ret = LibNL.nl_cache_refill(sk.to_unsafe, @ptr)
      raise Error.from_ret(ret) if ret < 0
    end

    # Clears all objects from the cache.
    def clear : Nil
      LibNL.nl_cache_clear(@ptr)
    end

    # Returns the number of items in the cache.
    def nitems : Int32
      LibNL.nl_cache_nitems(@ptr)
    end

    # Iterates over all objects in the cache.
    #
    # Yields the raw `NL_Object` pointers; usually you will cast them to the
    # appropriate type (e.g., `Link`, `Route`) using their constructor.
    def each(&)
      obj = LibNL.nl_cache_get_first(@ptr)
      while !obj.null?
        yield obj
        obj = LibNL.nl_cache_get_next(obj)
      end
    end

    # Finds an object that matches the given filter.
    def find(filter : Pointer(LibNL::NL_Object)) : Pointer(LibNL::NL_Object)
      LibNL.nl_cache_find(@ptr, filter)
    end

    # Finalizer.
    def finalize
      free
    end
  end
end
