variable "existingappbrstsnetid" {
type=string
description="Existing db Subnet ID"

}

variable "brstvmrg_name" {
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

variable "webbfecount" {
  type = number
  description = "number of vms to be created"
}

variable "webbfe_names" {
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


variable "cstlinuxvmsize"{

    type = string
    description = "VM Size for linux Virtual Machine"
}

variable "source_image_id" {
  type = string
  description = "vm source image id"
  
}