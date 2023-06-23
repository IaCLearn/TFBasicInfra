
locals {
    flat_list = setproduct(var.storage_list, var.containers_list)
}

data "azurerm_resource_group" "keyvault" {
  name = "${var.existingrgname}-rg"
}
resource "azurerm_storage_account" "storage_account" {
  for_each = toset(var.storage_list) 
  name=each.value
   location = data.azurerm_resource_group.keyvault.location
  resource_group_name = data.azurerm_resource_group.keyvault.name
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  for_each              = {for idx, val in local.flat_list: idx => val}
  name                  = each.value[1].name
  container_access_type = each.value[1].access_type
  storage_account_name  = azurerm_storage_account.storage_account[each.value[0]].name
}

