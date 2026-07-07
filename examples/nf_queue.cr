#!/usr/bin/env crystal
# examples/nf_queue.cr
# Bind to NFQUEUE and send a verdict (requires root).

require "../src/nl"

unless Process.uid == 0
  puts "This example requires root privileges to use NFQUEUE."
  exit 1
end

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_NETFILTER)

# Allocate queue object
queue = LibNLNf.nfnl_queue_alloc
LibNLNf.nfnl_queue_set_queue_num(queue, 0_u16)
LibNLNf.nfnl_queue_set_copy_mode(queue, LibNLNf::NFQUEUE_COPY_PACKET)
LibNLNf.nfnl_queue_set_copy_range(queue, 65535_u32)

# Bind to the queue
ret = LibNLNf.nfnl_queue_bind(sk.to_unsafe, queue)
if ret < 0
  puts "Failed to bind to queue: #{LibNL.nl_geterror(ret)}"
  exit 1
end

puts "Bound to queue 0. In a real program, you would receive packets and send verdicts."
# In a real scenario, you would use a callback to receive packets and then:
# packet_id = ... (from the received message)
# LibNLNf.nfnl_queue_verdict(sk.to_unsafe, 0_u16, packet_id, LibNLNf::NF_ACCEPT)
