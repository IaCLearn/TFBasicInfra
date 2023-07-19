
resource "azurerm_virtual_machine" "sqlvm" {
  for_each    = var.sqlvmlist
  name = each.key
   location            = var.location
  resource_group_name = var.apprg_name
  vm_size                = each.value.size
  network_interface_ids = [
   azurerm_network_interface.db-nic[each.key].id
  ]


  storage_image_reference {
    publisher = var.publisher_sql
    offer     = var.offer_sql
    sku       = var.sku_sql
    version   = var.image_version_sql
  }

  identity {
    type = "SystemAssigned"
  }

  storage_os_disk {
    name              = "${each.key}-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 128
  }

  storage_data_disk {
    name              = "${each.key}-DATA"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = each.value.datadisksize
    lun               = 0
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "${each.key}-LOG"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = each.value.logdisksize
    lun               = 1
    managed_disk_type = "Premium_LRS"

  }

  os_profile {
    admin_password = var.vmpassword
    admin_username = var.vmusername
    computer_name  = each.key
  }

  os_profile_windows_config {
    timezone           = "UTC"
    provision_vm_agent = true
  }

  
}

resource "azurerm_network_interface" "db-nic" {
  for_each = var.sqlvmlist
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.apprg_name

  ip_configuration {
    name    = "${each.key}-ipconfig"
    subnet_id="${each.value.subnetname}" == var.db_subnet_address_name ?  var.existingdbsnetid : "${each.value.subnetname}" == var.dbbi_subnet_address_name ? var.existingbisnetid:""
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_network_interface_application_security_group_association" "asgsqlserverassoc" {
    for_each = var.sqlvmlist
  network_interface_id          =azurerm_network_interface.db-nic[each.key].id
  application_security_group_id = var.asgsqlserverid
}
resource "azurerm_virtual_machine_extension" "vm_extension_modify_fw" {
     for_each = var.sqlvmlist
    name = "vm_modify_fw"
    virtual_machine_id =azurerm_virtual_machine.sqlvm[each.key].id
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.8"
    auto_upgrade_minor_version = true
    settings = <<SETTINGS
    {
    "commandToExecute": "powershell Set-NetFirewallProfile -Profile Domain -Enabled False"
    }
    SETTINGS

     depends_on = [
     azurerm_virtual_machine.sqlvm, azurerm_mssql_virtual_machine.azurerm_sqlvmmanagement
    ]
}


resource "azurerm_mssql_virtual_machine" "azurerm_sqlvmmanagement" {
  for_each = var.sqlvmlist  
  virtual_machine_id               = azurerm_virtual_machine.sqlvm[each.key].id
  sql_license_type                 = "PAYG"
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = var.sqladminpwd
  sql_connectivity_update_username = var.sqladmin

  auto_patching {
    day_of_week                            = "Sunday"
    maintenance_window_duration_in_minutes = 60
    maintenance_window_starting_hour       = 2
  }

  storage_configuration {
    disk_type             = "NEW"  # (Required) The type of disk configuration to apply to the SQL Server. Valid values include NEW, EXTEND, or ADD.
    storage_workload_type = "OLTP" # (Required) The type of storage workload. Valid values include GENERAL, OLTP, or DW.

    # The storage_settings block supports the following:
    data_settings {
      default_file_path = var.sqldatafilepath # (Required) The SQL Server default path
      luns              = [0]                  #azurerm_virtual_machine_data_disk_attachment.datadisk_attach[count.index].lun]
    }

    log_settings {
      default_file_path = var.sqllogfilepath # (Required) The SQL Server default path
      luns              = [1]                 #azurerm_virtual_machine_data_disk_attachment.logdisk_attach[count.index].lun] # (Required) A list of Logical Unit Numbers for the disks.
    }

  }

}

resource "azurerm_virtual_machine_extension" "sqldomjoin" {
for_each = var.sqlvmlist
name = "domjoin"
virtual_machine_id = azurerm_virtual_machine.sqlvm[each.key].id
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
 depends_on = [azurerm_virtual_machine.sqlvm,azurerm_mssql_virtual_machine.azurerm_sqlvmmanagement,azurerm_virtual_machine_extension.vm_extension_modify_fw]
}