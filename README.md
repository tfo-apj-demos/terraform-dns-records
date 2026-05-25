# terraform-dns-management

Creates A and CNAME records in a DNS zone via the `hashicorp/dns` provider
(GSS-TSIG dynamic updates against Windows AD DNS).

## Usage

```hcl
module "dns" {
  source  = "app.terraform.io/tfo-apj-demos/domain-name-system-management/dns"
  version = "~> 2.0"

  zone        = "hashicorp.local."
  default_ttl = 60 # seconds — low so VM-rebuild IP changes propagate fast

  a_records = [
    {
      name      = "web-server-01"
      addresses = ["172.21.13.115"]
      # ttl = 300  # optional per-record override of default_ttl
    },
  ]

  cname_records = [
    { name = "www", cname = "web-server-01.hashicorp.local." },
  ]
}
```

## TTL behavior

Each record's TTL is `coalesce(record.ttl, var.default_ttl)`. The module
default is **60 seconds** — deliberately low because hosts here are frequently
destroyed and recreated with new IPs, and the `hashicorp/dns` provider's own
default of 3600s (1 hour) leaves clients caching a stale, now-dead address long
after a rebuild. Set a higher `default_ttl`, or a per-record `ttl`, for records
that rarely change.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `zone` | `string` | `"hashicorp.local."` | Target zone; must end with a trailing dot. |
| `default_ttl` | `number` | `60` | TTL (seconds) for records that don't set their own. |
| `a_records` | `list(object({ name, addresses, ttl? }))` | `[]` | A records to create. |
| `cname_records` | `list(object({ name, cname, ttl? }))` | `[]` | CNAME records to create. |

## Outputs

| Name | Description |
|------|-------------|
| `a_record_ids` | Map of A-record index → record ID. |
| `a_record_fqdns` | List of A-record FQDNs created in the zone. |
| `cname_record_ids` | Map of CNAME-record name → record ID. |
