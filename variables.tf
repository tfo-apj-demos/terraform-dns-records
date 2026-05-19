variable "zone" {
  description = "DNS zone to write records into. Must end with a trailing dot."
  type        = string
  default     = "hashicorp.local."

  validation {
    condition     = can(regex("\\.$", var.zone))
    error_message = "var.zone must end with a trailing dot, e.g. \"example.com.\"."
  }
}

variable "a_records" {
  description = "List of A records to create in the zone."
  type = list(object({
    name      = string
    addresses = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.a_records : length(r.name) > 0])
    error_message = "Every a_record.name must be non-empty."
  }

  validation {
    condition     = alltrue([for r in var.a_records : length(r.addresses) > 0])
    error_message = "Every a_record must have at least one address."
  }
}

variable "cname_records" {
  description = "List of CNAME records to create in the zone."
  type = list(object({
    name  = string
    cname = string
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.cname_records : length(r.name) > 0 && length(r.cname) > 0])
    error_message = "Every cname_record must have both a non-empty name and a non-empty cname target."
  }
}
