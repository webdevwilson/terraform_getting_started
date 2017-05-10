# Resources - Declare something to be managed by Terraform

# Creates file with specified contents
resource "local_file" "foo" {
  content  = "foo"
  filename = "barz"
}
