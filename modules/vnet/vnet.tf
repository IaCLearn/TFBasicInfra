resource "azurerm_resource_group" "vnet_resource_group" {
  name     = "${var.name}-rg"
  location = var.location
  
  tags = {
    Environment = var.environment
  }
}

resource "azurerm_virtual_network" "virtual_network" {
  name = var.name
  location = var.location
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
  address_space = [var.network_address_space]
  

  tags = {
    Environment = var.environment
  }

}


resource "azurerm_virtual_network_dns_servers" "spoke_dns" {
  virtual_network_id = azurerm_virtual_network.virtual_network.id
  dns_servers        = [var.dnsservers]
}

resource "azurerm_subnet" "app_subnet" {
  name = var.app_subnet_address_name
  resource_group_name  = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.app_subnet_address_prefix]
}


resource "azurerm_subnet" "db_subnet" {
  name = var.db_subnet_address_name
  resource_group_name  = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.db_subnet_address_prefix]
}

resource "azurerm_subnet" "appgw_subnet" {
  name = var.appgw_subnet_address_name
  resource_group_name  = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.appgw_subnet_address_prefix]
}


resource "azurerm_network_security_group" "nsg_sql" {
  name = var.sql_nsg_name
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
  location=azurerm_resource_group.vnet_resource_group.location
}


resource "azurerm_network_security_group" "nsg_app" {
  name = var.app_nsg_name
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
  location=azurerm_resource_group.vnet_resource_group.location
}

resource "azurerm_subnet_network_security_group_association" "nsg_sql" {
  subnet_id = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_sql.id

  depends_on = [
   azurerm_resource_group.vnet_resource_group, azurerm_subnet.db_subnet, azurerm_network_security_group.nsg_sql
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_app" {
  subnet_id = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_app.id

  depends_on = [
   azurerm_resource_group.vnet_resource_group, azurerm_subnet.app_subnet, azurerm_network_security_group.nsg_app
  ]
}

resource "azurerm_network_security_rule" "rdp_sql" {
  name                        = "Allow_RDP_VPN"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix    = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet_resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg_sql.name
}

resource "azurerm_network_security_rule" "sql" {
  name                        = "Allow_App_SQL"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix   = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet_resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg_sql.name
}

resource "azurerm_network_security_rule" "app" {
  name                        = "Allow_App_Https"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix   = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnet_resource_group.name
  network_security_group_name = azurerm_network_security_group.nsg_app.name
}

resource "azurerm_route_table" "RT_OnPrem" {
  name                = "example-routetable"
  location            = azurerm_resource_group.vnet_resource_group.location
  resource_group_name =azurerm_resource_group.vnet_resource_group.name

  route {
    name                   = "example"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_subnet_route_table_association" "app_assos" {
  subnet_id      = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.RT_OnPrem.id
}

resource "azurerm_subnet_route_table_association" "db_assos" {
  subnet_id      = azurerm_subnet.db_subnet.id
  route_table_id = azurerm_route_table.RT_OnPrem.id
}


#peering new virtual network to existing hub section
data "azurerm_virtual_network" "existinghubnetwork" {
  name                = "advnet"
  resource_group_name = "ADDomain"
}


resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
    name                      = "hub-spoke1-peer"
    resource_group_name       = "ADDomain"
    virtual_network_name      = "advnet"
    remote_virtual_network_id =azurerm_virtual_network.virtual_network.id
    allow_virtual_network_access = true
    allow_forwarded_traffic   = true
    allow_gateway_transit     = false
    use_remote_gateways       = false
    depends_on = [azurerm_virtual_network.virtual_network,azurerm_network_security_group.nsg_sql,azurerm_network_security_group.nsg_app]
}


resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
    name                      = "spoke1-hub-peer"
    resource_group_name       =azurerm_resource_group.vnet_resource_group.name
    virtual_network_name      = azurerm_virtual_network.virtual_network.name
    remote_virtual_network_id = data.azurerm_virtual_network.existinghubnetwork.id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit   = false
    use_remote_gateways     =false
    depends_on = [azurerm_virtual_network.virtual_network,azurerm_network_security_group.nsg_sql,azurerm_network_security_group.nsg_app]
}