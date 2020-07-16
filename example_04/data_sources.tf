# data sources allow you to query for values

provider aws {
  region = "us-east-1"
}

# Query for latest Ubuntu AMI published by Canonical
data aws_ami ubuntu {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Launch the AMI
resource aws_instance web {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
