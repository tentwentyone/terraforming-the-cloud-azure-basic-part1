resource "azurerm_resource_group" "default" {
  name     = "tf-azure-workshop-rg"
  location = var.region
}

# Storage Account for Azure Cloud Shells used by all workshop attendees
resource "azurerm_storage_account" "default" {
  name                            = "tfazureworkshopsatto"
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
  quota                = 150
}
