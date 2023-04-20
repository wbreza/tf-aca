variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "resource_token" {
  description = "A suffix string to centrally mitigate resource name collisions."
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "login_server" {
  description = "The value of the ACR registry login server"
  type        = string
}

variable "app_name" {
  description = "The name of the container app"
  type        = string
}

variable "registry_identity" {
  description = "The identity of the ACR registry"
  type        = string
}

variable "container_app_environment_id" {
  description = "The ID of the container app environment"
  type        = string
}

variable "app_image" {
  description = "The image of the container app"
  type        = string
}