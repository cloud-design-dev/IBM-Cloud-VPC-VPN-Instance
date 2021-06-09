resource "ibm_is_instance" "vpn" {
  name           = var.name
  vpc            = data.ibm_is_vpc.vpc.id
  zone           = var.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = var.ssh_keys
  resource_group = data.ibm_resource_group.group.id

  user_data = var.user_data != "" ? var.user_data : file("${path.module}/init.yml")


  primary_network_interface {
    subnet          = data.ibm_is_subnet.subnet.id
    security_groups = [ibm_is_security_group.vpn.id]
  }

  boot_volume {
    name = "${var.name}-boot-volume"
  }

  tags = concat(var.tags, ["zone:${var.zone}"])
}

resource "ibm_is_floating_ip" "vpn" {
  name           = "${var.name}-ip"
  target         = ibm_is_instance.vpn.primary_network_interface[0].id
  resource_group = data.ibm_resource_group.group.id
  tags           = var.tags
}