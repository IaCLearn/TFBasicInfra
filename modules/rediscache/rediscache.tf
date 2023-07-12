
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "azredcache" {
  for_each = toset(var.rediscachelist) 
  name=each.value
  location                    = var.location
  resource_group_name         = var.existingrgname
  capacity            = var.capacity
  family              = var.redisfamily
  sku_name            = var.sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  public_network_access_enabled = false
 
}


resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = toset(var.rediscachelist)
 name                = "pe-${each.value}"
  location            = var.location
  resource_group_name = var.existingrgname
  subnet_id           = var.endpoints_subnet_id
  private_service_connection {
   name                           = "pe-${each.value}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.azredcache[each.value].id
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.rdc_private_dns_zone_ids]
  }

}