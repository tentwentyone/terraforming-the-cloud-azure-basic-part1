# ## 3.2 Descomentar apenas quando for pedido

# import {
#   id = "${data.azurerm_subscription.this.id}/resourceGroups/${azurerm_resource_group.default.name}/providers/Microsoft.Network/virtualNetworks/${random_pet.this.id}-vnet"
#   to = azurerm_virtual_network.my_imported_vnet
# }

# resource "azurerm_virtual_network" "my_imported_vnet" {
#    name                = "${random_pet.this.id}-vnet"
#    location            = azurerm_resource_group.default.location
#    resource_group_name = azurerm_resource_group.default.name
#    address_space       = ["10.0.0.0/16"]
# }
