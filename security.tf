resource "ibm_is_security_group" "vpn" {
  name           = "${var.name}-vpn-group"
  vpc            = data.ibm_is_vpc.vpc.id
  resource_group = data.ibm_resource_group.group.id
}


resource "ibm_is_security_group_rule" "openvpn" {
  group     = ibm_is_security_group.vpn.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 65000
    port_max = 65000
  }
}

resource "ibm_is_security_group_rule" "wireguard" {
  group     = ibm_is_security_group.vpn.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 51280
    port_max = 51280
  }
}

resource "ibm_is_security_group_rule" "ssh_to_self_public_ip" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  remote    = ibm_is_floating_ip.vpn.address
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "additional_all_rules" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "tcp", null) == null && lookup(rule, "udp", null) == null && lookup(rule, "icmp", null) == null
  }
  group      = ibm_is_security_group.vpn.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)
}

resource "ibm_is_security_group" "maintenance" {
  name           = "${var.name}-maintenance-security-group"
  vpc            = data.ibm_is_vpc.vpc.id
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group_rule" "maintenance_ssh_inbound" {
  group     = ibm_is_security_group.maintenance.id
  direction = "inbound"
  remote    = ibm_is_security_group.vpn.id
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "additional_tcp_rules" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "tcp", null) != null
  }
  group      = ibm_is_security_group.vpn.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)

  tcp {
    port_min = each.value.tcp.port_min
    port_max = each.value.tcp.port_max
  }
}

resource "ibm_is_security_group_rule" "additional_udp_rules" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "udp", null) != null
  }
  group      = ibm_is_security_group.vpn.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)

  udp {
    port_min = each.value.udp.port_min
    port_max = each.value.udp.port_max
  }
}

resource "ibm_is_security_group_rule" "additional_icmp_rules" {
  for_each = {
    for rule in var.security_group_rules : rule.name => rule if lookup(rule, "icmp", null) != null
  }
  group      = ibm_is_security_group.vpn.id
  direction  = each.value.direction
  remote     = each.value.remote
  ip_version = lookup(each.value, "ip_version", null)

  icmp {
    type = each.value.icmp.type
    code = lookup(each.value.icmp, "code", null) == null ? null : each.value.icmp.code
  }
}