variable "existingrgname" {
}

variable "kvsku_name" {
  
}

variable "location" {
  default = "canadacentral"
}
variable "keyvaultlist" {
  type = list
  
 }

 variable "endpoints_subnet_id" {
type = string
}

variable "kv_private_dns_zone_ids" {
   type        = string

}

variable "kv_private_dns_zone_name" {
  type = string
  
}
