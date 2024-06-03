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
  tenant_id       = var.tenant_id # nosportugal.onmicrosoft.com
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

##############################################################


resource "random_pet" "this" {
  length    = 2
  separator = "-"
}

resource "azurerm_resource_group" "my_resource_group" {
  name     = "${random_pet.this.id}-rg"
  location = var.region
}

resource "azurerm_virtual_network" "my_virtual_network" {
  name                = "${random_pet.this.id}-vnet"
  location            = var.region
  resource_group_name = azurerm_resource_group.my_resource_group.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "workshop-subnet"
    address_prefix = "10.0.1.0/24"
  }
}


##############################################################

## UNCOMMENT AFTER FIRST APPLY

# resource "azurerm_network_interface" "my_network_interface" {
#   name                = "${random_pet.this.id}-ni"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.my_resource_group.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.my_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.my_public_ip.id
#   }

#   depends_on = [azurerm_resource_group.my_resource_group]
# }

# resource "azurerm_public_ip" "my_public_ip" {
#   name                = "${random_pet.this.id}-public-ip"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   allocation_method   = "Dynamic"
# }

# data "azurerm_subnet" "my_subnet" {
#   name                 = "workshop-subnet"
#   virtual_network_name = azurerm_virtual_network.my_virtual_network.name
#   resource_group_name  = azurerm_resource_group.my_resource_group.name

#   depends_on = [azurerm_virtual_network.my_virtual_network]
# }


##############################################################


# resource "azurerm_virtual_machine" "my_virtual_machine" {
#   name                             = "${local.prefix}-${random_pet.this.id}-vm"
#   location                         = var.region
#   resource_group_name              = azurerm_resource_group.my_resource_group.name
#   network_interface_ids            = [azurerm_network_interface.my_network_interface.id]
#   vm_size                          = "Standard_DS1_v2"
#   delete_data_disks_on_termination = true
#   delete_os_disk_on_termination    = true

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "16.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "${random_pet.this.id}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   os_profile {
#     computer_name  = "my-vm"
#     admin_username = var.admin_username
#     admin_password = var.admin_password
#   }


#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   tags = {

## ADD TAG HERE KEY = "VALUE"


#   }

#   lifecycle {
#     ignore_changes = [
#       identity
#     ]
#   }
#   depends_on = [azurerm_resource_group.my_resource_group]
# }
