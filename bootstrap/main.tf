terraform {
  required_version = ">= 1.6.0"
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.64"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.31"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

data "azurerm_subscription" "this" {
  subscription_id = var.subscription_id
}

# Services

## Enable services
locals {
  azure_service_list = [
    "Microsoft.Compute",
    "Microsoft.ContainerService",
    "Microsoft.Network",
    "Microsoft.Storage"
  ]
}

resource "azurerm_resource_provider_registration" "this" {
  for_each = toset(local.azure_service_list)
  name     = each.key
}
