data "openstack_compute_flavor_v2" "small" {
  vcpus    = 1
  ram      = 2048
  min_disk = 15
}

data "openstack_networking_network_v2" "network" {
  external = false
}

data "openstack_networking_secgroup_v2" "default" {
  name = "default"
}

data "openstack_dns_zone_v2" "rootzone" {
}
