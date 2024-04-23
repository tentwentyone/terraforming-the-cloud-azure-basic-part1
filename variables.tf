# variable "project_id" {
#   type        = string
#   description = "The google project identifier."
# }

# variable "region" {
#   type        = string
#   description = "The default region to use."
#   default     = "europe-west1"
# }

# variable "prefix" {
#   type        = string
#   description = "A simple prefix"
#   default     = "gcp"
# }

## --------------------------- AZURE VERSION --------------------------- 

variable "tenant_id" {
  type        = string
  description = "This is the default tenant id where the resources are managed."
  default     = "930a470b-f629-4f93-a65b-bad14153f14f"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscriptgaaion identifier."
  default     = "a5a70928-a6c8-4495-b752-a7ab1d7768b7" # ccoe-lab
}

variable "region" {
  type        = string
  description = "The default region to use."
  default     = "westeurope"
}

variable "prefix" {
  type        = string
  description = "A simple prefix"
  default     = "azure"
}