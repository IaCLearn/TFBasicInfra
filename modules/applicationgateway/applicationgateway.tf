data "azurerm_resource_group" "appgwrg" {
  name = "${var.existingrgname}-rg"
}


resource "azurerm_public_ip" "pip" {
  name                = var.appgwpip
   location   = data.azurerm_resource_group.appgwrg.location
  resource_group_name= data.azurerm_resource_group.appgwrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_application_gateway" "appgw" {
  name = var.appgwname
  location= data.azurerm_resource_group.appgwrg.location
  resource_group_name= data.azurerm_resource_group.appgwrg.name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = var.appgwipconfigname
    subnet_id = var.existingappgwsubnetid
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
   
    
  }
   frontend_ip_configuration{
    name = var.private_frontend_ip_configuration_name
    subnet_id = var.existingappgwsubnetid
    private_ip_address_allocation ="static"
    private_ip_address = "192.168.1.10"
    
  }

  backend_address_pool {
    name = var.backend_address_pool_name
    fqdns = var.backendaddresspoolfqdns
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority                   = 1
  }
}


