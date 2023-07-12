resource "azurerm_network_interface" "app-nic" {

  for_each = var.wingenlist
name                = "${each.key}-nic"
 location            = var.location
  resource_group_name = var.apprg_name

  ip_configuration {
    name                          = "${each.key}-ipconfig"
      subnet_id                     = var.existingappsnetid
    private_ip_address_allocation = "Dynamic"
  
  }
}

resource "azurerm_network_interface_application_security_group_association" "asgwebserverassoc" {
    for_each = var.wingenlist
  network_interface_id          =azurerm_network_interface.app-nic[each.key].id
  application_security_group_id = var.asgwebserverid
}

resource "azurerm_virtual_machine" "winvm" {
  for_each = var.wingenlist
  name     = each.key
   location            = var.location
  resource_group_name = var.apprg_name
  network_interface_ids = [azurerm_network_interface.app-nic[each.key].id]
  vm_size              = each.value.size

  storage_image_reference {
    publisher = var.publisher_windows
    offer     = var.offer_windows
    sku       = var.sku_windows
    version   = var.version_windows
  }

  storage_os_disk {
    name              = "${each.key}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    
  }
  storage_data_disk {
    name              = "${each.key}-DATA"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 256
    lun               = 0
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "${each.key}-LOG"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 128
    lun               = 1
    managed_disk_type = "Premium_LRS"
    
  }

  os_profile {
    computer_name  = "${each.key}"
    admin_password = var.vmpassword
    admin_username = var.vmusername
  }
 os_profile_windows_config {
    timezone           = "UTC"
    provision_vm_agent = true
  }

}


resource "azurerm_virtual_machine_extension" "winvm_extension_modify_fw" {
    for_each = var.wingenlist
    name = "${each.key}"
    virtual_machine_id = azurerm_virtual_machine.winvm[each.key].id
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
for_each = var.wingenlist
name ="${each.key}domjoin"
virtual_machine_id =  azurerm_virtual_machine.winvm[each.key].id
publisher = "Microsoft.Compute"
type = "JsonADDomainExtension"
type_handler_version = "1.3"

settings = <<SETTINGS
{
"Name": "${var.domainname}",
"OUPath":"${var.oupath != null ? var.oupath: ""}",
"User": "${var.domainname}\\${var.domainusername}",
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