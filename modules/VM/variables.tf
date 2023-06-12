variable "existingsnetid" {
type=string
description="Existing Subnet ID"

}

variable "omsapprg_name" {
    type=string
    description="The name of the resource for the OMS application"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "location" {
  default = "canadacentral"
}

variable "sql_vmname" {
    type= string
  description = "name of the SQL Virtual Machine."
}

variable "vm_dompassword" {
  description = "Admin Password for the VM's"
  sensitive   = true
}

variable "vm_size_sql" {
  description = "VM Size SQL Server"
}

variable "sql_vmusername"{

description= "SQL VM user name"

}

variable "vm_os_disk_delete_flag"{
  description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed?"
  default     = "true"
}
variable "vm_data_disk_delete_flag"{
  description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed?"
  default     = "true"
}

variable "sqladminpwd"{
  description = "SQL admin password"
  sensitive   = true
}
variable "sqladmin"{
  description = "SQL admin username"
  sensitive   = true
}
variable "sqldatafilepath"{
  description = "SQL data file path"
}
variable "sqllogfilepath"{
  description = "SQL log file path"
}
variable "publisher_sql"{
  description = "image publisher"
}
variable "offer_sql" {
  description = "image offer"
}
variable "sku_sql"{
  description = "sku of the image"
}
variable "image_version_sql" {
  description = "version for the image"
}
