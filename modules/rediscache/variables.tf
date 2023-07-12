
  variable "capacity" {
    
  }

  variable "redisfamily" {
    
  }

  variable "sku_name" {
    
  }

  variable "existingrgname" {
}

variable "location" {
  default = "canadacentral"
}

variable "rediscachelist" {
  type = list
  
 }


variable "rdc_private_dns_zone_ids" {
  type = string
  
}

 variable "endpoints_subnet_id" {
type = string
}
