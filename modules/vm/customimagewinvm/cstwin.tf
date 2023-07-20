resource "azurerm_network_interface" "appbackend-nic" {
  for_each = var.wincstvmlist
  name                = "${each.key}-nic"
  resource_group_name = var.appbkendvmrg_name
  location           = var.location

  ip_configuration {
    name = "${each.key}-ipconfig"
    subnet_id="${each.value.subnetname}" == var.appbrst_subnet_address_name ? var.existingappbrstsnetid : "${each.value.subnetname}" == var.app_subnet_address_name ? var.existingappsnetid: "${each.value.subnetname}" == var.db_subnet_address_name ? var.existingdbsnetid:"${each.value.subnetname}" == var.dbbi_subnet_address_name ? var.existingdbbisnetid:"${each.value.subnetname}" == var.mrz_subnet_address_name ? var.existingmrzsnetid:"${each.value.subnetname}" == var.appbkend_subnet_address_name ? var.existingappbkendsnetid:""
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_application_security_group_association" "asgsqlserverassoc" {
    
    for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.type=="sql"
  }
  network_interface_id          =azurerm_network_interface.appbackend-nic[each.key].id
  application_security_group_id = var.asgsqlserverid
}


resource "azurerm_network_interface_application_security_group_association" "asgjmpboxassoc" {
     for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.type=="jumpbox"
  }
  network_interface_id  =azurerm_network_interface.appbackend-nic[each.key].id
  application_security_group_id = var.asgjmpserversid
}

resource "azurerm_network_interface_application_security_group_association" "asgwinpresboxassoc" {
     for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.type=="presentation"
  }
  network_interface_id          =azurerm_network_interface.appbackend-nic[each.key].id
  application_security_group_id = var.asgwebserversid
}

resource "azurerm_network_interface_application_security_group_association" "asgwinbrstassoc" {
   for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.type=="brst"
  }
  network_interface_id          =azurerm_network_interface.appbackend-nic[each.key].id
  application_security_group_id = var.asgbrstserversid
}

resource "azurerm_network_interface_application_security_group_association" "asgwincorrisassoc" {
      for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.type=="coris"
  }
  network_interface_id          =azurerm_network_interface.appbackend-nic[each.key].id
  application_security_group_id = var.asgcorrisserversid
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
  source_image_id=each.value.osimageid
  os_disk {
 
    caching              = "ReadWrite"
    storage_account_type="Standard_LRS"
  }
 

 }

# add a data disk - we were going to iterate through a collection and check if the datadisk attribute is not null
resource "azurerm_managed_disk" "datadisk" {

 for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.datadisk!=null
  }
    name                    = "${each.key}-data-disk" 
    resource_group_name = var.appbkendvmrg_name
  location           = var.location
    storage_account_type    = "Premium_LRS"
    create_option           = "Empty"
    disk_size_gb            = each.value.datadisk
    depends_on = [
        azurerm_windows_virtual_machine.cstwininst
    ]

}

resource "azurerm_virtual_machine_data_disk_attachment" "datadisk_attach" {
   for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.datadisk!=null
  }
    managed_disk_id    = azurerm_managed_disk.datadisk[each.key].id
    virtual_machine_id = azurerm_windows_virtual_machine.cstwininst[each.key].id
    lun                = 0
    caching            = "ReadWrite"

    depends_on = [
        azurerm_windows_virtual_machine.cstwininst,azurerm_managed_disk.datadisk
    ]
}


# add a log disk - we were going to iterate through a collection and check if the logdisk attribute is not null
resource "azurerm_managed_disk" "logdisk" {

 for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.logdisks!=null
  }
    name                    = "${each.key}-log-disk" 
    resource_group_name = var.appbkendvmrg_name
  location           = var.location
    storage_account_type    = "Premium_LRS"
    create_option           = "Empty"
    disk_size_gb            = each.value.logdisks
depends_on = [
        azurerm_windows_virtual_machine.cstwininst
    ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "logdisk_attach" {
   for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.logdisks!=null
  }
    managed_disk_id    = azurerm_managed_disk.logdisk[each.key].id
    virtual_machine_id = azurerm_windows_virtual_machine.cstwininst[each.key].id
    lun                = 1
    caching            = "ReadWrite"
    depends_on = [
        azurerm_windows_virtual_machine.cstwininst,azurerm_managed_disk.logdisk
    ]
}



resource "azurerm_managed_disk" "tempdbdisk" {

 for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.tempdbdisk!=null
  }
    name                    = "${each.key}-temp-disk" 
    resource_group_name = var.appbkendvmrg_name
  location           = var.location
    storage_account_type    = "Premium_LRS"
    create_option           = "Empty"
    disk_size_gb            = each.value.tempdbdisk
depends_on = [
        azurerm_windows_virtual_machine.cstwininst
    ]
}

resource "azurerm_virtual_machine_data_disk_attachment" "tempdbdisk_attach" {
   for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.tempdbdisk!=null
  }
    managed_disk_id    = azurerm_managed_disk.tempdbdisk[each.key].id
    virtual_machine_id = azurerm_windows_virtual_machine.cstwininst[each.key].id
    lun                = 2
    caching            = "ReadWrite"
    depends_on = [
        azurerm_windows_virtual_machine.cstwininst,azurerm_managed_disk.tempdbdisk
    ]
}






 resource "azurerm_virtual_machine_extension" "winvm_extension_modify_fw" {
    //for_each = var.wincstvmlist
     for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.installIIS==null
  }
    name = "${each.key}"
    virtual_machine_id =azurerm_windows_virtual_machine.cstwininst[each.key].id
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.8"
    auto_upgrade_minor_version = true
    settings = <<SETTINGS
    {
    "commandToExecute": "powershell Set-NetFirewallProfile -Profile Domain -Enabled False;"
    }
    SETTINGS

     depends_on = [
azurerm_windows_virtual_machine.cstwininst
    ]
}


 resource "azurerm_virtual_machine_extension" "winvm_extension_fwiis" {
   // for_each = var.wincstvmlist
     for_each = {
    for k, v in var.wincstvmlist : k => v
    if v.installIIS==true
  }
    name = "${each.key}"
    virtual_machine_id =azurerm_windows_virtual_machine.cstwininst[each.key].id
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


# resource "azurerm_virtual_machine_extension" "windomjoin" {
# for_each = var.wincstvmlist
# name ="${each.key}domjoin"
# virtual_machine_id = azurerm_windows_virtual_machine.cstwininst[each.key].id
# publisher = "Microsoft.Compute"
# type = "JsonADDomainExtension"
# type_handler_version = "1.3"

# settings = <<SETTINGS
# {
# "Name": "${var.domainname}",
# "OUPath":"${var.oupath != null ? var.oupath: ""}",
# "User": "${var.domainname}\\${var.domainusername}",
# "Restart": "true",
# "Options": "3"
# }
# SETTINGS
# protected_settings = <<PROTECTED_SETTINGS
# {
# "Password": "${var.vm_dompassword}"
# }
# PROTECTED_SETTINGS
#  depends_on = [azurerm_windows_virtual_machine.cstwininst,azurerm_virtual_machine_extension.winvm_extension_modify_fw]
# }