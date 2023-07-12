variable "existingappsnetid" {
type=string
description="Existing db Subnet ID"

}

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

variable "vm_dompassword" {
  description = "Admin Password for the VM's"
  sensitive   = true
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

variable "publisher_windows"{
  
  type = string

  description = "version of windows"
}

variable "offer_windows" {

  type = string
  description = "offering version of windows"
}
    
variable "sku_windows" {
  type = string
  description="Windows version sku"
}
variable "version_windows" {

  type = string

  description = "version of windows like latest"
  
}
 
variable "asgwebserverid"{

}

 
variable "wingenlist" {
  type        = map(any)
  description = "(Required) A list of Azure Windows Custom VM"
}

variable "domainname" {
  
}

variable "oupath" {
  
}

variable "domainusername" {
  
}