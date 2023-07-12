variable "existingappbkendsnetid" {
type=string
description="Existing app bkend Subnet ID"

}

variable "existingappsnetid" {
type=string
description="Existing app bkend Subnet ID"

}

variable "appbkendvmrg_name" {
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



variable "vmusername"{
type=string
description="VM user name"

}

variable "vmpassword"{
type=string
description="VM user pass"
}



variable "win_source_image_id" {
  type = string
  description = "vm source image id"
  
}

variable "wincstvmlist" {
  type        = map(any)
  description = "(Required) A list of Azure Windows Custom VM"
}


variable "domainname" {
  
}

variable "oupath" {
  
}

variable "domainusername" {
  
}

variable "vm_dompassword" {
  description = "Admin Password for the VM's"
  sensitive   = true
}