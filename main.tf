terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.49.0"
    }

    cloudvps = {
      source  = "terraform.wmcloud.org/registry/cloudvps"
      version = "~> 0.1.3"
    }
  }

  cloud {
    organization = "enwikipedia-acc"

    workspaces {
      name = "oauth"
    }
  }

  required_version = "~> 1.3.6"
}

provider "openstack" {
  tenant_name                   = var.project
  auth_url                      = "https://openstack.eqiad1.wikimediacloud.org:25000/v3"
  application_credential_id     = var.application_credential_id
  application_credential_secret = var.application_credential_secret
}

provider "cloudvps" {
  os_auth_url                      = "https://openstack.eqiad1.wikimediacloud.org:25000/v3"
  os_project_id                    = var.project
  os_application_credential_id     = var.application_credential_id
  os_application_credential_secret = var.application_credential_secret
}
