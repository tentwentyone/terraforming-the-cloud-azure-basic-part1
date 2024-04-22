variable "tenant_id" {
  type        = string
  description = "This is the default tenant id where the resources are managed."
}

variable "subscription_id" {
  description = "The subscription id to bootstrap resources."
  type        = string
}

variable "region" {
  description = "The default region to create resources."
  type        = string
}

variable "azure_trainer_group" {
  description = "The group of the trainers for IAM purposes."
  type        = string
}
