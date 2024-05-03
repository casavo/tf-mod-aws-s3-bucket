variable "name" {
  type = string
}

variable "public" {
  type    = bool
  default = false
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "website_enabled" {
  type    = bool
  default = false
}

variable "website_documents" {
  type = object({
    error = string
    index = string
  })
  default = {
    error = "error.html"
    index = "index.html"
  }
}

variable "cors_rules" {
  type = list(
    object({
      allowed_headers = list(string)
      allowed_methods = list(string)
      allowed_origins = list(string)
      expose_headers  = list(string)
      max_age_seconds = number
    })
  )
  default = []
}

variable "bucket_policies" {
  type    = list(map(any))
  default = []
}

variable "resource_policies" {
  type    = list(map(any))
  default = []
}

variable "lifecycle_policies" {
  type    = map(any)
  default = {}
}

variable "encryption" {
  type = object({
    enabled = bool
    key     = string
  })
  default = {
    enabled = false
    key     = ""
  }
}
