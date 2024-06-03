# ## 3.2 Descomentar apenas quando for pedido
# import {
#   id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Network/virtualNetworks/vnet-name"
#   to = azurerm_virtual_network.imported
# }

# resource "azurerm_virtual_network" "imported" {
#   name                = "import-test"
#   location            = azurerm_resource_group.my_resource_group.location
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   address_space       = ["10.0.0.0/16"]
# }