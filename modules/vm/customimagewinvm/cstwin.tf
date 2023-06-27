resource "azurerm_resource_group" "vm_r" {
  name     = "${var.brstvmrg_name}-rg"
  location = var.location
  
  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_interface" "webbfe-nic" {
  count               = "${var.webbfecount}"
  name                = "${var.webbfe_names}${count.index}-nic"
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            =azurerm_resource_group.vm_resource_group.location

  ip_configuration {
    name = "${var.webbfe_names}${count.index}-ipconfig"
    subnet_id = var.existingappbrstsnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "cstwininst" {
  count                 = var.webbfecount                               
  name                  = "${var.webbfe_names}${count.index}"
 location            =azurerm_resource_group.vm_resource_group.location
  resource_group_name   = azurerm_resource_group.vm_resource_group.name
  network_interface_ids = [azurerm_network_interface.webbfe-nic[count.index].id]
  size =var.cstlinuxvmsize
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
}
  source_image_id =var.source_image_id
  admin_username = var.vmusername
  admin_password = var.vmpassword
  disable_password_authentication = false

}