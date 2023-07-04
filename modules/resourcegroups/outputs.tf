output "vnetrgname" {
  value =  values(azurerm_resource_group.rg)[0].name
}

output "apprgname" {
  value =  values(azurerm_resource_group.rg)[1].name
}
