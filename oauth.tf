
resource "cloudvps_web_proxy" "oauth_proxy" {
  hostname = local.oauth_proxy_hostname
  domain   = var.oauth_proxy_domain
  backends = ["http://${module.oauth-server-blue[0].instance_ipv4}:80"]
}

module "oauth-server-blue" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.2.0"

  environment = "b"
  count       = 0

  app_snapshot_name      = "oauth-www-20220829"
  database_snapshot_name = "oauth-db-20220829"

  instance_type = data.openstack_compute_flavor_v2.small.id
  image_id      = data.openstack_images_image_v2.bullseye.id
  network       = data.openstack_networking_network_v2.network.id
  user_data     = file("${path.module}/userdata.sh")

  security_groups = [
    openstack_networking_secgroup_v2.oauth.name
  ]

  proxy_domain    = var.oauth_proxy_domain
  project_prefix  = var.resource_prefix
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

module "oauth-server-green" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.2.0"

  environment = "g"
  count       = 1

  # app_snapshot_name      = ""
  # database_snapshot_name = ""

  instance_type = data.openstack_compute_flavor_v2.small.id
  image_id      = data.openstack_images_image_v2.bullseye.id
  network       = data.openstack_networking_network_v2.network.id
  user_data     = file("${path.module}/userdata.sh")

  security_groups = [
    openstack_networking_secgroup_v2.oauth.name
  ]

  proxy_domain    = var.oauth_proxy_domain
  project_prefix  = var.resource_prefix
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

