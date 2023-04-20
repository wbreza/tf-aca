variable "location" {
  type        = string
  default     = "eastus"
  description = "Desired Azure Region"
}

variable "environment_name" {
  type        = string
  default     = "tf-aca"
  description = "Desired Resource Group Name"
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "Number of days deleted Azure Key Vault resources are retained."
}

variable "purge_protection_enabled" {
  type        = bool
  default     = false
  description = "Enables purge protection on Azure Key Vault"
}

variable "secretstore_admins" {
  type        = list(string)
  default     = []
  description = "List of Key Vault administrator object / principal Ids"
}

variable "receiver_image" {
  type        = string
  default     = "nginx:latest"
  description = "The image to use for the receiver container"
}

variable "sender_image" {
  type        = string
  default     = "nginx:latest"
  description = "The image to use for the sender container"
}
