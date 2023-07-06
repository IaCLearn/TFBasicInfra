

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


}