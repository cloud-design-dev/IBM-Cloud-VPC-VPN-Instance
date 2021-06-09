# output "vpc_subnets" {
#   value = data.ibm_is_vpc.vpc.subnets
# }

output "vpn_instance_id" {
  value       = ibm_is_instance.vpn.id
  description = "ID of the VPN virtual server instance"
}

output "vpn_public_ip" {
  value       = ibm_is_floating_ip.vpn.address
  description = "Public IP address of the VPN server."
}

output "vpn_security_group_id" {
  value       = ibm_is_security_group.vpn.id
  description = "ID of the security group assigned to the VPN interface"
}

output "vpn_maintenance_group_id" {
  value       = ibm_is_security_group.maintenance.id
  description = "ID of the security group used to allow connection from the VPN instance to other instances"
}

output "vpn_network_interface_ids" {
  value       = ibm_is_instance.vpn.primary_network_interface[*].id
  description = "ID(s) of the primary_network_interface for the VPN instance"
}