#Windows Server for app web VM
# Define the virtual machines
resource "azurerm_network_interface" "app-nic" {
  count               = "${var.appvmcount}"
  name                = "${var.appvm_names}${count.index+1}-nic"
 location            = var.location
  resource_group_name = var.apprg_name

  ip_configuration {
    name                          = "${var.appvm_names}${count.index+1}-ipconfig"
      subnet_id                     = var.existingappsnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "winvm" {
  count                = "${var.appvmcount}"
  name                 = "${var.appvm_names}${count.index+1}vm"
   location            = var.location
  resource_group_name = var.apprg_name
  network_interface_ids = [azurerm_network_interface.app-nic[count.index].id]
  vm_size              = "Standard_DS2_v2"

  storage_image_reference {
    publisher = var.publisher_windows
    offer     = var.offer_windows
    sku       = var.sku_windows
    version   = var.version_windows
  }

  storage_os_disk {
    name              = "${var.appvm_names}${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  storage_data_disk {
    name              = "${var.appvm_names}${count.index}-DATA"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 256
    lun               = 0
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "${var.appvm_names}${count.index}-LOG"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 128
    lun               = 1
    managed_disk_type = "Premium_LRS"
    
  }

  os_profile {
    computer_name  = "${var.appvm_names}${count.index}"
    admin_password = var.vmpassword
    admin_username = var.vmusername
  }
 os_profile_windows_config {
    timezone           = "UTC"
    provision_vm_agent = true
  }

}


resource "azurerm_virtual_machine_extension" "winvm_extension_modify_fw" {
    count= "${var.appvmcount}"
    name = "vm_modify_fw"
    virtual_machine_id = azurerm_virtual_machine.winvm[count.index].id
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.8"
    auto_upgrade_minor_version = true
    settings = <<SETTINGS
    {
    "commandToExecute": "powershell Set-NetFirewallProfile -Profile Domain -Enabled False;Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
    SETTINGS

     depends_on = [
   azurerm_virtual_machine.winvm
    ]
}

resource "azurerm_virtual_machine_extension" "windomjoin" {
 count = "${var.appvmcount}"
name = "domjoin"
virtual_machine_id =  azurerm_virtual_machine.winvm[count.index].id
publisher = "Microsoft.Compute"
type = "JsonADDomainExtension"
type_handler_version = "1.3"

settings = <<SETTINGS
{
"Name": "phebsix.com",
"User": "phebsix\\localadmin",
"Restart": "true",
"Options": "3"
}
SETTINGS
protected_settings = <<PROTECTED_SETTINGS
{
"Password": "${var.vm_dompassword}"
}
PROTECTED_SETTINGS
 depends_on = [azurerm_virtual_machine.winvm,azurerm_virtual_machine_extension.winvm_extension_modify_fw]
}