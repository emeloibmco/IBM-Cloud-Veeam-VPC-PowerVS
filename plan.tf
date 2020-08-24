provider "ibm" {
  generation         = 2
  region             = "eu-gb"
}

data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

resource "ibm_is_ssh_key" "sshkey" {
  name       = "keysshdemobackup"
  public_key = "${var.ssh_public}"
}

resource "ibm_is_vpc" "vpcbackup" {
  name = "vpcbackupdemo"
  resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_subnet" "subnetforbackup" {
  name            = "subnetforbackup"
  vpc             = "${ibm_is_vpc.vpcbackup.id}"
  zone            = "eu-gb-1"
  total_ipv4_address_count  = "16"
}

resource "ibm_is_security_group" "securitygroupdemobackup" {
  name = "securitygroupdemobackup"
  vpc  = "${ibm_is_vpc.vpcbackup.id}"
  resource_group = "${data.ibm_resource_group.group.id}"
}


resource "ibm_is_instance" "vsiwindows" {
  name    = "vsibackupadmin"
  image   = "r018-54e9238a-ffdd-4f90-9742-7424eb2b9ff1"
  profile = "bx2-8x32"
  resource_group = "${data.ibm_resource_group.group.id}"


  primary_network_interface {
    subnet = "${ibm_is_subnet.subnetforbackup.id}"
    security_groups = ["${ibm_is_security_group.securitygroupdemobackup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpcbackup.id}"
  zone      = "eu-gb-1"
  keys = ["${ibm_is_ssh_key.sshkey.id}"]
}

resource "ibm_is_instance" "vsilinux" {
  name    = "vsiworkstation"
  image   = "99edcc54-c513-4d46-9f5b-36243a1e50e2"
  profile = "bx2-2x8"
  resource_group = "${data.ibm_resource_group.group.id}"


  primary_network_interface {
    subnet = "${ibm_is_subnet.subnetforbackup.id}"
    security_groups = ["${ibm_is_security_group.securitygroupdemobackup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpcbackup.id}"
  zone      = "eu-gb-1"
  keys = ["${ibm_is_ssh_key.sshkey.id}"]
}

resource "ibm_is_security_group_rule" "testacc_security_group_rule_all" {
  group     = "${ibm_is_security_group.securitygroupdemobackup.id}"
  direction = "inbound"
}


resource "ibm_is_security_group_rule" "testacc_security_group_rule_icmp" {
  group     = "${ibm_is_security_group.securitygroupdemobackup.id}"
  direction = "inbound"
  icmp {
    type = 8
  }
}

resource "ibm_is_security_group_rule" "testacc_security_group_rule_out" {
  group     = "${ibm_is_security_group.securitygroupdemobackup.id}"
  direction = "outbound"
}
