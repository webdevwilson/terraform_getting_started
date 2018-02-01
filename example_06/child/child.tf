variable "message" {}

resource "local_file" "foo" {
  content  = "${var.message}\n"
  filename = "foo"
}

output "out" {
  value = "hello from child!"
}
