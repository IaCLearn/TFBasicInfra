resource "azurerm_resource_group" "vm_resource_group" {
  name     = "${var.apprg_name}-rg"
  location = var.location
  
  tags = {
    Environment = var.environment
  }
}

# #sql vm creation single machine
# resource "azurerm_network_interface" "db-nic" {
#   name                = "${var.sql_vmname}-db-nic"
#   location            = azurerm_resource_group.vm_resource_group.location
#   resource_group_name = azurerm_resource_group.vm_resource_group.name

#   ip_configuration {
#     name                          = "${var.sql_vmname}-IP"
#     subnet_id     =var.existingdbsnetid
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_virtual_machine" "sqlvm" {
#   name                = var.sql_vmname
#   resource_group_name = azurerm_resource_group.vm_resource_group.name
#   location            =azurerm_resource_group.vm_resource_group.location
#   vm_size                = var.vm_size_sql
#   network_interface_ids = [
#     azurerm_network_interface.db-nic.id
#   ]


#   storage_image_reference {
#     publisher = var.publisher_sql
#     offer     = var.offer_sql
#     sku       = var.sku_sql
#     version   = var.image_version_sql
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   storage_os_disk {
#     name              = "${var.sql_vmname}-OS"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Premium_LRS"
#     disk_size_gb      = 128
#   }

#   storage_data_disk {
#     name              = "${var.sql_vmname}-DATA"
#     caching           = "ReadOnly"
#     create_option     = "Empty"
#     disk_size_gb      = 256
#     lun               = 0
#     managed_disk_type = "Premium_LRS"
#   }

#   storage_data_disk {
#     name              = "${var.sql_vmname}-LOG"
#     caching           = "ReadOnly"
#     create_option     = "Empty"
#     disk_size_gb      = 128
#     lun               = 1
#     managed_disk_type = "Premium_LRS"

#   }

#   os_profile {
#     admin_password = var.vmpassword
#     admin_username = var.vmusername
#     computer_name  = var.sql_vmname
#   }

#   os_profile_windows_config {
#     timezone           = "UTC"
#     provision_vm_agent = true
#   }

  
# }

# #disable domain firewall for domain activities

# resource "azurerm_virtual_machine_extension" "vm_extension_modify_fw" {
   
#     name = "vm_modify_fw"
#     virtual_machine_id = azurerm_virtual_machine.sqlvm.id
#     publisher = "Microsoft.Compute"
#     type = "CustomScriptExtension"
#     type_handler_version = "1.8"
#     auto_upgrade_minor_version = true
#     settings = <<SETTINGS
#     {
#     "commandToExecute": "powershell Set-NetFirewallProfile -Profile Domain -Enabled False"
#     }
#     SETTINGS

#      depends_on = [
#      azurerm_virtual_machine.sqlvm, azurerm_mssql_virtual_machine.azurerm_sqlvmmanagement
#     ]
# }

# #join sqlvm to domain

# resource "azurerm_virtual_machine_extension" "sqldomjoin" {
 
# name = "domjoin"
# virtual_machine_id = azurerm_virtual_machine.sqlvm.id
# publisher = "Microsoft.Compute"
# type = "JsonADDomainExtension"
# type_handler_version = "1.3"

# settings = <<SETTINGS
# {
# "Name": "phebsix.com",
# "User": "phebsix.com\\localadmin",
# "Restart": "true",
# "Options": "3"
# }
# SETTINGS
# protected_settings = <<PROTECTED_SETTINGS
# {
# "Password": "${var.vm_dompassword}"
# }
# PROTECTED_SETTINGS
#  depends_on = [azurerm_virtual_machine.sqlvm,azurerm_mssql_virtual_machine.azurerm_sqlvmmanagement,azurerm_virtual_machine_extension.vm_extension_modify_fw]
# }

# #SQL Management for Azure SQL 
# resource "azurerm_mssql_virtual_machine" "azurerm_sqlvmmanagement" {

#   virtual_machine_id               = azurerm_virtual_machine.sqlvm.id
#   sql_license_type                 = "PAYG"
#   sql_connectivity_port            = 1433
#   sql_connectivity_type            = "PRIVATE"
#   sql_connectivity_update_password = var.sqladminpwd
#   sql_connectivity_update_username = var.sqladmin

#   auto_patching {
#     day_of_week                            = "Sunday"
#     maintenance_window_duration_in_minutes = 60
#     maintenance_window_starting_hour       = 2
#   }

#   storage_configuration {
#     disk_type             = "NEW"  # (Required) The type of disk configuration to apply to the SQL Server. Valid values include NEW, EXTEND, or ADD.
#     storage_workload_type = "OLTP" # (Required) The type of storage workload. Valid values include GENERAL, OLTP, or DW.

#     # The storage_settings block supports the following:
#     data_settings {
#       default_file_path = var.sqldatafilepath # (Required) The SQL Server default path
#       luns              = [0]                  #azurerm_virtual_machine_data_disk_attachment.datadisk_attach[count.index].lun]
#     }

#     log_settings {
#       default_file_path = var.sqllogfilepath # (Required) The SQL Server default path
#       luns              = [1]                 #azurerm_virtual_machine_data_disk_attachment.logdisk_attach[count.index].lun] # (Required) A list of Logical Unit Numbers for the disks.
#     }

#   }

# }

#Windows Server for app web VM
# Define the virtual machines
resource "azurerm_network_interface" "app-nic" {
  count               = "${var.appvmcount}"
  name                = "${var.appvm_names}${count.index}-nic"
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            =azurerm_resource_group.vm_resource_group.location

  ip_configuration {
    name                          = "${var.appvm_names}${count.index}-ipconfig"
      subnet_id                     = var.existingappsnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "winvm" {
  count                = "${var.appvmcount}"
  name                 = "${var.appvm_names}${count.index}"
   resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            =azurerm_resource_group.vm_resource_group.location
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
  #  depends_on = [
  #    azurerm_virtual_machine.sqlvm, azurerm_mssql_virtual_machine.azurerm_sqlvmmanagement, azurerm_virtual_machine_extension.sqldomjoin
  #   ]
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
"User": "phebsix.com\\localadmin",


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