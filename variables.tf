variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "project" {
  type    = string
  default = "EKS FastApi"
}

variable "availability_zones_count" {
  description = "The number AZs"
  type        = number
  default     = 2
}

variable "subnet_cidr_bits" {
  description = "The number of bits for the subnet CIDR"
  type        = number
  default     = 8
}

variable "cluster_name" {
    type    = string
    default = "fastapi-cluster"
}

variable "fargate_profile_name" {
    type    = string
    default = "fastapi-fargate-profile"
}