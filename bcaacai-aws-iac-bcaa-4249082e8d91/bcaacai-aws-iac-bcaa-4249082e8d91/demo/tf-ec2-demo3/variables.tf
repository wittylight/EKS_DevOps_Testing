variable "region" {
  type    = string
  default = "us-west-2"
}

variable "vpc_id" {
  type    = string
}

variable "subnet_ids" {
  type    = list(string)
}

variable "instance_type" {
  type    = string
}

variable "zone_id" {
  type    = string
}

variable "stickiness_enabled" {
  type    = bool
  default = false
}