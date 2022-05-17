variable "region" {
  default = "us-west-2"
  description = "AWS Region"
}

variable "remote_state_bucket" {
  description = "Bucket name for layer 1 remote state"
}

variable "remote_state_key" {
  description = "Key Name for layer 1 remote state"
}

variable "ec2_instance_type" {
  description = "EC2 Instance type to launch"
}

variable "key_pair_name" {
  default = "Terraform_Ec2_Keypair"
  description = "key pair to to use to connect to Ec2 instances"
}

variable "max_instance_size" {
    description = "maximum number of instances to launch"
}

variable "min_instance_size" {
  description = "minimum number of instances to launch"
}