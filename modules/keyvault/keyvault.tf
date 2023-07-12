

data "azurerm_client_config" "current" {}
#Key vault name must be globally unique
resource "azurerm_key_vault" "keyvault" {


 for_each = toset(var.keyvaultlist) 
  name=each.value
  location                    = var.location
  resource_group_name         = var.existingrgname
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.kvsku_name
network_acls {
    default_action = "Deny"
    ip_rules       = []
    bypass         ="AzureServices"
  }

}

resource "azurerm_private_endpoint" "pekv" {
  for_each = toset(var.keyvaultlist) 
  name                = "pe-${each.value}"
  location            = var.location
  resource_group_name = var.existingrgname
  subnet_id           = var.endpoints_subnet_id

  private_service_connection {
    name                           = "pe-${each.value}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.keyvault[each.value].id
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.kv_private_dns_zone_ids]
  }

}
