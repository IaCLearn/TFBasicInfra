variable "existingappbkendsnetid" {
type=string
description="Existing app bkend Subnet ID"

}


variable "existingappbrstsnetid" {
  type=string
description="Existing app bkend Subnet ID"
}
variable "existingappsnetid" {
type=string
description="Existing app Subnet ID"

}

variable "existingdbsnetid" {
type=string
description="Existing database Subnet ID"

}

variable "existingdbbisnetid" {
type=string
description="Existing database Subnet ID"

}


variable "existingmrzsnetid" {
type=string
description="Existing database Subnet ID"

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



variable "wincstvmlist"{
 type = map(object({
        size = string
       subnetname=string
       osimageid=string
       type=string//presentation,inrule, coris, sql, brst,jumpbox
        logdisks =optional(number)
        logdiskname=optional(string)
        datadisk=optional(number)
        datadiskname=optional(string)
        tempdbdisk=optional(number)
        tempdbdiskname=optional(string)
        installIIS=optional(bool)
    }))
    default={}
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


variable "appbrst_subnet_address_name" {
}
# variable "appbkend_subnet_address_name" {
# }
variable "app_subnet_address_name" {
}

variable "appbkend_subnet_address_name" {
  
}

variable "db_subnet_address_name" {
  
}

variable "dbbi_subnet_address_name" {
  
}

variable "mrz_subnet_address_name" {
  
}



#asg ids

variable "asgsqlserverid" {
  
}

variable "asgwebserversid"{

}

variable "asgjmpserversid"{

}

variable "asgbrstserversid" {}

variable "asgcorrisserversid" {}