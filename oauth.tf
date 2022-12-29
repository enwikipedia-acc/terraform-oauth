resource "cloudvps_web_proxy" "oauth_proxy" {
  hostname = local.oauth_proxy_hostname
  domain   = var.oauth_proxy_domain
  backends = ["http://oauth-prod.${trimsuffix(data.openstack_dns_zone_v2.rootzone.name, ".")}:80"]
}

resource "cloudvps_web_proxy" "staging_oauth_proxy" {
  count    = var.staging_instance != null ? 1 : 0
  hostname = local.oauth_staging_proxy_hostname
  domain   = var.oauth_proxy_domain
  backends = ["http://${trimsuffix(local.staging_env, ".")}:80"]
}

resource "openstack_dns_recordset_v2" "prod_instance" {
  name    = "oauth-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = [local.prod_env]
  ttl     = 180
}


module "oauth-server-blue" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.11.0"

  environment = "b"
  count       = var.live_instance == "blue" || var.staging_instance == "blue" ? 1 : 0

  database_snapshot_name = "oauth-db-20221228b"

  instance_type = data.openstack_compute_flavor_v2.small.id
  image_name    = "debian-11.0-bullseye"
  network       = data.openstack_networking_network_v2.network.id
  dns_zone      = data.openstack_dns_zone_v2.rootzone

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
  version = "0.10.0"

  environment = "g"
  count       = var.live_instance == "green" || var.staging_instance == "green" ? 1 : 0

  database_snapshot_name = "oauth-db-20221228b"

  instance_type = data.openstack_compute_flavor_v2.small.id
  image_name    = "debian-11.0-bullseye"
  network       = data.openstack_networking_network_v2.network.id
  dns_zone      = data.openstack_dns_zone_v2.rootzone

  security_groups = [
    openstack_networking_secgroup_v2.oauth.name,
    data.openstack_networking_secgroup_v2.default.name,
  ]

  proxy_domain    = var.oauth_proxy_domain
  project_prefix  = var.resource_prefix
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

