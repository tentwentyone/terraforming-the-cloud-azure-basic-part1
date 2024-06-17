data "azurerm_client_config" "client" {
}

resource "azurerm_resource_group" "default" {
  name     = "tf-azure-workshop-rg"
  location = var.region
}

resource "azurerm_virtual_network" "default" {
  name                = "tf-azure-workshop-vnet"
  location            = var.region
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "tf-azure-workshop-bastion-pip"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "default" {
  name                = "tf-azure-workshop-bastion"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "Standard"
  ip_connect_enabled  = true
  tunneling_enabled   = true

    ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_key_vault" "default" {
  name                          = "tf-azure-workshop-kv"
  location                      = var.region
  resource_group_name           = azurerm_resource_group.default.name
  enabled_for_disk_encryption   = false
  enable_rbac_authorization     = true
  tenant_id                     = var.tenant_id
  public_network_access_enabled = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7

  sku_name = "standard"

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
    ip_rules       = []
  }
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "default" {
  key_vault_id = azurerm_key_vault.default.id
  name         = "ssh-private-key"
  value        = tls_private_key.default.public_key_openssh

  depends_on = [azurerm_role_assignment.key_vault_secrets_officer]
}

resource "azurerm_role_assignment" "key_vault_secrets_officer" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.client.object_id
}

# Storage Account for Azure Cloud Shells used by all workshop attendees
resource "azurerm_storage_account" "default" {
  name                            = "tfazureworkshopsa"
  resource_group_name             = azurerm_resource_group.default.name
  location                        = azurerm_resource_group.default.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true
}

resource "azurerm_storage_share" "default" {
  name                 = "fileshare"
  storage_account_name = azurerm_storage_account.default.name
  quota                = 50
}