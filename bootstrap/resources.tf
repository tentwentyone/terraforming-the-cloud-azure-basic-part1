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

