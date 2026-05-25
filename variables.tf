variable "zone" {
  description = "DNS zone to write records into. Must end with a trailing dot."
  type        = string
  default     = "hashicorp.local."

  validation {
    condition     = can(regex("\\.$", var.zone))
    error_message = "var.zone must end with a trailing dot, e.g. \"example.com.\"."
  }
}

variable "default_ttl" {
  description = <<-EOT
    Default record TTL in seconds, applied to any record that does not set its
    own ttl. A low value (e.g. 60) makes address changes from VM rebuilds
    propagate quickly instead of being cached for the provider default of an
    hour; raise it for records that rarely change.
  EOT
  type        = number
  default     = 60

  validation {
    condition     = var.default_ttl >= 0
    error_message = "default_ttl must be >= 0."
  }
}

variable "a_records" {
  description = "List of A records to create in the zone. Set ttl per record to override default_ttl."
  type = list(object({
    name      = string
    addresses = list(string)
    ttl       = optional(number)
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

  validation {
    condition     = alltrue([for r in var.a_records : r.ttl == null || try(r.ttl >= 0, false)])
    error_message = "Every a_record.ttl, if set, must be >= 0."
  }
}

variable "cname_records" {
  description = "List of CNAME records to create in the zone. Set ttl per record to override default_ttl."
  type = list(object({
    name  = string
    cname = string
    ttl   = optional(number)
  }))
  default = []

  validation {
    condition     = alltrue([for r in var.cname_records : length(r.name) > 0 && length(r.cname) > 0])
    error_message = "Every cname_record must have both a non-empty name and a non-empty cname target."
  }

  validation {
    condition     = alltrue([for r in var.cname_records : r.ttl == null || try(r.ttl >= 0, false)])
    error_message = "Every cname_record.ttl, if set, must be >= 0."
  }
}
