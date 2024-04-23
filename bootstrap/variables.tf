# variable "project_id" {
#   description = "The project id to bootstrap resources."
#   type        = string
# }

# variable "region" {
#   description = "The default region to create resources."
#   type        = string
#   default     = "europe-west1"
# }

# variable "gcp_trainer_group" {
#   description = "The group of the trainers for IAM purposes."
#   type        = string
# }

## --------------------------- AZURE VERSION --------------------------- 

variable "tenant_id" {
  type        = string
  description = "This is the default tenant id where the resources are managed."
  default     = "930a470b-f629-4f93-a65b-bad14153f14f"
}

variable "subscription_id" {
  description = "The subscription id to bootstrap resources."
  type        = string
}

variable "region" {
  description = "The default region to create resources."
  type        = string
  default     = "westeurope"
}

variable "azure_trainer_group" {
  description = "The group of the trainers for IAM purposes."
  type        = string
}
