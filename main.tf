resource "dns_a_record_set" "a_record" {
  count     = length(var.a_records)
  zone      = var.zone
  name      = var.a_records[count.index].name
  addresses = var.a_records[count.index].addresses
  ttl       = coalesce(var.a_records[count.index].ttl, var.default_ttl)
}

resource "dns_cname_record" "cname_record" {
  for_each = { for r in var.cname_records : r.name => r }
  zone     = var.zone
  name     = each.value.name
  cname    = each.value.cname
  ttl      = coalesce(each.value.ttl, var.default_ttl)
}
