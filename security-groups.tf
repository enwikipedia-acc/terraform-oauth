resource "openstack_networking_secgroup_v2" "oauth" {
  name        = "${var.resource_prefix}-oauth-app"
  description = "Managed by Terraform; OAuth test application"
}

resource "openstack_networking_secgroup_rule_v2" "v4-mysql" {
  direction       = "ingress"
  ethertype       = "IPv4"
  protocol        = "tcp"
  port_range_min  = 3306
  port_range_max  = 3306
  remote_group_id = openstack_networking_secgroup_v2.oauth.id
  description     = "MySQL inbound from instances in this group"

  security_group_id = openstack_networking_secgroup_v2.oauth.id
}

resource "openstack_networking_secgroup_rule_v2" "v4-http" {
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "0.0.0.0/0"
  description      = "HTTP inbound"

  security_group_id = openstack_networking_secgroup_v2.oauth.id
}

resource "openstack_networking_secgroup_rule_v2" "v6-http" {
  direction        = "ingress"
  ethertype        = "IPv6"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "::/0"
  description      = "HTTP inbound"

  security_group_id = openstack_networking_secgroup_v2.oauth.id
}
