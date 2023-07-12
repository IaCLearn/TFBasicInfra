resource "azurerm_private_dns_zone" "pednsname" {
    for_each= { for k, v in var.privatednszonenames: format("%04d", v.id) => v }
 name      = each.value.name
  resource_group_name = var.existingrgname
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
   for_each= { for k, v in var.privatednszonenames: format("%04d", v.id) => v }
  name                  = "vnet_link"
  resource_group_name   =var.existingrgname
  private_dns_zone_name =  each.value.name
  virtual_network_id    =var.existingvnetid
  depends_on = [ azurerm_private_dns_zone.pednsname ]
}