variable "backend_image" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "backend_sg_id" {
  type = string
}

variable "db_secret_arn" {
  type = string
}





