#common variables
variable "location" {
  type        = string
  description = "Location of Resources"
}


variable "vmusername"{
type=string
description="VM user name"

}

variable "vmpassword"{
type=string
description="VM user pass"
}

variable "domainname" {
  type=string
description="domain name for active directory join"
  
}

variable "oupath" {
  type=string
description="VM oupath for active directory join"
}

variable "domainusername" {
  type=string
description="domain username for active directory join"
}

#Virtual Network Variables
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

variable "appgwprivateip" {
   type = string
   description = "Applicationg gateway private ip"
 }

variable "appbkend_subnet_address_prefix" {

    type        = string
  description = "Application backend Subnet Address Prefix"
}

variable "appbkend_subnet_address_name" {

    type        = string
  description = "Application backend Subnet Address name"
}

variable "appbrst_subnet_address_prefix" {

    type        = string
  description = "Application burst Subnet Address Prefix"
}

variable "appbrst_subnet_address_name" {
    type        = string
  description = "Application burst backend Subnet Address Prefix"
}

variable "appgw_subnet_address_name" {
  type        = string
  description = "AppGW Subnet Name"
}

variable "pe_subnet_address_name" {
  type =string
  description = "private endpoint Subnet Name"
}

variable "dbbi_subnet_address_name"{
    type =string
  description = "database bi/dw subnet name"

} 
variable "dbbi_subnet_address_prefix"{
  type =string
  description = "database bi/dw subnet IP address prefix"
}


variable "pe_subnet_address_prefix" {
  type = string
  description = "private endpoint address prefix"
}
variable  "sql_nsg_name"{
   type        = string
  description = "NSG SQL Name"
}

variable  "app_nsg_name"{
   type        = string
  description = "App SQL Name"
}
variable "asgwebservernames" {
  type = string
}
variable "asgsqlservernames" {
  
}
variable "environment" {
  type        = string
  description = "Environment"
}

variable "vm_dompassword" {
  description = "Domain Admin Password for the VM's"
  sensitive   = true
}

# VM Variables

variable "apprg_name" {
    type=string
    description="Resource Group name for the application"
}


#sql VM variable



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
  type        = list(string)
  default     = []
}

#Windows VM Variables
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
 


# Keyvault variables

variable "kvsku_name" {
    type    = string
description = "sku for keyvault"
}


#  variable "kvsubresourcename" {
#   type =list(string)
   
#  }
variable "existingrgname" {

  type    = string
description = "existing resource group"
}


#Application Gateway Variables

variable "backend_address_pool_name" {
    
    type =string
    description = "backend pool address name"

}
variable "private_frontend_ip_configuration_name" {
  
}
variable "frontend_port_name" {
  type = string
    
    description = "front end port name"
}

variable "frontend_ip_configuration_name" {
  type = string
  description = "frontend ip configuration name"
    
}

variable "http_setting_name" {
  type = string
  description = "http setting name"
    
}

variable "listener_name" {
  type = string
    description = "listener name"
}

variable "request_routing_rule_name" {
  type = string
  description = "Routing rule name"
   
}


variable "appgwipconfigname"{
type = string
description = "IP configuration nmae"

}

variable "appgwname"{
    type=string
    description = "application gateway name"
}

variable "appgwpip" {
  
}


variable "backendaddresspoolfqdns" {
  type = list
  
 }


#Azure redis cache
  variable "capacity" {
    
  }

  variable "redisfamily" {
    
  }

  variable "sku_name" {
    
  }

  #storage variables
  variable "containers_list" {
  type = list
  
 }

 variable "storage_list" {
  type = list
  
 }

 #custom linux image variables
variable "source_image_id" {
  type = string
  description = "vm source image id"
  
}

variable "brstvmrg_name" {
    type=string
    description="Resource Group name for the application"
}

#variables for custom windows vm


variable "appbkendvmrg_name" {
    type=string
    description="Resource Group name for the application"
}



variable "win_source_image_id" {
  type = string
  description = "vm source image id"
  
}


variable "resource_groups" {
  type = list(map(string))
 
  description = "(Required) A list of Azure Resource Groups with locations and tags"
}
variable "rediscachelist" {
  type = list
  
 }

 variable "keyvaultlist" {
  type = list
  
 }

 variable "sqlvmlist" {
  type        = map(any)
  description = "(Required) A list of Azure Virtual Machines"
}

 variable "wincstvmlist" {
  type        = map(any)
  description = "(Required) A list of Azure Windows Custom VM"
}

 variable "lincstvmlist" {
  type        = map(any)
  description = "(Required) A list of Azure Linux Custom VM"
}

 
variable "wingenlist" {
  type        = map(any)
  description = "(Required) A list of Azure Windows Custom VM"
}

#private dns zone variables

variable "privatednszonenames" {
  type = list(map(string))
 
  description = "(Required) A list of the privat dns zone names for the pass resources"
}
