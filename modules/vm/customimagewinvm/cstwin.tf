resource "azurerm_network_interface" "appbackend-nic" {
  count               = "${var.appbkendcount}"
  name                = "${var.appbkend_names}${count.index+1}-nic"
  resource_group_name = var.appbkendvmrg_name
  location           = var.location

  ip_configuration {
    name = "${var.appbkend_names}${count.index+1}-ipconfig"
    subnet_id = var.existingappbkendsnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "cstwininst" {
  count                 = var.appbkendcount                            
  name                  = "${var.appbkend_names}${count.index+1}vm"
 resource_group_name = var.appbkendvmrg_name
  location           = var.location

  network_interface_ids = [azurerm_network_interface.appbackend-nic[count.index+1].id]
 vm_size  =var.cstwinvmsize

   storage_image_reference {
    id = var.win_source_image_id
  }
  storage_os_disk {
    name              = "${var.appbkend_names}${count.index+1}-osdisk"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    caching           = "ReadWrite"
  }

  os_profile {
    computer_name  ="${var.appbkend_names}${count.index+1}vm"
    admin_username = var.vmusername
    admin_password = var.vmpassword
  }

    os_profile_windows_config {
      provision_vm_agent = true
  }

 }