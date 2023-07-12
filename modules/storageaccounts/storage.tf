
locals {
    flat_list = setproduct(var.storage_list, var.containers_list)
}


resource "azurerm_storage_account" "storage_account" {
  for_each = toset(var.storage_list) 
  name=each.value
   location = var.location
  resource_group_name = var.existingrgname
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  for_each              = {for idx, val in local.flat_list: idx => val}
  name                  = each.value[1].name
  container_access_type = each.value[1].access_type
  storage_account_name  = azurerm_storage_account.storage_account[each.value[0]].name
}

resource "azurerm_private_endpoint" "private_endpoint" {
  for_each            = toset(var.storage_list)
 name                = "pe-${each.value}"
  location            = var.location
  resource_group_name = var.existingrgname
  subnet_id           = var.endpoints_subnet_id
  private_service_connection {
   name                           = "pe-${each.value}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.storage_account[each.value].id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [var.stg_private_dns_zone_ids]
  }

}