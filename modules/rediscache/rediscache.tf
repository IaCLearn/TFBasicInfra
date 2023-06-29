
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "azredcache" {
  name                = "errovam002"
 location                    = var.location
  resource_group_name         = var.existingrgname
  capacity            = var.capacity
  family              = var.redisfamily
  sku_name            = var.sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  public_network_access_enabled = false

 
}