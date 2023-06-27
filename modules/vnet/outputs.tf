output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}
output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}
output "appbrst_subnet_id" {
  value = azurerm_subnet.appbrst_subnet.id
}



output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}

output "vnet_id" {
  value = azurerm_virtual_network.virtual_network.id
}

output "vnet_name" {
  value = azurerm_virtual_network.virtual_network.name
}


output "sqlnsg_name" {
  value =  azurerm_network_security_group.nsg_sql.id
}

output "appnsg_name" {
  value =  azurerm_network_security_group.nsg_app.id
}

output "resource_group" {
  value = azurerm_resource_group.vnet_resource_group.name
}

output "resource_group_id" {
  value = azurerm_resource_group.vnet_resource_group.id
}