# src/libnl/genl/helpers.cr
#
# High‑level helpers for Generic Netlink operations.

@[Link("nl-genl-3")]
lib LibNLGenl
  # We already have genl_send_simple; we'll add additional helpers as static methods.

  # ---- Family resolution and message construction ------------------------

  # Resolve a family ID and return a family object (from cache).
  # This is already available via genl_ctrl_search_by_name etc.
  # We'll provide a Crystal wrapper that uses the cache to get the family pointer.

  # ---- Build a command message with a family name (without a cache) ------
  # This uses genl_ctrl_resolve to get ID, then builds a message with genlmsg_put.

  # ---- Send a simple command and wait for reply --------------------------
  # We already have genl_send_simple; we can add a wrapper that handles errors.
end

# Add Crystal helpers in the same file outside the lib block.
module LibNLGenlHelpers
  # Resolve a family name to a family object using a cache.
  # If cache is nil, it will allocate a new cache.
  def self.get_family(sk : Pointer(LibNL::NL_Sock), name : String, cache : Pointer(LibNL::NL_Cache) | Nil = nil) : Pointer(LibNLGenl::GenlFamily)
    local_cache = cache
    if local_cache.nil?
      c = Pointer(LibNL::NL_Cache).null
      ret = LibNLGenl.genl_ctrl_alloc_cache(sk, pointerof(c))
      if ret != 0
        raise "Failed to allocate genl cache: #{LibNL.nl_geterror(ret)}"
      end
      local_cache = c
    end
    family = LibNLGenl.genl_ctrl_search_by_name(local_cache, name)
    if family.null?
      raise "Family not found: #{name}"
    end
    family
  end

  # Build a generic netlink message for a specific family and command.
  def self.build_message(sk : Pointer(LibNL::NL_Sock), family_name : String, cmd : UInt8, version : UInt8 = 1, flags : Int32 = LibNL::NLM_F_REQUEST, hdrlen : Int32 = 0, port : UInt32 = 0, seq : UInt32 = 0) : Pointer(LibNL::NL_Msg)
    # Resolve family
    family = get_family(sk, family_name)
    msg = LibNL.nlmsg_alloc
    raise "Failed to allocate netlink message" if msg.null?
    hdr = LibNLGenl.genlmsg_put(msg, port, seq, family, hdrlen, flags, cmd, version)
    raise "Failed to put genl header" if hdr.null?
    msg
  end

  # Send a generic netlink message with attributes and receive response.
  # This is a simplified version; you can extend as needed.
  def self.send_and_wait(sk : Pointer(LibNL::NL_Sock), msg : Pointer(LibNL::NL_Msg)) : Int32
    ret = LibNL.nl_send_auto(sk, msg)
    return ret if ret < 0
    LibNL.nl_recvmsgs_default(sk)
  end
end
