resource "azurerm_network_interface" "appbackend-nic" {
  for_each = var.wincstvmlist
  name                = "${each.key}-nic"
  resource_group_name = var.appbkendvmrg_name
  location           = var.location

  ip_configuration {
    name = "${each.key}-ipconfig"
    subnet_id="${each.value.subnetname}" == "appbrstsnet" ?  var.existingappbkendsnetid : "${each.value.subnetname}" == "appsnet" ? var.existingappsnetid:""
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

 resource "azurerm_virtual_machine_extension" "winvm_extension_modify_fw" {
    for_each = var.wincstvmlist
    name = "${each.key}"
    virtual_machine_id = azurerm_windows_virtual_machine.cstwininst[each.key].id
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
   azurerm_windows_virtual_machine.cstwininst
    ]
}



resource "azurerm_virtual_machine_extension" "windomjoin" {
for_each = var.wincstvmlist
name ="${each.key}domjoin"
virtual_machine_id =  azurerm_windows_virtual_machine.cstwininst[each.key].id
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
 depends_on = [azurerm_windows_virtual_machine.cstwininst,azurerm_virtual_machine_extension.winvm_extension_modify_fw]
}