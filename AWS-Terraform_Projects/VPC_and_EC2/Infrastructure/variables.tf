variable "region" {
  default = "us-west-2"
  description = "aws region"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC CIDR for production env"
}

variable "public_subnet_cidr1" {
  description = "Public Subnet 1 CIDR"
}

variable "public_subnet_cidr2" {
  description = "Public Subnet 2 CIDR"
}

variable "public_subnet_cidr3" {
  description = "Public Subnet 3 CIDR"
}

variable "private_subnet_cidr1" {
  description = "Private Subnet 1 CIDR"
}

variable "private_subnet_cidr2" {
  description = "Private Subnet 2 CIDR"
}

variable "private_subnet_cidr3" {
  description = "Private Subnet 3 CIDR"
}