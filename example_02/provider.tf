# provider - Used to configure the provider associated with a resource
#
# By convention, resources start with the provider name. You can specify
# the version of the provider to use, otherwise attributes are different
# depending on the provider

# Configure AWS provider to point to us-east-1
provider aws {
  version = "~> 1.0"
  region  = "us-east-1"
}

# This resource creates an iam role in aws
resource aws_iam_role test_role {
  name_prefix        = "tf_getting_started"
  assume_role_policy = ""
}
