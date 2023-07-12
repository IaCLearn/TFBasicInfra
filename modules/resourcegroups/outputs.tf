output "vnetrgname" {
  value =  values(azurerm_resource_group.rg)[0].name
}

output "apprgname" {
  value =  values(azurerm_resource_group.rg)[1].name
}

output "pergname" {
  value =  values(azurerm_resource_group.rg)[2].name
}
