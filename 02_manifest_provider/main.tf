# provider - Used to configure the provider associated with a resource

# Configure AWS provider to point to us-east-1
provider "aws" {
  region = "us-east-1"
}

resource "aws_elastic_beanstalk_application" "tf-getting-started" {
  name        = "tf-getting-started"
  description = "Demonstrating provider"
}
