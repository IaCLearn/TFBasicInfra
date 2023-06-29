resource "azurerm_network_interface" "webbfe-nic" {
  count               = "${var.webbfecount}"
  name                = "${var.webbfe_names}${count.index}-nic"
  location            = var.location
  resource_group_name = var.brstvmrg_name

  ip_configuration {
    name = "${var.webbfe_names}${count.index+1}-ipconfig"
    subnet_id = var.existingappbrstsnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "webbfevms" {
  count                 = var.webbfecount                               
  name                  = "${var.webbfe_names}${count.index + 1}vm"
 location            = var.location
  resource_group_name = var.brstvmrg_name
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