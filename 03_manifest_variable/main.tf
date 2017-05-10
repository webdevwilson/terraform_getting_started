# variables are used to pass in configuration settings to terraform

variable "message" {
  type        = "string"
  description = "I will be put into a file"
  default     = "Hello from default"
}

resource "local_file" "foo" {
  content  = "foo"
  filename = "barz"
}
