resource "azurerm_resource_group" "rg" {
 // for_each    = toset(var.resource_groups)
for_each= { for k, v in var.resource_groups: format("%04d", v.id) => v }
    name      = each.value.name
    location  = each.value.location

}