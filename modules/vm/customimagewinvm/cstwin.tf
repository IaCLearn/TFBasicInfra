resource "azurerm_network_interface" "appbackend-nic" {
  for_each = var.wincstvmlist
  name                = "${each.key}-nic"
  resource_group_name = var.appbkendvmrg_name
  location           = var.location

  ip_configuration {
    name = "${each.key}-ipconfig"
    subnet_id = var.existingappbkendsnetid
    private_ip_address_allocation = "Dynamic"
  }
}




 resource "azurerm_windows_virtual_machine" "cstwininst" {
  for_each = var.wincstvmlist           
  name     = each.key
 resource_group_name = var.appbkendvmrg_name
  location           = var.location
admin_username      = var.vmusername
  admin_password      = var.vmpassword
  network_interface_ids = [azurerm_network_interface.appbackend-nic[each.key].id]
 size  =each.value.size
  source_image_id=var.win_source_image_id
  os_disk {
 
    caching              = "ReadWrite"
    storage_account_type="Standard_LRS"
  }

 

 }