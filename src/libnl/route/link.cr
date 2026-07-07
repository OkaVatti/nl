# src/libnl/route/link.cr
#
# Network link (interface) management – allocation, cache, getters/setters,
# and link‑type‑specific operations (bridge, bond, vlan, vxlan, etc.).

@[Link("nl-route-3")]
lib LibNLRoute
  # ---- Allocation / Free / Reference counting ---------------------------

  fun rtnl_link_alloc = rtnl_link_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_alloc_cache = rtnl_link_alloc_cache(
    sk : Pointer(LibNL::NL_Sock),
    family : Int32,
    result : Pointer(Pointer(LibNL::NL_Cache)),
  ) : Int32
  fun rtnl_link_get = rtnl_link_get(cache : Pointer(LibNL::NL_Cache), ifindex : Int32) : Pointer(Rtnl_Link)
  fun rtnl_link_get_by_name = rtnl_link_get_by_name(cache : Pointer(LibNL::NL_Cache), name : LibC::Char*) : Pointer(Rtnl_Link)
  fun rtnl_link_put = rtnl_link_put(link : Pointer(Rtnl_Link)) : Void

  # ---- Link addition / deletion / change --------------------------------

  fun rtnl_link_add = rtnl_link_add(sk : Pointer(LibNL::NL_Sock), link : Pointer(Rtnl_Link), flags : Int32) : Int32
  fun rtnl_link_build_add_request = rtnl_link_build_add_request(
    link : Pointer(Rtnl_Link),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_link_delete = rtnl_link_delete(sk : Pointer(LibNL::NL_Sock), link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_build_delete_request = rtnl_link_build_delete_request(
    link : Pointer(Rtnl_Link),
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32
  fun rtnl_link_change = rtnl_link_change(
    sk : Pointer(LibNL::NL_Sock),
    link : Pointer(Rtnl_Link),
    changes : Pointer(Rtnl_Link),
    flags : Int32,
  ) : Int32
  fun rtnl_link_build_change_request = rtnl_link_build_change_request(
    link : Pointer(Rtnl_Link),
    changes : Pointer(Rtnl_Link),
    flags : Int32,
    result : Pointer(Pointer(LibNL::NL_Msg)),
  ) : Int32

  # ---- Link information (parsing / filling) -----------------------------

  fun rtnl_link_info_parse = rtnl_link_info_parse(link : Pointer(Rtnl_Link), tb : Pointer(Pointer(LibNL::NL_Attr))) : Int32
  fun rtnl_link_fill_info = rtnl_link_fill_info(msg : Pointer(LibNL::NL_Msg), link : Pointer(Rtnl_Link)) : Int32

  # ---- Basic attributes (getters / setters) -----------------------------

  fun rtnl_link_set_name = rtnl_link_set_name(link : Pointer(Rtnl_Link), name : LibC::Char*) : Int32
  fun rtnl_link_get_name = rtnl_link_get_name(link : Pointer(Rtnl_Link)) : LibC::Char*
  fun rtnl_link_set_ifindex = rtnl_link_set_ifindex(link : Pointer(Rtnl_Link), ifindex : Int32) : Void
  fun rtnl_link_get_ifindex = rtnl_link_get_ifindex(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_set_family = rtnl_link_set_family(link : Pointer(Rtnl_Link), family : Int32) : Void
  fun rtnl_link_get_family = rtnl_link_get_family(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_set_arptype = rtnl_link_set_arptype(link : Pointer(Rtnl_Link), arptype : UInt16) : Void
  fun rtnl_link_get_arptype = rtnl_link_get_arptype(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_set_mtu = rtnl_link_set_mtu(link : Pointer(Rtnl_Link), mtu : UInt32) : Void
  fun rtnl_link_get_mtu = rtnl_link_get_mtu(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_set_txqlen = rtnl_link_set_txqlen(link : Pointer(Rtnl_Link), txqlen : UInt32) : Void
  fun rtnl_link_get_txqlen = rtnl_link_get_txqlen(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_set_weight = rtnl_link_set_weight(link : Pointer(Rtnl_Link), weight : UInt32) : Void
  fun rtnl_link_get_weight = rtnl_link_get_weight(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_set_addr = rtnl_link_set_addr(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_get_addr = rtnl_link_get_addr(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_set_broadcast = rtnl_link_set_broadcast(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_get_broadcast = rtnl_link_get_broadcast(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_set_flags = rtnl_link_set_flags(link : Pointer(Rtnl_Link), flags : UInt32) : Void
  fun rtnl_link_unset_flags = rtnl_link_unset_flags(link : Pointer(Rtnl_Link), flags : UInt32) : Void
  fun rtnl_link_get_flags = rtnl_link_get_flags(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_set_state = rtnl_link_set_state(link : Pointer(Rtnl_Link), state : UInt8) : Void
  fun rtnl_link_get_state = rtnl_link_get_state(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_get_operstate = rtnl_link_get_operstate(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_set_link = rtnl_link_set_link(link : Pointer(Rtnl_Link), ifindex : Int32) : Void
  fun rtnl_link_get_link = rtnl_link_get_link(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_set_master = rtnl_link_set_master(link : Pointer(Rtnl_Link), ifindex : Int32) : Void
  fun rtnl_link_get_master = rtnl_link_get_master(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_set_carrier = rtnl_link_set_carrier(link : Pointer(Rtnl_Link), status : UInt8) : Void
  fun rtnl_link_get_carrier = rtnl_link_get_carrier(link : Pointer(Rtnl_Link)) : UInt8

  # ---- Link statistics ---------------------------------------------------

  fun rtnl_link_get_stat = rtnl_link_get_stat(link : Pointer(Rtnl_Link), id : Int32) : UInt64
  fun rtnl_link_set_stat = rtnl_link_set_stat(link : Pointer(Rtnl_Link), id : Int32, value : UInt64) : Void

  # ---- Link type detection -----------------------------------------------

  fun rtnl_link_is_vlan = rtnl_link_is_vlan(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_bridge = rtnl_link_is_bridge(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_bond = rtnl_link_is_bond(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_vxlan = rtnl_link_is_vxlan(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_macvlan = rtnl_link_is_macvlan(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_veth = rtnl_link_is_veth(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_dummy = rtnl_link_is_dummy(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_can = rtnl_link_is_can(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_sit = rtnl_link_is_sit(link : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_is_ip6_tnl = rtnl_link_is_ip6_tnl(link : Pointer(Rtnl_Link)) : Int32

  # ======================================================================
  # Link‑Type‑Specific Operations (from various headers)
  # ======================================================================

  # ---- VLAN specific -----------------------------------------------------
  # (from <netlink/route/link/vlan.h>)

  fun rtnl_link_vlan_alloc = rtnl_link_vlan_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_vlan_add = rtnl_link_vlan_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32
  fun rtnl_link_vlan_set_id = rtnl_link_vlan_set_id(link : Pointer(Rtnl_Link), id : UInt16) : Int32
  fun rtnl_link_vlan_get_id = rtnl_link_vlan_get_id(link : Pointer(Rtnl_Link)) : UInt16

  # Extra VLAN setters (from link_extra)
  fun rtnl_link_vlan_set_flags = rtnl_link_vlan_set_flags(link : Pointer(Rtnl_Link), flags : UInt32) : Int32
  fun rtnl_link_vlan_get_flags = rtnl_link_vlan_get_flags(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_vlan_set_ingress_map = rtnl_link_vlan_set_ingress_map(link : Pointer(Rtnl_Link), from : UInt32, to : UInt32) : Int32
  fun rtnl_link_vlan_set_egress_map = rtnl_link_vlan_set_egress_map(link : Pointer(Rtnl_Link), from : UInt32, to : UInt32) : Int32
  fun rtnl_link_vlan_set_ingress_qos_mapping = rtnl_link_vlan_set_ingress_qos_mapping(link : Pointer(Rtnl_Link), from : UInt32, to : UInt32) : Int32
  fun rtnl_link_vlan_get_ingress_qos_mapping = rtnl_link_vlan_get_ingress_qos_mapping(link : Pointer(Rtnl_Link), from : UInt32, to : UInt32) : Int32
  fun rtnl_link_vlan_set_egress_qos_mapping = rtnl_link_vlan_set_egress_qos_mapping(link : Pointer(Rtnl_Link), from : UInt32, to : UInt32) : Int32
  fun rtnl_link_vlan_get_egress_qos_mapping = rtnl_link_vlan_get_egress_qos_mapping(link : Pointer(Rtnl_Link), from : UInt32, to : UInt32) : Int32
  fun rtnl_link_vlan_set_protocol = rtnl_link_vlan_set_protocol(link : Pointer(Rtnl_Link), proto : UInt16) : Int32
  fun rtnl_link_vlan_get_protocol = rtnl_link_vlan_get_protocol(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_vlan_set_reorder_hdr = rtnl_link_vlan_set_reorder_hdr(link : Pointer(Rtnl_Link), reorder : UInt8) : Int32
  fun rtnl_link_vlan_get_reorder_hdr = rtnl_link_vlan_get_reorder_hdr(link : Pointer(Rtnl_Link)) : UInt8

  # ---- Bridge specific ---------------------------------------------------
  # (from <netlink/route/link/bridge.h>)

  fun rtnl_link_bridge_alloc = rtnl_link_bridge_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_bridge_add = rtnl_link_bridge_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # Extra bridge setters
  fun rtnl_link_bridge_set_ageing_time = rtnl_link_bridge_set_ageing_time(link : Pointer(Rtnl_Link), ageing_time : UInt32) : Int32
  fun rtnl_link_bridge_get_ageing_time = rtnl_link_bridge_get_ageing_time(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_priority = rtnl_link_bridge_set_priority(link : Pointer(Rtnl_Link), priority : UInt16) : Int32
  fun rtnl_link_bridge_get_priority = rtnl_link_bridge_get_priority(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_bridge_set_forward_delay = rtnl_link_bridge_set_forward_delay(link : Pointer(Rtnl_Link), delay : UInt32) : Int32
  fun rtnl_link_bridge_get_forward_delay = rtnl_link_bridge_get_forward_delay(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_hello_time = rtnl_link_bridge_set_hello_time(link : Pointer(Rtnl_Link), time : UInt32) : Int32
  fun rtnl_link_bridge_get_hello_time = rtnl_link_bridge_get_hello_time(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_max_age = rtnl_link_bridge_set_max_age(link : Pointer(Rtnl_Link), age : UInt32) : Int32
  fun rtnl_link_bridge_get_max_age = rtnl_link_bridge_get_max_age(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_stp_state = rtnl_link_bridge_set_stp_state(link : Pointer(Rtnl_Link), state : UInt32) : Int32
  fun rtnl_link_bridge_get_stp_state = rtnl_link_bridge_get_stp_state(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_vlan_filtering = rtnl_link_bridge_set_vlan_filtering(link : Pointer(Rtnl_Link), enable : UInt32) : Int32
  fun rtnl_link_bridge_get_vlan_filtering = rtnl_link_bridge_get_vlan_filtering(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_vlan_protocol = rtnl_link_bridge_set_vlan_protocol(link : Pointer(Rtnl_Link), proto : UInt16) : Int32
  fun rtnl_link_bridge_get_vlan_protocol = rtnl_link_bridge_get_vlan_protocol(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_bridge_set_group_fwd_mask = rtnl_link_bridge_set_group_fwd_mask(link : Pointer(Rtnl_Link), mask : UInt16) : Int32
  fun rtnl_link_bridge_get_group_fwd_mask = rtnl_link_bridge_get_group_fwd_mask(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_bridge_set_cost = rtnl_link_bridge_set_cost(link : Pointer(Rtnl_Link), cost : UInt32) : Int32
  fun rtnl_link_bridge_get_cost = rtnl_link_bridge_get_cost(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bridge_set_gc_interval = rtnl_link_bridge_set_gc_interval(link : Pointer(Rtnl_Link), time : UInt32) : Int32
  fun rtnl_link_bridge_get_gc_interval = rtnl_link_bridge_get_gc_interval(link : Pointer(Rtnl_Link)) : UInt32

  # ---- Bond specific -----------------------------------------------------
  # (from <netlink/route/link/bond.h>)

  fun rtnl_link_bond_alloc = rtnl_link_bond_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_bond_add = rtnl_link_bond_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # Extra bond setters
  fun rtnl_link_bond_set_mode = rtnl_link_bond_set_mode(link : Pointer(Rtnl_Link), mode : UInt8) : Int32
  fun rtnl_link_bond_get_mode = rtnl_link_bond_get_mode(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_active_slave = rtnl_link_bond_set_active_slave(link : Pointer(Rtnl_Link), ifindex : UInt32) : Int32
  fun rtnl_link_bond_get_active_slave = rtnl_link_bond_get_active_slave(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_miimon = rtnl_link_bond_set_miimon(link : Pointer(Rtnl_Link), miimon : UInt32) : Int32
  fun rtnl_link_bond_get_miimon = rtnl_link_bond_get_miimon(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_updelay = rtnl_link_bond_set_updelay(link : Pointer(Rtnl_Link), delay : UInt32) : Int32
  fun rtnl_link_bond_get_updelay = rtnl_link_bond_get_updelay(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_downdelay = rtnl_link_bond_set_downdelay(link : Pointer(Rtnl_Link), delay : UInt32) : Int32
  fun rtnl_link_bond_get_downdelay = rtnl_link_bond_get_downdelay(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_use_carrier = rtnl_link_bond_set_use_carrier(link : Pointer(Rtnl_Link), use : UInt8) : Int32
  fun rtnl_link_bond_get_use_carrier = rtnl_link_bond_get_use_carrier(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_arp_interval = rtnl_link_bond_set_arp_interval(link : Pointer(Rtnl_Link), interval : UInt32) : Int32
  fun rtnl_link_bond_get_arp_interval = rtnl_link_bond_get_arp_interval(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_arp_ip_target = rtnl_link_bond_set_arp_ip_target(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr), idx : UInt32) : Int32
  fun rtnl_link_bond_get_arp_ip_target = rtnl_link_bond_get_arp_ip_target(link : Pointer(Rtnl_Link), idx : UInt32) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_bond_set_arp_validate = rtnl_link_bond_set_arp_validate(link : Pointer(Rtnl_Link), validate : UInt32) : Int32
  fun rtnl_link_bond_get_arp_validate = rtnl_link_bond_get_arp_validate(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_arp_all_targets = rtnl_link_bond_set_arp_all_targets(link : Pointer(Rtnl_Link), all : UInt32) : Int32
  fun rtnl_link_bond_get_arp_all_targets = rtnl_link_bond_get_arp_all_targets(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_primary = rtnl_link_bond_set_primary(link : Pointer(Rtnl_Link), ifindex : UInt32) : Int32
  fun rtnl_link_bond_get_primary = rtnl_link_bond_get_primary(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_primary_reselect = rtnl_link_bond_set_primary_reselect(link : Pointer(Rtnl_Link), reselect : UInt8) : Int32
  fun rtnl_link_bond_get_primary_reselect = rtnl_link_bond_get_primary_reselect(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_fail_over_mac = rtnl_link_bond_set_fail_over_mac(link : Pointer(Rtnl_Link), mode : UInt8) : Int32
  fun rtnl_link_bond_get_fail_over_mac = rtnl_link_bond_get_fail_over_mac(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_xmit_hash_policy = rtnl_link_bond_set_xmit_hash_policy(link : Pointer(Rtnl_Link), policy : UInt8) : Int32
  fun rtnl_link_bond_get_xmit_hash_policy = rtnl_link_bond_get_xmit_hash_policy(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_resend_igmp = rtnl_link_bond_set_resend_igmp(link : Pointer(Rtnl_Link), count : UInt32) : Int32
  fun rtnl_link_bond_get_resend_igmp = rtnl_link_bond_get_resend_igmp(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_num_peer_notif = rtnl_link_bond_set_num_peer_notif(link : Pointer(Rtnl_Link), count : UInt32) : Int32
  fun rtnl_link_bond_get_num_peer_notif = rtnl_link_bond_get_num_peer_notif(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_all_slaves_active = rtnl_link_bond_set_all_slaves_active(link : Pointer(Rtnl_Link), active : UInt8) : Int32
  fun rtnl_link_bond_get_all_slaves_active = rtnl_link_bond_get_all_slaves_active(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_min_links = rtnl_link_bond_set_min_links(link : Pointer(Rtnl_Link), min : UInt32) : Int32
  fun rtnl_link_bond_get_min_links = rtnl_link_bond_get_min_links(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_lp_interval = rtnl_link_bond_set_lp_interval(link : Pointer(Rtnl_Link), interval : UInt32) : Int32
  fun rtnl_link_bond_get_lp_interval = rtnl_link_bond_get_lp_interval(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_bond_set_tlb_dynamic_lb = rtnl_link_bond_set_tlb_dynamic_lb(link : Pointer(Rtnl_Link), dynamic : UInt8) : Int32
  fun rtnl_link_bond_get_tlb_dynamic_lb = rtnl_link_bond_get_tlb_dynamic_lb(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_bond_set_ad_actor_system = rtnl_link_bond_set_ad_actor_system(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_bond_get_ad_actor_system = rtnl_link_bond_get_ad_actor_system(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_bond_set_ad_actor_system_priority = rtnl_link_bond_set_ad_actor_system_priority(link : Pointer(Rtnl_Link), priority : UInt16) : Int32
  fun rtnl_link_bond_get_ad_actor_system_priority = rtnl_link_bond_get_ad_actor_system_priority(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_bond_set_ad_user_port_key = rtnl_link_bond_set_ad_user_port_key(link : Pointer(Rtnl_Link), key : UInt16) : Int32
  fun rtnl_link_bond_get_ad_user_port_key = rtnl_link_bond_get_ad_user_port_key(link : Pointer(Rtnl_Link)) : UInt16

  # ---- VXLAN specific ----------------------------------------------------
  # (from <netlink/route/link/vxlan.h>)

  fun rtnl_link_vxlan_alloc = rtnl_link_vxlan_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_vxlan_add = rtnl_link_vxlan_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # Extra VXLAN setters
  fun rtnl_link_vxlan_set_vni = rtnl_link_vxlan_set_vni(link : Pointer(Rtnl_Link), vni : UInt32) : Int32
  fun rtnl_link_vxlan_get_vni = rtnl_link_vxlan_get_vni(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_vxlan_set_group = rtnl_link_vxlan_set_group(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_vxlan_get_group = rtnl_link_vxlan_get_group(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_vxlan_set_remote = rtnl_link_vxlan_set_remote(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_vxlan_get_remote = rtnl_link_vxlan_get_remote(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_vxlan_set_ttl = rtnl_link_vxlan_set_ttl(link : Pointer(Rtnl_Link), ttl : UInt8) : Int32
  fun rtnl_link_vxlan_get_ttl = rtnl_link_vxlan_get_ttl(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_tos = rtnl_link_vxlan_set_tos(link : Pointer(Rtnl_Link), tos : UInt8) : Int32
  fun rtnl_link_vxlan_get_tos = rtnl_link_vxlan_get_tos(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_learning = rtnl_link_vxlan_set_learning(link : Pointer(Rtnl_Link), learning : UInt8) : Int32
  fun rtnl_link_vxlan_get_learning = rtnl_link_vxlan_get_learning(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_ageing = rtnl_link_vxlan_set_ageing(link : Pointer(Rtnl_Link), ageing : UInt32) : Int32
  fun rtnl_link_vxlan_get_ageing = rtnl_link_vxlan_get_ageing(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_vxlan_set_limit = rtnl_link_vxlan_set_limit(link : Pointer(Rtnl_Link), limit : UInt32) : Int32
  fun rtnl_link_vxlan_get_limit = rtnl_link_vxlan_get_limit(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_vxlan_set_port = rtnl_link_vxlan_set_port(link : Pointer(Rtnl_Link), port : UInt16) : Int32
  fun rtnl_link_vxlan_get_port = rtnl_link_vxlan_get_port(link : Pointer(Rtnl_Link)) : UInt16
  fun rtnl_link_vxlan_set_port_range = rtnl_link_vxlan_set_port_range(link : Pointer(Rtnl_Link), low : UInt16, high : UInt16) : Int32
  fun rtnl_link_vxlan_get_port_range = rtnl_link_vxlan_get_port_range(link : Pointer(Rtnl_Link), low : UInt16, high : UInt16) : Int32
  fun rtnl_link_vxlan_set_proxy = rtnl_link_vxlan_set_proxy(link : Pointer(Rtnl_Link), proxy : UInt8) : Int32
  fun rtnl_link_vxlan_get_proxy = rtnl_link_vxlan_get_proxy(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_rsc = rtnl_link_vxlan_set_rsc(link : Pointer(Rtnl_Link), rsc : UInt8) : Int32
  fun rtnl_link_vxlan_get_rsc = rtnl_link_vxlan_get_rsc(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_l2miss = rtnl_link_vxlan_set_l2miss(link : Pointer(Rtnl_Link), miss : UInt8) : Int32
  fun rtnl_link_vxlan_get_l2miss = rtnl_link_vxlan_get_l2miss(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_l3miss = rtnl_link_vxlan_set_l3miss(link : Pointer(Rtnl_Link), miss : UInt8) : Int32
  fun rtnl_link_vxlan_get_l3miss = rtnl_link_vxlan_get_l3miss(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_df = rtnl_link_vxlan_set_df(link : Pointer(Rtnl_Link), df : UInt8) : Int32
  fun rtnl_link_vxlan_get_df = rtnl_link_vxlan_get_df(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_vxlan_set_id = rtnl_link_vxlan_set_id(link : Pointer(Rtnl_Link), id : UInt32) : Int32 # alias for set_vni
  fun rtnl_link_vxlan_get_id = rtnl_link_vxlan_get_id(link : Pointer(Rtnl_Link)) : UInt32             # alias for get_vni

  # ---- MACVLAN specific --------------------------------------------------
  # (from <netlink/route/link/macvlan.h>)

  fun rtnl_link_macvlan_alloc = rtnl_link_macvlan_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_macvlan_add = rtnl_link_macvlan_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # Extra MACVLAN setters
  fun rtnl_link_macvlan_set_mode = rtnl_link_macvlan_set_mode(link : Pointer(Rtnl_Link), mode : UInt32) : Int32
  fun rtnl_link_macvlan_get_mode = rtnl_link_macvlan_get_mode(link : Pointer(Rtnl_Link)) : UInt32
  fun rtnl_link_macvlan_set_flags = rtnl_link_macvlan_set_flags(link : Pointer(Rtnl_Link), flags : UInt32) : Int32
  fun rtnl_link_macvlan_get_flags = rtnl_link_macvlan_get_flags(link : Pointer(Rtnl_Link)) : UInt32

  # ---- VETH specific -----------------------------------------------------
  # (from <netlink/route/link/veth.h>)

  fun rtnl_link_veth_alloc = rtnl_link_veth_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_veth_add = rtnl_link_veth_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*, peer : LibC::Char*) : Int32

  # Extra VETH setters
  fun rtnl_link_veth_set_peer = rtnl_link_veth_set_peer(link : Pointer(Rtnl_Link), peer : Pointer(Rtnl_Link)) : Int32
  fun rtnl_link_veth_get_peer = rtnl_link_veth_get_peer(link : Pointer(Rtnl_Link)) : Pointer(Rtnl_Link)
  fun rtnl_link_veth_set_peer_name = rtnl_link_veth_set_peer_name(link : Pointer(Rtnl_Link), name : LibC::Char*) : Int32

  # ---- Dummy specific ----------------------------------------------------
  # (from <netlink/route/link/dummy.h>)

  fun rtnl_link_dummy_alloc = rtnl_link_dummy_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_dummy_add = rtnl_link_dummy_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # ---- CAN specific ------------------------------------------------------
  # (from <netlink/route/link/can.h>)

  fun rtnl_link_can_alloc = rtnl_link_can_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_can_add = rtnl_link_can_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # ---- SIT (IPv6‑in‑IPv4 tunnel) specific --------------------------------
  # (from <netlink/route/link/sit.h>)

  fun rtnl_link_sit_alloc = rtnl_link_sit_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_sit_add = rtnl_link_sit_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # Extra SIT setters
  fun rtnl_link_sit_set_local = rtnl_link_sit_set_local(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_sit_get_local = rtnl_link_sit_get_local(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_sit_set_remote = rtnl_link_sit_set_remote(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_sit_get_remote = rtnl_link_sit_get_remote(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_sit_set_ttl = rtnl_link_sit_set_ttl(link : Pointer(Rtnl_Link), ttl : UInt8) : Int32
  fun rtnl_link_sit_get_ttl = rtnl_link_sit_get_ttl(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_sit_set_tos = rtnl_link_sit_set_tos(link : Pointer(Rtnl_Link), tos : UInt8) : Int32
  fun rtnl_link_sit_get_tos = rtnl_link_sit_get_tos(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_sit_set_link = rtnl_link_sit_set_link(link : Pointer(Rtnl_Link), ifindex : Int32) : Int32
  fun rtnl_link_sit_get_link = rtnl_link_sit_get_link(link : Pointer(Rtnl_Link)) : Int32

  # ---- IP6TNL (IPv6‑in‑IPv6 tunnel) specific -----------------------------
  # (from <netlink/route/link/ip6tnl.h>)

  fun rtnl_link_ip6_tnl_alloc = rtnl_link_ip6_tnl_alloc : Pointer(Rtnl_Link)
  fun rtnl_link_ip6_tnl_add = rtnl_link_ip6_tnl_add(sk : Pointer(LibNL::NL_Sock), name : LibC::Char*) : Int32

  # Extra IP6TNL setters
  fun rtnl_link_ip6_tnl_set_local = rtnl_link_ip6_tnl_set_local(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_ip6_tnl_get_local = rtnl_link_ip6_tnl_get_local(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_ip6_tnl_set_remote = rtnl_link_ip6_tnl_set_remote(link : Pointer(Rtnl_Link), addr : Pointer(LibNL::NL_Addr)) : Int32
  fun rtnl_link_ip6_tnl_get_remote = rtnl_link_ip6_tnl_get_remote(link : Pointer(Rtnl_Link)) : Pointer(LibNL::NL_Addr)
  fun rtnl_link_ip6_tnl_set_ttl = rtnl_link_ip6_tnl_set_ttl(link : Pointer(Rtnl_Link), ttl : UInt8) : Int32
  fun rtnl_link_ip6_tnl_get_ttl = rtnl_link_ip6_tnl_get_ttl(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_ip6_tnl_set_tos = rtnl_link_ip6_tnl_set_tos(link : Pointer(Rtnl_Link), tos : UInt8) : Int32
  fun rtnl_link_ip6_tnl_get_tos = rtnl_link_ip6_tnl_get_tos(link : Pointer(Rtnl_Link)) : UInt8
  fun rtnl_link_ip6_tnl_set_link = rtnl_link_ip6_tnl_set_link(link : Pointer(Rtnl_Link), ifindex : Int32) : Int32
  fun rtnl_link_ip6_tnl_get_link = rtnl_link_ip6_tnl_get_link(link : Pointer(Rtnl_Link)) : Int32
end
