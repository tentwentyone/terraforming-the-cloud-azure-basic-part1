output "my_identifier" {
  value       = random_pet.this.id
  description = "All my resources will be created using this prefix, so that I don't conflict with other's resources"
}

output "subscription_name" {
  value = data.azurerm_subscription.this.display_name
}

output "region" {
  value = var.region
}

output "subnet_name" {
  value = azurerm_subnet.default.name
}

