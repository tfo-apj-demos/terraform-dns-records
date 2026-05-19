output "a_record_ids" {
  description = "Map of A-record index to record ID."
  value       = { for k, v in dns_a_record_set.a_record : k => v.id }
}

output "a_record_fqdns" {
  description = "List of A-record FQDNs created in the zone."
  value       = [for r in dns_a_record_set.a_record : "${r.name}.${trimsuffix(r.zone, ".")}"]
}

output "cname_record_ids" {
  description = "Map of CNAME-record name to record ID."
  value       = { for k, v in dns_cname_record.cname_record : k => v.id }
}
