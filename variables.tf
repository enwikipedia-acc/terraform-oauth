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

variable "oauth_proxy_domain" {
  type    = string
  default = "wmflabs.org"
}

locals {
  oauth_proxy_hostname = "${var.resource_prefix}-${var.oauth_proxy_name}"
}
