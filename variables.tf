
variable "environment" {
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  default     = "prod-vpc"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "app_subnet_cidrs" {
  type        = list(string)
  default = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "db_subnet_cidrs" {
  type        = list(string)
  default = [
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}

variable "bastion_ami" {
  type        = string
  default     = "ami-07ff62358b87c7116"
}

variable "bastion_instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "admin_cidr" {
  type        = string
  default     = "192.168.1.189/32"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "vpc_id" {
  type        = string
  default     = null
}

variable "app_subnet_ids" {
  type        = list(string)
  default     = []
}

variable "db_subnet_ids" {
  type        = list(string)
  default     = []
}
