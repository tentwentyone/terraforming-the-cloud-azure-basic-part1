terraform {
  required_version = ">= 1.8.1"
  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.106"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
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

data "azurerm_virtual_network" "default" {
  name                = "tf-azure-workshop-vnet"
  resource_group_name = "tf-azure-workshop-rg"
}


resource "azurerm_subnet" "my_subnet" {
  name                 = "${random_pet.this.id}-subnet"
  resource_group_name  = "tf-azure-workshop-rg"
  virtual_network_name = data.azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}

##Exercicio 2.

# resource "azurerm_linux_virtual_machine" "my_virtual_machine" {
#   name                            = "${random_pet.this.id}-vm"
#   location                        = var.region
#   resource_group_name             = azurerm_resource_group.default.name
#   size                            = "Standard_B1ls"
#   admin_username                  = "adminuser"
#   admin_password                  = "Password1234!"
#   disable_password_authentication = false
#   network_interface_ids           = [azurerm_network_interface.my_network_interface.id]
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

## Descomentar para o Exercicio 2.1
##   tags = {
###     ## Example
##     environment = "staging"
##   }

#   lifecycle {
#     ignore_changes = [
#       identity
#     ]
#   }

#   depends_on = [azurerm_resource_group.default]

# }

# resource "azurerm_network_interface" "my_network_interface" {
#   name                = "${random_pet.this.id}-ni"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.default.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.my_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }

#   depends_on = [azurerm_resource_group.default]
# }
