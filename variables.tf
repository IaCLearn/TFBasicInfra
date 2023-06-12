variable "location" {
  type        = string
  description = "Location of Resources"
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"
}

variable "network_address_space" {
  type        = string
  description = "Virtual Network Address Space"
}

variable "app_subnet_address_prefix" {
  type        = string
  description = "App Subnet Address Prefix"
}

variable "app_subnet_address_name" {
  type        = string
  description = "App Subnet Name"
}


variable "db_subnet_address_prefix" {
  type        = string
  description = "db Subnet Address Prefix"
}

variable "db_subnet_address_name" {
  type        = string
  description = "dbs Subnet Name"
}


variable "appgw_subnet_address_prefix" {
  type        = string
  description = "AppGW Subnet Address Prefix"
}

variable "appgw_subnet_address_name" {
  type        = string
  description = "AppGW Subnet Name"
}

variable  "sql_nsg_name"{
   type        = string
  description = "NSG SQL Name"
}

variable  "app_nsg_name"{
   type        = string
  description = "App SQL Name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

# variable "vm_admin_password" {
#   description = "Admin Password for the VM's"
#   sensitive   = true
# }

# VM Variables

variable "omsapprg_name" {
    type=string
    description="The name of the resource for the OMS application"
}
# variable "existingsnetid" {
# type=string
# description="Existing Subnet ID"

# }
variable "sql_vmname" {
    type = string
  description = "name of the SQL Virtual Machine. "
}
variable "sql_vmusername"{
type=string
description="SQL VM user name"

}
variable "vm_size_sql" {
  type        = string
  description = "VM Size SQL Server"
}
variable "vm_os_disk_delete_flag"{
  description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed?"
  default     = "true"
}
variable "vm_data_disk_delete_flag"{
  description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed?"
  default     = "true"
}
# variable "image_publisher"{
#   type        = string
#   description = "image publisher"
# }
# variable "offer_app"{
#   type        = string
#   description = "image offer"
# }
# variable "sku_app"{
#   type        = string
#   description = "sku of the image"
# }
# variable "image_version_app"{
#   type        = string
#   description = "version for the image"
# }
variable "sqladminpwd"{
  description = "SQL admin password"
  sensitive   = true
}
variable "sqladmin"{
  description = "SQL admin username"
  sensitive   = true
}
variable "sqldatafilepath"{
  type        = string
  description = "SQL data file path"
}
variable "sqllogfilepath"{
  type        = string
  description = "SQL log file path"
}
variable "publisher_sql"{
  type        = string
  description = "image publisher"
}
variable "offer_sql" {
  description = "image offer"
}
variable "sku_sql"{
  type        = string
  description = "sku of the image"
}
variable "image_version_sql" {
  type        = string
  description = "version for the image"
}

variable "dnsservers"{
description="dns server(s) for environment"
}