variable "existingappsnetid" {
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



variable "lincstvmlist"{
 type = map(object({
        size = string
       subnetname=string
       osimageid=string
       type=string
       
    }))
    default={}
}




variable "app_subnet_address_name" {
}

variable "asgwebserversid" {
  
}