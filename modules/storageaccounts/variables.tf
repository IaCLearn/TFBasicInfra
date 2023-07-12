variable "containers_list" {
  type = list
  
 }

 variable "storage_list" {
  type = list
  
 }

  variable "existingrgname" {
}
variable "location" {
  default = "canadacentral"
}

 variable "endpoints_subnet_id" {
type = string
}

variable "stg_private_dns_zone_ids" {
   type        = string

}