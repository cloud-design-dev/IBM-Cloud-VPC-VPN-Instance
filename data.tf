data "ibm_is_image" "image" {
  name = var.image_name
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

data "ibm_is_subnet" "subnet" {
  name = var.subnet_name
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_is_ssh_key" "ssh_key" {
  name = var.ssh_key
}