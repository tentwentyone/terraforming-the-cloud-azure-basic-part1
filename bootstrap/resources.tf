resource "azurerm_resource_group" "tf_workshop" {
  name     = "tf-workshop"
  location = "West Europe"
}

resource "azurerm_virtual_network" "tf_workshop" {
  name                = "tf-workshop"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf_workshop.location
  resource_group_name = azurerm_resource_group.tf_workshop.name
}

resource "azurerm_subnet" "tf_workshop" {
  name                 = "tf-workshop"
  resource_group_name  = azurerm_resource_group.tf_workshop.name
  virtual_network_name = azurerm_virtual_network.tf_workshop.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tf_workshop" {
  name                = "tf-workshop"
  location            = azurerm_resource_group.tf_workshop.location
  resource_group_name = azurerm_resource_group.tf_workshop.name

  ip_configuration {
    name                          = "config"
    subnet_id                     = azurerm_subnet.tf_workshop.id
    private_ip_address_allocation = "Dynamic"
  }
}

