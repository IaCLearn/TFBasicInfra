variable "vnetrgname" {
}

variable "vnet_name" {
  
}

variable "location" {
  default = "canadacentral"
}


variable "network_address_space" {
}

variable "app_subnet_address_prefix" {
}

variable "app_subnet_address_name" {
}

variable "appgw_subnet_address_prefix" {
}

variable "appgw_subnet_address_name" {
}

variable "appbkend_subnet_address_prefix" {
}

variable "appbkend_subnet_address_name" {
}

variable "appbrst_subnet_address_prefix" {
}

variable "appbrst_subnet_address_name" {
}

variable "pe_subnet_address_name" {
  
}

variable "pe_subnet_address_prefix" {
  
}
variable "db_subnet_address_prefix" {
}

variable "db_subnet_address_name" {
}
variable "dbbi_subnet_address_name"{

} 
variable "dbbi_subnet_address_prefix"{}


variable "mrz_subnet_address_name"{

} 
variable "mrz_subnet_address_prefix"{}

variable "inrule_subnet_address_name"{

} 
variable "inrule_subnet_address_prefix"{}

variable  "sql_nsg_name"{

}
variable "jmpbox_nsg_name" {
  
  
}
variable "appbrst_nsg_name" {
  
}
variable  "app_nsg_name"{
  
}

variable "corris_nsg_name" {
  
}

variable "inrule_nsg_name" {
  
}

variable "environment" {
}

variable "dnsservers"{
  type        = list(string)
  default     = []
}
variable "asgwebservernames" {
  type = string
}

  
variable "asgsqlservernames" {
  
}

variable "asgjmpservernames" {
  
}

variable "asgbrstservernames" {
  
}

variable "asgcorisservernames" {
  
}

variable "asginruleservernames" {
  
}