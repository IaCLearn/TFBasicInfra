output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}
output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}
output "appbrst_subnet_id" {
  value = azurerm_subnet.appbrst_subnet.id
}
output  "appbkend_subnet_id" {
  value = azurerm_subnet.appbkend_subnet.id
}
output "appgw_subnet_id" {
  value = azurerm_subnet.appgw_subnet.id
}
output "pe_subnet_id"{
  value =azurerm_subnet.pe_subnet.id
}

output "dbbi_subnet_id"{
  value =azurerm_subnet.dbbi_subnet.id
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


output "asgwebserversid" {
  value = azurerm_application_security_group.asgwebservers.id
}

output "asgsqlserversid" {
  value = azurerm_application_security_group.asgsqlservers.id
}


