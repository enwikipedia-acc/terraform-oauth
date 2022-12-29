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
  default = "wmflabs.org"
}

locals {
  oauth_proxy_hostname         = "${var.resource_prefix}-${var.oauth_proxy_name}"
  oauth_staging_proxy_hostname = "${var.resource_prefix}-${var.oauth_staging_proxy_name}"
  prod_env                     = var.live_instance == "blue" ? module.oauth-server-blue[0].dns_name : module.oauth-server-green[0].dns_name
  staging_env                  = var.staging_instance == null ? null : (var.staging_instance == "blue" ? module.oauth-server-blue[0].dns_name : module.oauth-server-green[0].dns_name)
}

# blue/green deployments
variable "live_instance" {
  type        = string
  default     = "blue"
  description = "The currently-active instance of the application"

  validation {
    condition     = contains(["blue", "green"], var.live_instance)
    error_message = "The live instance must be either the 'blue' or 'green' environment"
  }
}

variable "staging_instance" {
  type        = string
  default     = null
  description = "The instance of the application running as a staging environment"

  validation {
    condition     = var.staging_instance == null || contains(["blue", "green"], coalesce(var.staging_instance, "none"))
    error_message = "The staging instance must be null or either the 'blue' or 'green' environments"
  }
}
