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


variable "db_subnet_address_prefix" {
}

variable "db_subnet_address_name" {
}


variable  "sql_nsg_name"{

}

variable  "app_nsg_name"{
  
}
variable "environment" {
}

variable "dnsservers"{
  type        = list(string)
  default     = []
}