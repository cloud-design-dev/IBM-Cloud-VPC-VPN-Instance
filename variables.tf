variable "ssh_key" {
  type        = string
  description = "The name of an existing SSH Key that will be added to the vpn instance."
  default     = ""
}

variable "resource_group" {
  type        = string
  description = "The name of an existing Resource group to use for resources."
  default     = ""
}

variable "name" {
  type        = string
  description = "Name that will be prepended to resources."
  default     = "wg"
}

variable "tags" {
  type        = list(string)
  description = "A set of default tags to add to all resources."
  default     = []
}


variable "vpc_name" {
  type        = string
  description = "Name of the VPC where the VPN instance will be deployed."
}

variable "subnet_name" {
  type        = string
  description = "Name of the Subnet where the VPN instance will be deployed."
}

variable "zone" {
  type        = string
  description = "VPC Zone where instance is deployed."
}

variable "user_data" {}

variable "image_name" {
  default = "ibm-ubuntu-20-04-minimal-amd64-2"
}

variable "profile_name" {
  default = "cx2-2x4"
}

variable "security_group_rules" {
  description = "List of security group rules to set on the VPN security group in addition to the SSH rules"
  default = [
    {
      name      = "http_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 80
        port_max = 80
      }
    },
    {
      name      = "https_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      tcp = {
        port_min = 443
        port_max = 443
      }
    },
    {
      name      = "dns_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      udp = {
        port_min = 53
        port_max = 53
      }
    },
    {
      name      = "icmp_outbound"
      direction = "outbound"
      remote    = "0.0.0.0/0"
      icmp = {
        type = 8
      }
    }
  ]
}

