# resources
# resource "google_compute_network" "default" {
#   name                    = "vpc-default"
#   auto_create_subnetworks = false

#   depends_on = [
#     google_project_iam_member.this
#   ]
# }

# resource "google_compute_subnetwork" "default" {
#   name          = "subnetwork-default"
#   ip_cidr_range = "10.0.0.0/16"
#   region        = var.region
#   network       = google_compute_network.default.id
# }

# resource "google_compute_firewall" "default" {
#   name        = "fw-ingressfromiap-p-01"
#   description = "Allow Ingress From iap for SSH"
#   network     = google_compute_network.default.name
#   priority    = 1000

#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   target_tags   = ["allow-iap"]
#   source_ranges = ["35.235.240.0/20"]
# }

## --------------------------- AZURE VERSION --------------------------- 

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

