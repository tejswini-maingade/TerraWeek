variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  type    = string
  default = "terraweek"
}

variable "port" {
  type    = number
  default = 8080
}

variable "enabled" {
  type    = bool
  default = true
}

variable "names" {
  type    = list(string)
  default = ["nginx", "redis", "postgres"]
}

variable "tags" {
  type = map(string)
  default = {
    owner   = "devops"
    project = "terraweek"
  }
}

variable "services" {
  type    = set(string)
  default = ["nginx", "redis"]
}

variable "app_config" {
  type = object({
    name    = string
    port    = number
    enabled = bool
  })

  default = {
    name    = "web"
    port    = 8080
    enabled = true
  }
}

variable "service_details" {
  type    = tuple([string, number, bool])
  default = ["nginx", 8080, true]
}

variable "demo_token" {
  description = "Demonstration value, not a real credential"
  type        = string
  sensitive   = true
  default     = "demo-only"
}
