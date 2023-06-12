resource "azurerm_resource_group" "vm_resource_group" {
  name     = "${var.omsapprg_name}-rg"
  location = var.location
  
  tags = {
    Environment = var.environment
  }
}


resource "azurerm_network_interface" "db-nic" {
  name                = "${var.sql_vmname}-db-nic"
  location            = azurerm_resource_group.vm_resource_group.location
  resource_group_name = azurerm_resource_group.vm_resource_group.name

  ip_configuration {
    name                          = "${var.sql_vmname}-IP"
    subnet_id                     = var.existingsnetid
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "sqlvm" {
  name                = var.sql_vmname
  resource_group_name = azurerm_resource_group.vm_resource_group.name
  location            =azurerm_resource_group.vm_resource_group.location
  vm_size                = var.vm_size_sql
  network_interface_ids = [
    azurerm_network_interface.db-nic.id
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
    name              = "${var.sql_vmname}-OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 128
  }

  storage_data_disk {
    name              = "${var.sql_vmname}-DATA"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 256
    lun               = 0
    managed_disk_type = "Premium_LRS"
  }

  storage_data_disk {
    name              = "${var.sql_vmname}-LOG"
    caching           = "ReadOnly"
    create_option     = "Empty"
    disk_size_gb      = 128
    lun               = 1
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    admin_password = var.sqladminpwd
    admin_username = var.sql_vmusername
    computer_name  = var.sql_vmname
  }

  os_profile_windows_config {
    timezone           = "UTC"
    provision_vm_agent = true
  }

  
}

resource "azurerm_mssql_virtual_machine" "azurerm_sqlvmmanagement" {

  virtual_machine_id               = azurerm_virtual_machine.sqlvm.id
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