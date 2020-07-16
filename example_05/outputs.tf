# outputs are used to return values from Terraform
# These values can be queried from remote state or returned from modules
output message {
  sensitive = false
  value     = "hello"
}
