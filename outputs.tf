output "my_identifier" {
  value       = random_pet.this.id
  description = "All my resources will be created using this prefix, so that I don't conflict with other's resources"
}

output "subscription_id" {
  value = data.azurerm_subscription.this.display_name
}

output "region" {
  value = var.region
}

output "subnet" {
  value = azurerm_subnet.my_subnet.name
}

# Exercicio 2.0

# output "vm" {
#   value = {
#     vm_name                = azurerm_linux_virtual_machine.my_virtual_machine.name
#     vm_location            = azurerm_linux_virtual_machine.my_virtual_machine.location
#     vm_resource_group_name = azurerm_linux_virtual_machine.my_virtual_machine.resource_group_name
#   }
# }

# output "my_network_interface" {
#   value = {
#   nic_name                   =  azurerm_network_interface.my_network_interface.name
#   nic_resource_group_name    =  azurerm_network_interface.my_network_interface.resource_group_name

#   }
# }

# Exercicio 3.2

# output "my_virtual_network" {
#   value = {
#   vn_name                    = azurerm_virtual_network.my_imported_vnet.name
#   vn_resource_group_name     = azurerm_virtual_network.my_imported_vnet.location
#   }
# }