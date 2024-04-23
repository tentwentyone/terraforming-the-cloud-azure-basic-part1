
# ## terraform & providers
# terraform {
#   required_version = ">= 1.6.0"
#   backend "local" {
#     path = "terraform.tfstate"
#   }

#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "google" {
#   # Configuration options
#   project = var.project_id
#   region  = var.region
# }

# ## variaveis locais
# locals {
#   prefix = var.prefix
# }


# ## referenciar um recurso já existente
# ## ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project
# data "google_project" "this" {
#   project_id = var.project_id
# }

# ## Recursos locais
# resource "random_pet" "this" {
#   length    = 2
#   prefix    = local.prefix
#   separator = "-"
# }



# #### Instância de VM e respetiva subnet

# # referenciar a subnet já existente
# data "google_compute_subnetwork" "default" {
#   name   = "subnetwork-default"
#   region = var.region
# }

# # criar uma VM
# resource "google_compute_instance" "default" {
#   name         = "${random_pet.this.id}-vm"
#   machine_type = "g1-small"
#   zone         = "${var.region}-b"
#   ## 2.1 - Descomentar apenas quando for pedido
#   #tags = [ "allow-iap" ]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     subnetwork = data.google_compute_subnetwork.default.self_link
#   }
# }

## --------------------------- AZURE VERSION --------------------------- 

## terraform & providers

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
  tenant_id       = var.tenant_id                          # nosportugal.onmicrosoft.com
  subscription_id = var.subscription_id
  features {}
}

## variaveis locais
locals {
  prefix = var.prefix
}

## referenciar um recurso já existente
## ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription
data "azurerm_subscription" "this" {
  subscription_id = var.subscription_id
}

## Recursos locais
resource "random_pet" "this" {
  length    = 2
  prefix    = local.prefix
  separator = "-"
}

#### Instância de VM e respetiva subnet

# referenciar a subnet já existente
data "azurerm_resource_group" "tf_workshop" {
  name   = "tf-workshop"
}

data "azurerm_network_interface" "tf_workshop" {
  name                = "tf-workshop"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_virtual_machine" "tf_workshop" {
  name                  = "${random_pet.this.id}-tf-workshop"
  location              = data.azurerm_resource_group.tf_workshop.location
  resource_group_name   = data.azurerm_resource_group.tf_workshop.name
  network_interface_ids = [data.azurerm_network_interface.tf_workshop.id]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}
