# ## Este ficheiro foi deixado bem branco de propósito para efeitos do exercicio do ponto 5

# // Create an azurerm user assigned identity with a name that uses random_pet-uai
# resource "azurerm_user_assigned_identity" "uai" {
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   location            = azurerm_resource_group.my_resource_group.location
#   name                = "${random_pet.this.id}-uai"
# }

# // Create a new random pet resource with a length of 2. The resource name must be "final"
# // Create an azure virtual machine that has the random pet as a prefix.
# // uses the cheapest machine type in azure
# // location must be west europe
# // Create a new network interface and public ip like the previous example
# // must contain tag with key "" and value ""
# // machine must run with user assigned identity create above
# // must be abl to ssh into the machine



# resource "random_pet" "final" {
#   length = 2
#   prefix = var.prefix
# }


# resource "azurerm_virtual_machine" "final_exercise_machine" {
#   name                = "${random_pet.final.id}-vm"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   vm_size             = "Standard_B1ls"

#   identity {
#     type = "UserAssigned"
#     identity_ids = [
#       azurerm_user_assigned_identity.uai.id
#     ]
#   }

#   tags = {
#     owner = "admin"
#   }

#   os_profile {
#     computer_name  = "my-vm"
#     admin_username = "admin"
#     admin_password = "Pw123456789!"
#   }


#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "${random_pet.final.id}-osdisk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   network_interface_ids = [
#     azurerm_network_interface.final_exercise_nic.id
#   ]
# }

# resource "azurerm_network_interface" "final_exercise_nic" {
#   name                = "${random_pet.final.id}-nic"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.my_resource_group.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.my_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.final_exercise_public_ip.id
#   }
# }

# resource "azurerm_public_ip" "final_exercise_public_ip" {
#   name                = "${random_pet.final.id}-public-ip"
#   location            = var.region
#   resource_group_name = azurerm_resource_group.my_resource_group.name
#   allocation_method   = "Dynamic"
# }
