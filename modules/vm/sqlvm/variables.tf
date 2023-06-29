variable "existingdbsnetid" {
type=string
description="Existing db Subnet ID"

}

# variable "existingappsnetid" {
# type=string
# description="Existing db Subnet ID"

# }

variable "apprg_name" {
    type=string
    description="Resource Group name for the application"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "location" {
  default = "canadacentral"
}

# variable "appvmcount" {
#   type = number
#   description = "number of vms to be created"
# }

# variable "appvm_names" {
#   type    = string

# }

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
 default = "Standard_DS3_v2"
 
}

variable "vm_size_sqlmedium" {
  description = "Medium VM Size SQL Server"
  default="Standard_D8ds_v4"
    
}

variable "vmusername"{
type=string
description="VM user name"

}

variable "vmpassword"{
type=string
description="VM user pass"
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

   type=string
  description = "SQL log file path"
}
variable "publisher_sql"{
  description = "image publisher"
}
variable "offer_sql" {
   type=string
  description = "image offer"
}
variable "sku_sql"{
   type=string
  description = "sku of the image"
}
variable "image_version_sql" {
  type=string
  description = "version for the image"
}

# variable "publisher_windows"{
  
#   type = string

#   description = "version of windows"
# }

# variable "offer_windows" {

#   type = string
#   description = "offering version of windows"
# }
    
# variable "sku_windows" {
#   type = string
#   description="Windows version sku"
# }
# variable "version_windows" {

#   type = string

#   description = "version of windows like latest"
  
# }
 