# Resources - Declare something to be managed by Terraform
#
# id - must be unique in a plan
# attributes - set values on the resource

# Terraform tracks resources, if they change it will update them

# Creates file on local machine with specified contents
resource "local_file" "foo" {
  content  = "foo"
  filename = "foo"
}
