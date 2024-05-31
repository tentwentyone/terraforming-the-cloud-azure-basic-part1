variable "tenant_id" {
  type        = string
  description = "This is the default tenant id where the resources are managed."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscriptgaaion identifier."
}

variable "region" {
  type        = string
  description = "The default region to use."
}

variable "prefix" {
  type        = string
  description = "A simple prefix"
}
variable "admin_username" {
  type        = string
  description = "The admin username for the virtual machine."
}
