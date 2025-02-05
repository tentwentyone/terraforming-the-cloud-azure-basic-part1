



terraform {
  required_version = "1.10.5"
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}

provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

## variaveis locais
locals {
  prefix = var.prefix
}

# referenciar um recurso já existente
# ref: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription
data "azurerm_subscription" "this" {
  subscription_id = var.subscription_id
}


resource "random_pet" "this" {
  length    = 2
  separator = "-"
  prefix    = var.prefix
}

resource "azurerm_resource_group" "default" {
  name     = "${random_pet.this.id}-rg"
  location = var.region
}

resource "azurerm_virtual_network" "default" {
  name                = "${random_pet.this.id}-vnet"
  location            = var.region
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "default" {
  name                 = "${random_pet.this.id}-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}








# ## Exercicio 2.

# resource "azurerm_linux_virtual_machine" "default" {
#   name                            = "${random_pet.this.id}-vm"
#   location                        = var.region
#   resource_group_name             = azurerm_resource_group.default.name
#   size                            = "Standard_B1ls"
#   admin_username                  = "adminuser"
#   admin_password                  = "Password1234!"
#   disable_password_authentication = false
#   network_interface_ids           = [azurerm_network_interface.default.id]
#   patch_assessment_mode           = "AutomaticByPlatform"
#   provision_vm_agent              = true
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

# #   tags = {
# # #  Exercicio 2.1 - Acrescentar uma tag
# #    environment = "staging"
# #   }

#   lifecycle {
#     ignore_changes = [
#       identity
#     ]
#   }
# }

# resource "azurerm_network_interface" "default" {
#   name                = "${random_pet.this.id}-ni"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.default.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.default.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }


# output "virtual_machine_name" {
#   value = azurerm_linux_virtual_machine.default.name
# }

# output "network_interface_name" {
#   value = azurerm_network_interface.default.name
# }
