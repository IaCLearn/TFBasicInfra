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

# 


variable "vmusername"{
type=string
description="VM user name"

}

variable "vmpassword"{
type=string
description="VM user pass"
}



variable "source_image_id" {
  type = string
  description = "vm source image id"
  
}

 variable "lincstvmlist" {
  type        = map(any)
  description = "(Required) A list of Azure Linux Custom VM"
}