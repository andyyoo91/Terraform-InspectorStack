variable "vpc_cidr" {
  default = "10.0.0.0/18"
}

variable "private_subnet_cidr" {
  default = "10.0.5.0/24"
}

variable "public_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "route_table_private_cidr" {
  default = "0.0.0.0/0"
}

variable "route_table_public_cidr" {
  default = "0.0.0.0/0"
}
