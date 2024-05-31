output "my_vm_identifier" {
  value       = random_pet.this.id
  description = "This is the identifier for the virtual machine."
}

output "my_generic_identifier" {
  value       = random_pet.default.id
  description = "This is a generic identifier."
}

output "subscription_id" {
  value = data.azurerm_subscription.this.display_name
}

output "region" {
  value = var.region
}

## UNCOMMENT AFTER CREATING VIRTUAL MACHINE

# output "vm" {
#   value = {
#     vm_name                = azurerm_virtual_machine.my_virtual_machine.name
#     vm_location            = azurerm_virtual_machine.my_virtual_machine.location
#     vm_resource_group_name = azurerm_virtual_machine.my_virtual_machine.resource_group_name
#     az_cli_cmd             = "az ssh vm --resource-group ${azurerm_virtual_machine.my_virtual_machine.resource_group_name} --name ${azurerm_virtual_machine.my_virtual_machine.name} --local-user var.admin_username"
#     # Please note that the az_cli_cmd is not a direct equivalent to the gcloud_cmd in the original output. It opens port 22 (SSH) on the VM, which is a prerequisite for SSH access. To actually SSH into the VM, you would need to use an SSH client and the VM's IP address.
#   }
# }

