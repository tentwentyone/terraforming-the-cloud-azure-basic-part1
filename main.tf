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

data "azurerm_client_config" "client" {
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

data "azurerm_key_vault" "default" {
  name                = "tf-azure-workshop-kv"
  resource_group_name = "tf-azure-workshop-rg"
}

data "azurerm_key_vault_secret" "default" {
  name         = "ssh-private-key"
  key_vault_id = data.azurerm_key_vault.default.id
}

data "azurerm_bastion_host" "default" {
  name                = "tf-azure-workshop-bastion"
  resource_group_name = data.azurerm_resource_group.default.name
}

data "azurerm_resource_group" "default" {
  name                = "tf-azure-workshop-rg"
}

resource "azurerm_subnet" "my_subnet" {
  name                 = "${random_pet.this.id}-subnet"
  resource_group_name  = "tf-azure-workshop-rg"
  virtual_network_name = data.azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}

# #Exercicio 2.

# resource "azurerm_linux_virtual_machine" "my_virtual_machine" {
#   name                            = "${random_pet.this.id}-vm"
#   location                        = var.region
#   resource_group_name             = azurerm_resource_group.default.name
#   size                            = "Standard_B1ls"
#   admin_username                  = "adminuser"
#   network_interface_ids           = [azurerm_network_interface.my_network_interface.id]
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "0001-com-ubuntu-server-jammy"
#     sku       = "22_04-lts-gen2"
#     version   = "latest"
#   }

# # Descomentar para o Exercicio 2.1
# #   tags = {
# ##     ## Example
# #     environment = "staging"
# #   }

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = data.azurerm_key_vault_secret.default.value
#   }

#   lifecycle {
#     ignore_changes = [
#       identity
#     ]
#   }

#   depends_on = [azurerm_resource_group.default]

# }

# resource "azurerm_virtual_machine_extension" "aad_login" {
#   name                      = "AADSSHLoginForLinux"
#   virtual_machine_id        = azurerm_linux_virtual_machine.my_virtual_machine.id
#   publisher                 = "Microsoft.Azure.ActiveDirectory"
#   type                      = "AADSSHLoginForLinux"
#   type_handler_version      = "1.0"
#   automatic_upgrade_enabled = false

#   depends_on = [azurerm_linux_virtual_machine.my_virtual_machine]
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

# resource "azurerm_role_assignment" "user_login" {
#   scope                = azurerm_resource_group.default.id
#   role_definition_name = "Virtual Machine User Login"
#   principal_id         = data.azurerm_client_config.client.object_id
# }

# resource "azurerm_role_assignment" "key_vault_secrets_officer" {
#   scope                = azurerm_resource_group.default.id
#   role_definition_name = "Key Vault Secrets Officer"
#   principal_id         = data.azurerm_client_config.client.object_id
# }