variable "language" {
  default = "java"
}

variable "bundle" {
  type = "string"
}

variable "bundle_sha256hash" {
  type = "string"
}

variable "stacks" {
  type = "map"

  default = {
    java = "64bit Amazon Linux 2016.09 v2.4.4 running Java 8"
  }
}

variable "port" {
  type    = "string"
  default = "8000"
}

variable "message" {
  type    = "string"
  default = "Hello from default"
}

variable "version" {
  type = "string"
}

variable "vpc_cidr" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "app_name" {
  type = "string"
}
