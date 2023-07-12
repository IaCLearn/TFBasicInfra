variable "privatednszonenames" {
  type = list(map(string))
 
  description = "(Required) A list of the privat dns zone names for the pass resources"
}

  variable "existingrgname" {
    type = string
}

variable "existingvnetid" {
  type = string
}

