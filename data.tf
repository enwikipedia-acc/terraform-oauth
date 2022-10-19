data "openstack_compute_flavor_v2" "small" {
  vcpus    = 1
  ram      = 2048
  min_disk = 15
}

data "openstack_images_image_v2" "bullseye" {
  most_recent = true
  name        = "debian-11.0-bullseye"
}

data "openstack_networking_network_v2" "network" {
  external = false
}
