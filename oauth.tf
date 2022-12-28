
resource "cloudvps_web_proxy" "oauth_proxy" {
  count    = min(1, length(local.oauth_endpoints))
  hostname = local.oauth_proxy_hostname
  domain   = var.oauth_proxy_domain
  backends = [local.oauth_endpoints[0]]
}

module "oauth-server-blue" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.5.0"

  environment = "b"
  count       = 0

  # app_snapshot_name      = "oauth-www-20220829"
  database_snapshot_name = "oauth-db-20221228b"

  instance_type = data.openstack_compute_flavor_v2.small.id
  image_name    = "debian-11.0-bullseye"
  network       = data.openstack_networking_network_v2.network.id

  security_groups = [
    openstack_networking_secgroup_v2.oauth.name,
    data.openstack_networking_secgroup_v2.default.name,
  ]

  proxy_domain    = var.oauth_proxy_domain
  project_prefix  = var.resource_prefix
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

module "oauth-server-green" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.5.0"

  environment = "g"
  count       = 1

  # app_snapshot_name      = ""
  database_snapshot_name = "oauth-db-20221228b"

  instance_type = data.openstack_compute_flavor_v2.small.id
  image_name    = "debian-11.0-bullseye"
  network       = data.openstack_networking_network_v2.network.id

  security_groups = [
    openstack_networking_secgroup_v2.oauth.name,
    data.openstack_networking_secgroup_v2.default.name,
  ]

  proxy_domain    = var.oauth_proxy_domain
  project_prefix  = var.resource_prefix
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

