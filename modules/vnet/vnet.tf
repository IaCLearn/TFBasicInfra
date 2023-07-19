provider "azurerm" {
  features {}
 alias = "hubsubscription"
 #hub subscription id with the hub vnet
 subscription_id ="10c1c1c4-c34c-4a6f-b4bd-8560ab234169"
  
}

provider "azurerm" {
  features {}
  #spoke subscription id
  subscription_id ="1dbe1551-e906-4749-81e8-6a1720c3998d" 
}





resource "azurerm_virtual_network" "virtual_network" {
  name = var.vnet_name
  location = var.location
 resource_group_name = var.vnetrgname
  address_space = [var.network_address_space]
  

  tags = {
    Environment = var.environment
  }

}


resource "azurerm_virtual_network_dns_servers" "spoke_dns" {
  
  virtual_network_id = azurerm_virtual_network.virtual_network.id
  dns_servers        = var.dnsservers
}

resource "azurerm_subnet" "app_subnet" {
  name = var.app_subnet_address_name
   resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.app_subnet_address_prefix]
}


resource "azurerm_subnet" "db_subnet" {
  name = var.db_subnet_address_name
  resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.db_subnet_address_prefix]
}



resource "azurerm_subnet" "dbbi_subnet" {
  name = var.dbbi_subnet_address_name
  resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.dbbi_subnet_address_prefix]
}

resource "azurerm_subnet" "appgw_subnet" {
  name = var.appgw_subnet_address_name
 resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.appgw_subnet_address_prefix]
}

resource "azurerm_subnet" "appbkend_subnet" {
  name = var.appbkend_subnet_address_name
   resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.appbkend_subnet_address_prefix]
}

resource "azurerm_subnet" "appbrst_subnet" {
  name = var.appbrst_subnet_address_name
   resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.appbrst_subnet_address_prefix]
}

resource "azurerm_subnet" "pe_subnet" {
  name = var.pe_subnet_address_name
   resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.pe_subnet_address_prefix]
}

resource "azurerm_subnet" "mrz_subnet" {
  name = var.mrz_subnet_address_name
   resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.mrz_subnet_address_prefix]
}

resource "azurerm_subnet" "inrule_subnet" {
  name = var.inrule_subnet_address_name
   resource_group_name = var.vnetrgname
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes = [var.inrule_subnet_address_prefix]
}




#appbkend_subnet (Corris Services subnet)
resource "azurerm_subnet_network_security_group_association" "nsg_corris" {
  subnet_id = azurerm_subnet.appbkend_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_coris.id

  depends_on = [
    azurerm_subnet.app_subnet,azurerm_network_security_group.nsg_coris
  ]
}


resource "azurerm_subnet_network_security_group_association" "nsg_inrule" {
  subnet_id = azurerm_subnet.inrule_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_inrule.id

  depends_on = [
    azurerm_subnet.appbkend_subnet, azurerm_network_security_group.nsg_inrule
  ]
}



resource "azurerm_network_security_group" "nsg_sql" {
  name = var.sql_nsg_name
  resource_group_name = var.vnetrgname
  location = var.location
  security_rule {
   name                        = "Allow_App_SQL"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix   = "*"
  //destination_address_prefix  = "*"
  destination_application_security_group_ids =[ azurerm_application_security_group.asgsqlservers.id]
  }
}


resource "azurerm_network_security_group" "nsg_presentation" {
  name = var.app_nsg_name
  location = var.location
  resource_group_name = var.vnetrgname
  security_rule {
   name                        = "Allow_RDP_VPN"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix    = "*"
  //destination_address_prefix  = "*"
  destination_application_security_group_ids =[azurerm_application_security_group.asgwebservers.id]
  }
   security_rule  {
  name                        = "Allow_App_Http"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix   = "*"
  destination_application_security_group_ids =[azurerm_application_security_group.asgwebservers.id]

  }
}

resource "azurerm_network_security_group" "nsg_coris" {
  name = var.corris_nsg_name
  location = var.location
  resource_group_name = var.vnetrgname
  security_rule {
      name                        = "Allow_App_Https"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix   = "*"
  destination_application_security_group_ids =[azurerm_application_security_group.asgcorisservers.id]

  }
}

resource "azurerm_network_security_group" "nsg_appbrst" {
  name = var.appbrst_nsg_name
  location = var.location
  resource_group_name = var.vnetrgname
  security_rule {

  name                        = "Allow_RDP_VPN"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges = [6105,6109,6120,6711,6751]
  source_address_prefix    = "*"
  destination_application_security_group_ids =[azurerm_application_security_group.asgbrstservers.id]

  }
  security_rule  {
  name                        = "Allow_App_Https"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix   = "*"
  destination_application_security_group_ids =[azurerm_application_security_group.asgbrstservers.id]

  }
}


resource "azurerm_network_security_group" "nsg_jumbpox" {
  name = var.jmpbox_nsg_name
  resource_group_name = var.vnetrgname
  location = var.location
  security_rule {
   name                        = "Allow_RDP_VPN"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix    = "*"
    destination_application_security_group_ids =[azurerm_application_security_group.asgjmpservers.id]
  }
}

resource "azurerm_network_security_group" "nsg_inrule" {
  name = var.inrule_nsg_name
  resource_group_name = var.vnetrgname
  location = var.location
   security_rule {
   name                        = "Allow_RDP_VPN"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix    = "*"
    destination_application_security_group_ids =[azurerm_application_security_group.asginruleservers.id]
  }
   security_rule  {
  name                        = "Allow_App_Http"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix   = "*"
  destination_application_security_group_ids =[azurerm_application_security_group.asginruleservers.id]

  }
  
}


#NSG Association 
resource "azurerm_subnet_network_security_group_association" "nsg_jumbpox" {
  subnet_id = azurerm_subnet.mrz_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_jumbpox.id

  depends_on = [
  azurerm_subnet.mrz_subnet, azurerm_network_security_group.nsg_jumbpox
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_sql" {
  subnet_id = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_sql.id


  depends_on = [
  azurerm_subnet.db_subnet, azurerm_network_security_group.nsg_sql
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_sql1" {
  subnet_id = azurerm_subnet.dbbi_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_sql.id


  depends_on = [
  azurerm_subnet.dbbi_subnet, azurerm_network_security_group.nsg_sql
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_presentation" {
  subnet_id = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_presentation.id

  depends_on = [
    azurerm_subnet.app_subnet, azurerm_network_security_group.nsg_presentation
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_appbrst" {
  subnet_id = azurerm_subnet.appbrst_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_appbrst.id

  depends_on = [
    azurerm_subnet.app_subnet, azurerm_network_security_group.nsg_appbrst
  ]
}

resource "azurerm_application_security_group" "asgjmpservers" {
  name                = var.asgjmpservernames
  location=var.location
   resource_group_name = var.vnetrgname

}

resource "azurerm_application_security_group" "asginruleservers" {
  name                = var.asginruleservernames
  location=var.location
   resource_group_name = var.vnetrgname

}

resource "azurerm_application_security_group" "asgwebservers" {
  name                = var.asgwebservernames
  location=var.location
   resource_group_name = var.vnetrgname

}
resource "azurerm_application_security_group" "asgcorisservers" {
  name                = var.asgcorisservernames
  location=var.location
   resource_group_name = var.vnetrgname

}

resource "azurerm_application_security_group" "asgbrstservers" {
  name                = var.asgbrstservernames
  location=var.location
   resource_group_name = var.vnetrgname

}

resource "azurerm_application_security_group" "asgsqlservers" {
  name                = var.asgsqlservernames
  location=var.location
   resource_group_name = var.vnetrgname

}




resource "azurerm_route_table" "RT_OnPrem" {
    count = var.environment != "Development" ? 1 : 0 
  name                = "example-routetable"
 location=var.location
   resource_group_name = var.vnetrgname

  route {
    name                   = "example"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}

resource "azurerm_subnet_route_table_association" "app_assos" {
  count = var.environment != "Development" ? 1 : 0 
  subnet_id      = azurerm_subnet.app_subnet.id
  route_table_id = azurerm_route_table.RT_OnPrem[0].id
}

resource "azurerm_subnet_route_table_association" "db_assos" {
  count = var.environment != "Development" ? 1 : 0 
  subnet_id      = azurerm_subnet.db_subnet.id
  route_table_id = azurerm_route_table.RT_OnPrem[0].id
}

resource "azurerm_subnet_route_table_association" "appbrst_assos" {
  count = var.environment != "Development" ? 1 : 0 
  subnet_id      = azurerm_subnet.appbrst_subnet.id
  route_table_id = azurerm_route_table.RT_OnPrem[0].id
}
#peering new virtual network to existing hub section
data "azurerm_virtual_network" "existinghubnetwork" {
  name                = "advnet"
  resource_group_name = "ADDomain"
  provider = azurerm.hubsubscription
}


resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
  provider = azurerm.hubsubscription
    name                      = "hub-spoke1-peer"
    resource_group_name       = "ADDomain"
    virtual_network_name      = "advnet"
    remote_virtual_network_id =azurerm_virtual_network.virtual_network.id
    allow_virtual_network_access = true
    allow_forwarded_traffic   = true
    allow_gateway_transit     = false
    use_remote_gateways       = false
}


resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
provider = azurerm
    name                      = "spoke1-hub-peer"
 resource_group_name = var.vnetrgname
    virtual_network_name      = azurerm_virtual_network.virtual_network.name
    remote_virtual_network_id = data.azurerm_virtual_network.existinghubnetwork.id
    allow_virtual_network_access = true
    allow_forwarded_traffic = true
    allow_gateway_transit   = false
    use_remote_gateways     =false
}