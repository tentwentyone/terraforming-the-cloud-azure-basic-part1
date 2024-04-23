# output "my_identifier" {
#     value = random_pet.this.id
#     description = "All my resources will be created using this prefix, so that I don't conflict with other's resources"
# }

# output "project_id" {
#   value = data.google_project.this.name
# }

# output "region" {
#   value = var.region
# }

# output "vm" {
#   value = {
#       vm_name = google_compute_instance.default.name
#       vm_zone = google_compute_instance.default.zone
#       vm_project = google_compute_instance.default.project
#       vm_ip = google_compute_instance.default.network_interface.0.network_ip
#       gcloud_cmd = "gcloud compute ssh ${google_compute_instance.default.name} --project=${google_compute_instance.default.project} --zone ${google_compute_instance.default.zone}"
#   }
# }

# output "vm_name" {
#   value = google_compute_instance.default.name
# }

# output "vm_zone" {
#   value = google_compute_instance.default.zone
# }

## --------------------------- AZURE VERSION --------------------------- 

output "my_identifier" {
    value = random_pet.this.id
    description = "All my resources will be created using this prefix, so that I don't conflict with other's resources"
}

output "subscription_id" {
  value = data.azurerm_subscription.this.name
}

output "region" {
  value = var.region
}

output "vm" {
  value = {
      vm_name                = azurerm_virtual_machine.tf_workshop.name
      vm_location            = azurerm_virtual_machine.tf_workshop.location
      vm_resource_group_name = azurerm_virtual_machine.tf_workshop.resource_group_name
      vm_private_ip          = azurerm_virtual_machine.tf_workshop.network_interface.0.ip_configuration.0.private_ip_address
      az_cli_cmd             = "az ssh vm --resource-group ${azurerm_virtual_machine.tf_workshop.resource_group_name} --name ${azurerm_virtual_machine.tf_workshop.name}"
      # Please note that the az_cli_cmd is not a direct equivalent to the gcloud_cmd in the original output. It opens port 22 (SSH) on the VM, which is a prerequisite for SSH access. To actually SSH into the VM, you would need to use an SSH client and the VM's IP address.
  }
}

output "vm_name" {
  value = azurerm_virtual_machine.tf_workshop.name
}

output "vm_location" {
  value = azurerm_virtual_machine.tf_workshop.location
}
