# Authentication
variable "application_credential_id" {
  type = string
}

variable "application_credential_secret" {
  type      = string
  sensitive = true
}

# Project configuration
variable "project" {
  type    = string
  default = "account-creation-assistance"
}

variable "resource_prefix" {
  type    = string
  default = "accounts"
}

# OAuth test server

variable "oauth_proxy_name" {
  type    = string
  default = "oauth"
}

variable "oauth_staging_proxy_name" {
  type    = string
  default = "oauth-test"
}

variable "oauth_proxy_domain" {
  type    = string
  default = "wmcloud.org"
}

locals {
  oauth_proxy_hostname         = "${var.resource_prefix}-${var.oauth_proxy_name}"
  oauth_staging_proxy_hostname = "${var.resource_prefix}-${var.oauth_staging_proxy_name}"

  blue_resource_prefix  = "${var.resource_prefix}-oauth-b"
  green_resource_prefix = "${var.resource_prefix}-oauth-g"
}

# blue/green deployments
variable "live_instance" {
  type        = string
  description = "The currently-active instance of the application"
}

variable "staging_instance" {
  type        = string
  description = "The instance of the application running as a staging environment"
}

# dns zone
variable "dns_zone" {
  type    = string
  default = "svc.account-creation-assistance.eqiad1.wikimedia.cloud."
}
