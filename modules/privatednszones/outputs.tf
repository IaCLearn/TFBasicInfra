output "privatednszoneidstorage" {
  value =values(azurerm_private_dns_zone.pednsname)[0].name
}

output "privatednszoneidkeyvault" {
  value =values(azurerm_private_dns_zone.pednsname)[1].name
}

output "privatednszoneidrediscache" {
    value =values(azurerm_private_dns_zone.pednsname)[2].name
}

output "privatednszoneidstorageid" {
  value =values(azurerm_private_dns_zone.pednsname)[0].id
}

output "privatednszoneidkeyvaultid" {
  value =values(azurerm_private_dns_zone.pednsname)[1].id
}

output "privatednszoneidrediscacheid" {
    value =values(azurerm_private_dns_zone.pednsname)[2].id
}