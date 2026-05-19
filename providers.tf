terraform {
  required_version = ">= 1.5.0"

  required_providers {
    dns = {
      source  = "hashicorp/dns"
      # hashicorp/dns 3.6.0 bumped bodgit/tsig 1.2.2 -> 1.3.0 which broke
      # GSS-TSIG against Windows AD DNS (see hashicorp/terraform-provider-dns#642
      # and bodgit/tsig#178). Pin below 3.6.0 until the upstream regression
      # (bodgit/gssapi missing hasPeerSubkey check, PR bodgit/gssapi#50) lands
      # in a new tsig release picked up by the provider.
      version = ">= 3.4.3, < 3.6.0"
    }
  }
}
