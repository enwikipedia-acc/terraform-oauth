resource "cloudvps_web_proxy" "oauth_proxy" {
  hostname = local.oauth_proxy_hostname
  domain   = var.oauth_proxy_domain
  backends = ["http://oauth-prod.${trimsuffix(data.openstack_dns_zone_v2.rootzone.name, ".")}:80"]
}

resource "cloudvps_web_proxy" "staging_oauth_proxy" {
  count    = module.bluegreen.staging_count
  hostname = local.oauth_staging_proxy_hostname
  domain   = var.oauth_proxy_domain
  backends = ["http://${trimsuffix(module.bluegreen.staging_dns_name, ".")}:80"]
}

resource "openstack_dns_recordset_v2" "prod_instance" {
  name    = "oauth-prod.${data.openstack_dns_zone_v2.rootzone.name}"
  zone_id = data.openstack_dns_zone_v2.rootzone.id
  type    = "CNAME"
  records = [module.bluegreen.live_dns_name]
  ttl     = 180
}

module "bluegreen" {
  source  = "app.terraform.io/enwikipedia-acc/bluegreen/openstack"
  version = "0.2.0"

  blue_dns_name       = "${local.blue_resource_prefix}.${data.openstack_dns_zone_v2.rootzone.name}"
  green_dns_name      = "${local.blue_resource_prefix}.${data.openstack_dns_zone_v2.rootzone.name}"
  live_environment    = var.live_instance
  staging_environment = var.staging_instance
}

module "oauth-server-blue" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.12.0"

  environment = "b"
  count       = module.bluegreen.blue_count

  database_snapshot_name = "oauth-db-20221228b"
  instance_type = data.openstack_compute_flavor_v2.small.id
  image_name    = "debian-11.0-bullseye"

  resource_prefix = local.blue_resource_prefix

  network       = data.openstack_networking_network_v2.network.id
  dns_zone_id   = data.openstack_dns_zone_v2.rootzone.id
  dns_name      = module.bluegreen.blue_dns_name


  security_groups = [
    openstack_networking_secgroup_v2.oauth.name,
    data.openstack_networking_secgroup_v2.default.name,
  ]

  proxy_domain    = var.oauth_proxy_domain
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

module "oauth-server-green" {
  source  = "app.terraform.io/enwikipedia-acc/mediawiki-oauth/openstack"
  version = "0.12.0"

  environment = "g"
  count       = module.bluegreen.green_count

  database_snapshot_name = "oauth-db-20221228b"
  instance_type = data.openstack_compute_flavor_v2.small.id
  image_name    = "debian-11.0-bullseye"

  resource_prefix = local.green_resource_prefix

  network     = data.openstack_networking_network_v2.network.id
  dns_zone_id = data.openstack_dns_zone_v2.rootzone.id
  dns_name    = module.bluegreen.green_dns_name

  security_groups = [
    openstack_networking_secgroup_v2.oauth.name,
    data.openstack_networking_secgroup_v2.default.name,
  ]

  proxy_domain    = var.oauth_proxy_domain
  public_hostname = "${local.oauth_proxy_hostname}.${var.oauth_proxy_domain}"
}

