# Resources - Declare something to be managed by Terraform
#
# id - must be unique in a plan
# attributes - set values on the resource

# Creates file on local machine with specified contents
resource "local_file" "foo" {
  content  = "foo"
  filename = "foo"
}
