variable "existingappbkendsnetid" {
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

variable "appbkendcount" {
  type = number
  description = "number of vms to be created"
}

variable "appbkend_names" {
  type    = string

}


variable "vmusername"{
type=string
description="VM user name"

}

variable "vmpassword"{
type=string
description="VM user pass"
}


variable "cstwinvmsize"{

    type = string
    description = "VM Size for linux Virtual Machine"
}

variable "win_source_image_id" {
  type = string
  description = "vm source image id"
  
}