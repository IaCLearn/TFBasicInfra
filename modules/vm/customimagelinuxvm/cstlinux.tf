resource "azurerm_network_interface" "webbfe-nic" {
 for_each = var.lincstvmlist
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.brstvmrg_name

  ip_configuration {
    name = "${each.key}-ipconfig"
    subnet_id="${each.value.subnetname}" == var.app_subnet_address_name ? var.existingappsnetid:""
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "webbfevms" {
  for_each = var.lincstvmlist                          
  name                  = each.key
 location            = var.location
  resource_group_name = var.brstvmrg_name
  network_interface_ids = [azurerm_network_interface.webbfe-nic[each.key].id]
  size = each.value.size
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
}
  source_image_id =each.value.osimageid
  admin_username = var.vmusername
  admin_password = var.vmpassword
  disable_password_authentication = false

}


resource "azurerm_network_interface_application_security_group_association" "asglinpresboxassoc" {
   for_each = {
    for k, v in var.lincstvmlist : k => v
    if v.type=="presentation"
  }
  
  network_interface_id          =azurerm_network_interface.webbfe-nic[each.key].id
  application_security_group_id = var.asgwebserversid
}