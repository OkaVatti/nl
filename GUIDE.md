# Guide to Using nl – Crystal Bindings for libnl

Welcome to the comprehensive guide for the **nl** shard – Crystal bindings for libnl (netlink). This guide will walk you through the architecture, core concepts, and all major features of the library, with plenty of examples.

---

## Table of Contents

1. [Introduction to Netlink and libnl](#introduction)
2. [Installation](#installation)
3. [Core Concepts](#core-concepts)
   - [Sockets](#sockets)
   - [Messages](#messages)
   - [Attributes (TLVs)](#attributes)
   - [Caches](#caches)
4. [Error Handling](#error-handling)
5. [Route Subsystem (libnl-route)](#route-subsystem)
   - [Network Links (Interfaces)](#network-links)
   - [Addresses](#addresses)
   - [Routes](#routes)
   - [Neighbours (ARP/NDP)](#neighbours)
   - [Routing Rules](#routing-rules)
   - [Traffic Control (TC)](#traffic-control)
     - [Qdiscs](#qdiscs)
     - [Classes](#classes)
     - [Filters](#filters)
     - [Actions](#actions)
6. [Generic Netlink (libnl-genl)](#generic-netlink)
   - [Family Discovery](#family-discovery)
   - [Building and Sending Messages](#building-genl-messages)
7. [Netfilter (libnl-nf)](#netfilter)
   - [Conntrack](#conntrack)
   - [NFLOG (Logging)](#nflog)
   - [NFQUEUE (Queue)](#nfqueue)
8. [XFRM (libnl-xfrm)](#xfrm)
   - [Security Associations (SA)](#security-associations)
   - [Security Policies (SP)](#security-policies)
   - [Lifetime Configuration](#lifetime-configuration)
   - [Selectors and Templates](#selectors-and-templates)
9. [Advanced Topics](#advanced-topics)
   - [Inline Functions Helpers](#inline-helpers)
   - [Callbacks](#callbacks)
   - [Custom Caches](#custom-caches)
10. [Examples and Snippets](#examples)
11. [Conclusion](#conclusion)

---

## Introduction to Netlink and libnl <a name="introduction"></a>

**Netlink** is a Linux kernel communication interface that allows user‑space processes to exchange data with the kernel. It is the primary method for configuring networking, routing, firewalling, and other system components. Netlink uses a socket‑based protocol (AF_NETLINK) with a binary message format.

**libnl** is the reference C library that provides a convenient API over raw netlink sockets. It handles message construction, parsing, caching, and provides object‑oriented abstractions for various netlink families (route, generic, netfilter, xfrm).

The **nl** shard offers a complete Crystal binding for libnl, both a low‑level FFI (mirroring the C API) and a high‑level, idiomatic Crystal wrapper with automatic resource management and error handling.

---

## Installation <a name="installation"></a>

Add the shard to your `shard.yml`:

```yaml
dependencies:
  nl:
    github: okavatti/nl
    version: ~> 0.1.0
```

Run `shards install`.

### System Dependencies

You need the libnl development packages. On Debian/Ubuntu:

```bash
sudo apt install libnl-3-dev libnl-route-3-dev libnl-genl-3-dev \
                 libnl-nf-3-dev libnl-xfrm-3-dev
```

On Fedora/RHEL:

```bash
sudo dnf install libnl3-devel
```

On Arch

```bash
sudo pacman -S libnl
```

---

## Core Concepts <a name="core-concepts"></a>

All netlink communication revolves around a few fundamental elements.

### Sockets <a name="sockets"></a>

A **socket** is the endpoint for netlink communication. You create a socket, connect it to a protocol family (e.g., `NETLINK_ROUTE`), and then send/receive messages.

High‑level class: `Nl::Socket`.

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)
```

The socket manages the underlying `NL_Sock*` pointer and automatically frees it when garbage‑collected (via `#finalize`).

### Messages <a name="messages"></a>

Netlink messages (`struct nlmsghdr`) contain a header followed by a payload. The payload often consists of attributes (TLVs) and/or family‑specific data.

High‑level class: `Nl::Message`.

```crystal
msg = Nl::Message.new
msg.put_header(0, 0, LibNL::RTM_GETLINK, 0, LibNL::NLM_F_REQUEST | LibNL::NLM_F_DUMP)
```

The `#put_header` method places the header; subsequent attribute methods append data after it.

### Attributes (TLVs) <a name="attributes"></a>

Attributes are the primary way to pass structured data in netlink messages. Each attribute has a type and a length, and can contain integers, strings, nested attributes, etc.

High‑level class: `Nl::Attribute`.

You usually add attributes to a message using methods like `#put_u32`, `#put_string`, etc. When receiving, you find attributes via `LibNL.nlmsg_find_attr` or iterate over nested ones.

```crystal
msg.put_u32(1, 12345_u32)
msg.put_string(2, "hello")
```

### Caches <a name="caches"></a>

A **cache** is a collection of kernel objects (links, routes, addresses, etc.) retrieved via netlink. Caches can be refilled, iterated, and searched.

High‑level class: `Nl::Cache`.

```crystal
link_cache = Nl::Route::Link.cache(sk)
link_cache.each do |obj|
  # obj is a Pointer(NL_Object) – cast to appropriate type
end
```

Convenience methods exist to get specific objects from a cache (e.g., `Link.get(cache, ifindex)`).

---

## Error Handling <a name="error-handling"></a>

All high‑level methods that interact with the kernel raise `Nl::Error` (or a subclass) on failure. The error message is taken from `nl_geterror()`, and the raw error code is available via `#code`.

Common subclasses:

- `Nl::NotFoundError` – when an object is not found.
- `Nl::TcNotAddedError` – when you try to access TC‑specific parameters before calling `#add`.

Example:

```crystal
begin
  route.add(sk)
rescue e : Nl::Error
  puts "Failed to add route: #{e.message} (code: #{e.code})"
end
```

---

## Route Subsystem (libnl-route) <a name="route-subsystem"></a>

The route library provides objects for network interfaces, addresses, routes, neighbours, rules, and traffic control.

### Network Links (Interfaces) <a name="network-links"></a>

Class: `Nl::Route::Link`.

**Retrieving all links:**

```crystal
cache = Nl::Route::Link.cache(sk)
cache.each do |obj|
  link = Nl::Route::Link.new(obj.as(Pointer(LibNLRoute::Rtnl_Link)), owned: false)
  puts "#{link.ifindex}: #{link.name} (MTU: #{link.mtu})"
end
```

**Getting a specific link:**

```crystal
link = Nl::Route::Link.get(cache, 1)  # ifindex 1 (lo)
if link
  puts link.name
end
```

**Creating a VLAN:**

```crystal
vlan = Nl::Route::Link.new
vlan.name = "vlan100"
vlan.ifindex = 0  # kernel assigns
vlan.vlan_set_id(100_u16)
vlan.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)
```

**Creating a bridge:**

```crystal
bridge = Nl::Route::Link.new
bridge.name = "br0"
bridge.bridge_set_ageing_time(300_u32)
bridge.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)
```

**Deleting a link:**

```crystal
link = Nl::Route::Link.get(cache, ifindex)
link.delete(sk) if link
```

### Addresses <a name="addresses"></a>

Class: `Nl::Route::Address`.

**Adding an IP address:**

```crystal
addr = Nl::Route::Address.new
addr.ifindex = 1  # eth0
addr.family = LibNL::AF_INET
addr.prefixlen = 24

# Create the local address
local = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("192.168.1.10", LibNL::AF_INET, pointerof(local))
addr.local = local

addr.add(sk)
```

**Deleting an address:**

```crystal
addr.delete(sk)
```

### Routes <a name="routes"></a>

Class: `Nl::Route::Route`.

**Adding a simple route:**

```crystal
route = Nl::Route::Route.new
route.table = 254_u32
route.scope = 0_u8
route.type = 1_u8

# Destination: 10.0.0.0/8
dst = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("10.0.0.0", LibNL::AF_INET, pointerof(dst))
LibNL.nl_addr_set_prefixlen(dst, 8)
route.dst = dst

# Gateway: 192.168.1.1
gw = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(gw))
nh = Nl::Route::Nexthop.new
nh.gateway = gw
route.add_nexthop(nh)

route.add(sk)
```

**Multipath route:**

```crystal
nh1 = Nl::Route::Nexthop.new
nh1.gateway = gw1
nh1.weight = 1_u8
route.add_nexthop(nh1)

nh2 = Nl::Route::Nexthop.new
nh2.gateway = gw2
nh2.weight = 1_u8
route.add_nexthop(nh2)
```

**Setting metrics:**

```crystal
route.set_metric(RtnlRouteMetric::ROUTE_METRIC_MTU, 1500_u32)
```

### Neighbours (ARP/NDP) <a name="neighbours"></a>

Class: `Nl::Route::Neighbour`.

**Adding a static ARP entry:**

```crystal
neigh = Nl::Route::Neighbour.new
neigh.ifindex = 1
neigh.family = LibNL::AF_INET

# Destination IP
dst = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(dst))
neigh.dst = dst

# Link‑layer address (MAC)
ll = Pointer(LibNL::NL_Addr).null
# For MAC, we need a special address; here we use a binary address.
# For simplicity, we'll parse a dummy string:
LibNL.nl_addr_parse("00:11:22:33:44:55", LibNL::AF_UNSPEC, pointerof(ll))
neigh.lladdr = ll

neigh.state = LibNLRoute::NUD_PERMANENT
neigh.add(sk)
```

### Routing Rules <a name="routing-rules"></a>

Class: `Nl::Route::Rule`.

**Adding a rule to route traffic from a specific source to a table:**

```crystal
rule = Nl::Route::Rule.new
rule.family = LibNL::AF_INET
rule.table = 100_u32
rule.priority = 1000_u32
rule.action = RtnlRuleAction::FR_ACT_TO_TBL

# Source network
src = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("192.168.2.0/24", LibNL::AF_INET, pointerof(src))
rule.src = src

rule.add(sk)
```

### Traffic Control (TC) <a name="traffic-control"></a>

TC objects (qdiscs, classes, filters) are managed under `Nl::Route::TC`.

**Important:** Type‑specific parameters (like `htb_rate`) can only be set **after** the object has been added to the kernel (i.e., after `#add`). The wrapper enforces this by raising `Nl::TcNotAddedError` if you attempt to access them before adding.

#### Qdiscs <a name="qdiscs"></a>

Class: `Nl::Route::TC::Qdisc`.

**Creating an HTB qdisc:**

```crystal
qdisc = Nl::Route::TC::Qdisc.new
qdisc.ifindex = 1
qdisc.parent = 0  # root
qdisc.kind = "htb"

# Parameters are set *before* adding, but they will be stored and applied during the add.
# However, the high‑level wrapper requires you to call #add first, then set parameters.
# So we first add, then set.
qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

qdisc.htb_rate = 1000000_u32
qdisc.htb_ceil = 2000000_u32
```

**Creating a TBF qdisc:**

```crystal
qdisc = Nl::Route::TC::Qdisc.new
qdisc.ifindex = 1
qdisc.parent = 0x10000   # attached to class 1:0
qdisc.kind = "tbf"
qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

qdisc.tbf_rate(1000000_u32, 1024_u32)  # rate, burst
qdisc.tbf_limit = 1000000_u32
```

**Creating an SFQ qdisc:**

```crystal
qdisc = Nl::Route::TC::Qdisc.new
qdisc.ifindex = 1
qdisc.parent = 0x10001
qdisc.kind = "sfq"
qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

qdisc.sfq_quantum = 1514_u32
qdisc.sfq_perturb = 10_u32
```

#### Classes <a name="classes"></a>

Class: `Nl::Route::TC::Class`.

```crystal
cls = Nl::Route::TC::Class.new
cls.ifindex = 1
cls.parent = 0x10000   # root handle (1:0)
cls.handle = 0x10001   # 1:1
cls.kind = "htb"
cls.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

cls.htb_rate = 500000_u32
cls.htb_ceil = 1000000_u32
cls.htb_prio = 1_u8
```

#### Filters <a name="filters"></a>

Class: `Nl::Route::TC::Filter`.

**U32 filter to match IP and assign classid:**

```crystal
filter = Nl::Route::TC::Filter.new
filter.ifindex = 1
filter.parent = 0x10000
filter.kind = "u32"
filter.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

filter.u32_handle = 0x800
filter.u32_classid = 0x10001
# ... additional matching rules would be added via attributes
```

**Basic filter using ematch (extended match):**

```crystal
filter = Nl::Route::TC::Filter.new
filter.ifindex = 1
filter.parent = 0x10000
filter.kind = "basic"
filter.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

filter.basic_classid = 0x10001
# To set ematch, you would construct the ematch structure and pass it.
```

**FW filter (firewall mark):**

```crystal
filter = Nl::Route::TC::Filter.new
filter.ifindex = 1
filter.parent = 0x10000
filter.kind = "fw"
filter.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

filter.fw_classid = 0x10001
filter.fw_mask = 0xffffffff
```

#### Actions <a name="actions"></a>

Actions (mirror, redirect, police) are part of the TC framework. They can be attached to filters. While the high‑level wrapper currently does not provide a dedicated class for actions, you can use the low‑level functions directly.

---

## Generic Netlink (libnl-genl) <a name="generic-netlink"></a>

Generic Netlink is a flexible netlink family used by many kernel subsystems (e.g., nl80211 for Wi‑Fi, nfnetlink for netfilter). The `libnl-genl` bindings provide family discovery and message construction.

### Family Discovery <a name="family-discovery"></a>

You can list all families or look up a specific one.

**List families:**

```crystal
sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_GENERIC)

cache = Nl::Genl.cache(sk)
cache.each do |obj|
  fam = Nl::Genl::Family.new(obj.as(Pointer(LibNLGenl::GenlFamily)), owned: false)
  puts "Name: #{fam.name}, ID: #{fam.id}, Version: #{fam.version}"
  # Multicast groups
  (0...fam.mc_grp_count).each do |i|
    puts "  Group #{i}: #{fam.mc_grp_name(i)} (ID: #{fam.mc_grp_id(i)})"
  end
end
```

**Resolve a family by name:**

```crystal
family = Nl::Genl.get_family(sk, "nl80211")
puts "nl80211 ID: #{family.id}"
```

### Building and Sending Messages <a name="building-genl-messages"></a>

Generic Netlink messages have an extra header (`struct genlmsghdr`) containing a command and version.

**Build a simple request:**

```crystal
msg = Nl::Message.new
# The family object must be known
family = Nl::Genl.get_family(sk, "nlctrl")
# Put the genl header
genl_hdr = LibNLGenl.genlmsg_put(
  msg.to_unsafe,
  0_u32,
  0_u32,
  family.to_unsafe,
  0,
  LibNL::NLM_F_REQUEST,
  LibNLGenl::CTRL_CMD_GETFAMILY,
  1_u8
)
# Add attributes (e.g., family name)
msg.put_string(LibNLGenl::CTRL_ATTR_FAMILY_NAME, "nlctrl")
sk.send_message(msg)
sk.recv_default
```

There are also helpers like `LibNLGenlHelpers.build_message` that simplify the process.

---

## Netfilter (libnl-nf) <a name="netfilter"></a>

The netfilter library handles connection tracking, logging, and queueing.

### Conntrack <a name="conntrack"></a>

Class: `Nl::NF::Conntrack::Entry`.

**Setting up a conntrack entry (skeleton):**

```crystal
ct = Nl::NF::Conntrack::Entry.new
ct.status = LibNLNf::IPS_SEEN_REPLY | LibNLNf::IPS_ASSURED
ct.mark = 0x12345678_u32
ct.timeout = 300_u32

# To set the tuple (original direction), you need to build the nested attributes.
# For brevity, we skip the low‑level construction; see the examples.
```

**Adding/Deleting:**

```crystal
ct.add(sk)
ct.delete(sk)
```

### NFLOG (Logging) <a name="nflog"></a>

NFLOG is used to send packets to user‑space logging daemons. The low‑level functions are available in `LibNLNf`.

### NFQUEUE (Queue) <a name="nfqueue"></a>

NFQUEUE allows user‑space programs to receive packets and make verdicts (accept, drop, etc.).

**Binding to a queue:**

```crystal
queue = Pointer(LibNLNf::NfnlQueue).null
queue = LibNLNf.nfnl_queue_alloc
LibNLNf.nfnl_queue_set_queue_num(queue, 0_u16)
LibNLNf.nfnl_queue_set_copy_mode(queue, LibNLNf::NFQUEUE_COPY_PACKET)
LibNLNf.nfnl_queue_set_copy_range(queue, 65535_u32)
LibNLNf.nfnl_queue_bind(sk.to_unsafe, queue)
```

**Sending a verdict:**

```crystal
LibNLNf.nfnl_queue_verdict(sk.to_unsafe, 0_u16, packet_id, LibNLNf::NF_ACCEPT)
```

---

## XFRM (libnl-xfrm) <a name="xfrm"></a>

XFRM is the Linux IPsec framework. The bindings cover Security Associations (SA), Security Policies (SP), and their components.

### Security Associations (SA) <a name="security-associations"></a>

Class: `Nl::XFrm::SA`.

**Creating an SA:**

```crystal
sa = Nl::XFrm::SA.new
sa.spi = 0x1000_u32
sa.proto = LibNLXfrm::XFRM_PROTO_ESP
sa.family = LibNLXfrm::XFRM_AF_INET
sa.mode = LibNLXfrm::XFRM_MODE_TUNNEL

# Addresses
src = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("10.0.0.1", LibNL::AF_INET, pointerof(src))
dst = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("10.0.0.2", LibNL::AF_INET, pointerof(dst))
sa.saddr = src
sa.daddr = dst

# Algorithms
algo = Pointer(LibNLXfrm::XfrmnlAlgo).null
# ... allocate and set algorithm parameters
sa.algo = algo

sa.add(sk)
```

### Security Policies (SP) <a name="security-policies"></a>

Class: `Nl::XFrm::SP`.

**Adding a policy:**

```crystal
sp = Nl::XFrm::SP.new
sp.dir = LibNLXfrm::XFRM_POLICY_OUT
sp.action = LibNLXfrm::XFRM_POLICY_ALLOW
sp.priority = 100_u32

# Selector (traffic to protect)
sel = LibNLXfrm.xfrmnl_sel_alloc
# ... set addresses, ports, etc.
sp.sel = sel

# Templates (which SA to use)
tmpl = LibNLXfrm.xfrmnl_user_tmpl_alloc
# ... set template parameters
sp.add_user_tmpl(tmpl)

sp.add(sk)
```

### Lifetime Configuration <a name="lifetime-configuration"></a>

Lifetimes (soft/hard byte/packet/time limits) are handled via `LibNLXfrm::XfrmnlLtimeCfg` objects. They can be attached to SAs and SPs.

### Selectors and Templates <a name="selectors-and-templates"></a>

Selectors define which traffic a policy applies to. Templates define which SA to use. Both are separate objects that can be created and set.

---

## Advanced Topics <a name="advanced-topics"></a>

### Inline Functions Helpers <a name="inline-helpers"></a>

Many libnl functions are static inline in the headers and are not exported. The `LibNLHelpers` module provides Crystal implementations for the most common ones:

- `nlmsg_len`, `nlmsg_data`, `nlmsg_attrdata`
- `nla_data`, `nla_len`, `nla_type`
- `nl_addr_alloc_empty`, `nl_addr_build_any`
- And more (see `src/libnl/core/helpers.cr`).

### Callbacks <a name="callbacks"></a>

Netlink receives messages asynchronously. You can set callbacks on a socket to process received messages. The low‑level `nl_cb_*` functions are available. The high‑level `Nl::Socket` provides `#recv_default` which uses the default callback (prints errors). For custom processing, you can allocate a callback handle and set it.

Example (low‑level):

```crystal
cb = LibNL.nl_cb_alloc(LibNL::NlCbKind::NL_CB_DEFAULT)
LibNL.nl_cb_set(cb, LibNL::NlCbType::NL_CB_VALID, LibNL::NlCbKind::NL_CB_CUSTOM,
                ->(sk : Pointer(LibNL::NL_Sock), msg : Pointer(LibNL::NL_Msg), arg : Pointer(Void)) {
                  # Process message
                  0_i32
                }, Pointer(Void).null)
sk = Nl::Socket.new(cb)
```

### Custom Caches <a name="custom-caches"></a>

You can create caches for custom netlink message types using `nl_cache_alloc` and the appropriate cache operations. The high‑level `Nl::Cache` can wrap any cache pointer.

---

## Examples and Snippets <a name="examples"></a>

The `examples/` directory in the source repository contains several complete programs:

- `get_interfaces.cr` – Lists all network interfaces.
- `genl_example.cr` – Lists all Generic Netlink families.
- `add_route.cr` – Adds a static route.

You can run them after building the library.

---

## Conclusion <a name="conclusion"></a>

The **nl** shard gives you (mostly) complete, idiomatic Crystal access to the full power of libnl and the Linux netlink interface. Whether you are managing interfaces, routing, traffic control, netfilter, or IPsec, this library provides both low‑level FFI and a convenient high‑level wrapper.

If you encounter issues or have feature requests, please open an issue on GitHub. Contributions are welcome!

Happy networking with Crystal.
