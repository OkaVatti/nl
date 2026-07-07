# nl – Crystal bindings for libnl (netlink)

Complete, production‑ready Crystal bindings for the **libnl** suite (core, route, generic netlink, netfilter, xfrm), providing full access to the Linux netlink interface.

---

## Features

- **Full coverage** – All major libnl libraries are bound:
  - `libnl-3` (core socket, message, attributes, caches, objects)
  - `libnl-route-3` (links, addresses, routes, neighbours, rules, traffic control)
  - `libnl-genl-3` (generic netlink family discovery and messaging)
  - `libnl-nf-3` (netfilter conntrack, logging, queue)
  - `libnl-xfrm-3` (IPsec security associations, policies, lifetimes)
- **High‑level wrapper** – Idiomatic Crystal classes (`Socket`, `Message`, `Link`, `Route`, `Qdisc`, `Family`, etc.) with error handling.
- **Low‑level FFI** – Direct access to all libnl functions, constants, and inline helpers.
- **Cache management** – Easy retrieval of kernel state (links, addresses, routes, etc.).
- **Traffic Control** – Full support for qdiscs, classes, filters, and actions (HTB, TBF, SFQ, RED, HFSC, FQ_CODEL, NETEM, U32, Basic, FW, etc.).
- **Generic Netlink** – Resolve families, discover operations and multicast groups, build and send messages.
- **Netfilter** – Manage conntrack entries, configure NFLOG and NFQUEUE, send verdicts.
- **XFRM** – Create, update, and delete Security Associations and Policies.
- **Production ready** – All methods raise descriptive errors; reference counting is handled automatically.

---

## Installation

Add the shard to your `shard.yml`:

```yaml
dependencies:
  nl:
    github: okavatti/nl
    version: ~> 0.1.0
```

Then run:

```bash
shards install
```

### System dependencies

You must have **libnl‑3** and its sub‑libraries installed on your system.

On Debian/Ubuntu:

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

## Usage

All high‑level classes are inside the `Nl` module. Low‑level FFI is in the `LibNL`, `LibNLRoute`, `LibNLGenl`, `LibNLNf`, and `LibNLXfrm` modules.

### 1. Basic socket and message

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

msg = Nl::Message.new
msg.put_header(0, 0, LibNL::RTM_GETLINK, 0, LibNL::NLM_F_REQUEST | LibNL::NLM_F_DUMP)

sk.send_message(msg)
sk.recv_default
```

### 2. List network interfaces

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

cache = Nl::Route::Link.cache(sk)
cache.each do |obj|
  link = Nl::Route::Link.new(obj.as(Pointer(LibNLRoute::Rtnl_Link)), owned: false)
  puts "Interface #{link.ifindex}: #{link.name} (MTU: #{link.mtu})"
end
```

### 3. Add a VLAN interface

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

vlan = Nl::Route::Link.new
vlan.name = "vlan100"
vlan.ifindex = 0              # kernel will assign
vlan.vlan_set_id(100_u16)

# Set link to the physical interface (e.g., eth0) – you may need to set master, etc.
# For simplicity we add without extra flags.
vlan.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)
```

### 4. Add a route

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

# Create destination address (10.0.0.0/8)
dst = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("10.0.0.0", LibNL::AF_INET, pointerof(dst))
LibNL.nl_addr_set_prefixlen(dst, 8)

route = Nl::Route::Route.new
route.dst = dst
route.table = 254_u32  # main table
route.scope = 0_u8     # RT_SCOPE_UNIVERSE
route.type = 1_u8      # RTN_UNICAST

# Add nexthop via gateway 192.168.1.1
gw = Pointer(LibNL::NL_Addr).null
LibNL.nl_addr_parse("192.168.1.1", LibNL::AF_INET, pointerof(gw))

nh = Nl::Route::Nexthop.new
nh.gateway = gw
route.add_nexthop(nh)

route.add(sk)
```

### 5. Traffic Control – HTB qdisc and class

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_ROUTE)

qdisc = Nl::Route::TC::Qdisc.new
qdisc.ifindex = 1   # eth0
qdisc.parent = 0    # root
qdisc.kind = "htb"

# Set HTB parameters (must be set *before* adding)
qdisc.htb_rate = 1000000   # 1 Mbps
qdisc.htb_ceil = 2000000   # 2 Mbps peak

qdisc.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)

# Add a class under the qdisc
cls = Nl::Route::TC::Class.new
cls.ifindex = 1
cls.parent = 0x10000   # root handle (1:0)
cls.handle = 0x10001   # 1:1
cls.kind = "htb"
cls.htb_rate = 500000
cls.htb_ceil = 1000000
cls.add(sk, LibNL::NLM_F_CREATE | LibNL::NLM_F_EXCL)
```

### 6. Generic Netlink – list families

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_GENERIC)

cache = Nl::Genl.cache(sk)
cache.each do |obj|
  fam = Nl::Genl::Family.new(obj.as(Pointer(LibNLGenl::GenlFamily)), owned: false)
  puts "Family: #{fam.name} (ID: #{fam.id}, version: #{fam.version})"
end
```

### 7. Netfilter – add conntrack entry (example)

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_NETFILTER)

ct = Nl::NF::Conntrack::Entry.new
ct.mark = 0x1234_u32
ct.timeout = 300_u32
# ... set tuple (source/dest IP, ports, etc.) – omitted for brevity
ct.add(sk)
```

### 8. XFRM – create a Security Association

```crystal
require "nl"

sk = Nl::Socket.new
sk.connect(LibNL::NETLINK_XFRM)

sa = Nl::XFrm::SA.new
sa.spi = 0x1000_u32
sa.proto = LibNLXfrm::XFRM_PROTO_ESP
sa.family = LibNLXfrm::XFRM_AF_INET
sa.mode = LibNLXfrm::XFRM_MODE_TUNNEL
# ... set addresses, algorithms, etc.
sa.add(sk)
```

---

## API Documentation

Full API reference is generated with `crystal docs`. After installing, run:

```bash
crystal docs --project-name=nl --project-version=0.1.0 --output=./docs -s -p -t --error-trace --format=html
```

Then open `docs/index.html` in your browser.

The documentation covers all high‑level classes (`Nl::Socket`, `Nl::Route::Link`, `Nl::Route::TC::Qdisc`, `Nl::Genl::Family`, etc.) and their methods.

---

## Development

### Running tests

```bash
# simply
crystal spec

# or more verbosely
crystal spec ./spec/ --error-trace
```

> **Note:** _Some_ tests require **root** privileges (e.g., for connecting to `NETLINK_ROUTE`). They are gracefully skipped if not available.

### Building the library

```bash
crystal build ./src/nl.cr --release --error-trace --output ./bin/nl
```

### Using the low‑level FFI

All low‑level functions are available under the `LibNL`, `LibNLRoute`, `LibNLGenl`, `LibNLNf`, and `LibNLXfrm` modules. Their signatures match the C headers exactly.

Inline functions (like `nlmsg_len`, `nla_data`) are provided as Crystal helpers in `LibNLHelpers`.

---

## Project Structure

```
.
├── src/
│   ├── libnl/          # Low‑level FFI bindings (core, route, genl, nf, xfrm)
│   ├── nl/             # High‑level wrapper (core, route, genl, nf, xfrm)
│   └── nl.cr           # Main entry point
├── spec/               # Full test suite
├── examples/           # Example programs
├── docs/               # Documentation (generated)
├── shard.yml           # Standard `shard.yml` for the library
├── README.md           # Standard README For Crystal Projects
└── GUIDE.md            # README but more detailed
```

---

## Contributing

Bug reports and pull requests are welcome. Please ensure tests pass and add new tests for any added functionality.

---

## License

The project is available as open source under the terms of the [MIT License](LICENSE).

---

## Acknowledgements

- [libnl](https://github.com/thom311/libnl) – the underlying C library.
- Crystal language and its community.

---

**Happy networking with Crystal!**
