data "azurerm_resource_group" "keyvault" {
  name = "${var.existingrgname}-rg"
}
# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "example" {
  name                = "example-cache"
 location                    = data.azurerm_resource_group.keyvault.location
  resource_group_name         = data.azurerm_resource_group.keyvault.name
  capacity            = var.capacity
  family              = var.redisfamily
  sku_name            = var.sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"
  public_network_access_enabled = false

 
}