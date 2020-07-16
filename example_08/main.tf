variable availability_zones {
  type = list(string)
}

variable instance_type {}

variable name {
  default = "tf-getting-started"
}

variable dns_zone {}

variable private_cidrs {
  type = list(string)
}

variable public_cidrs {
  type = list(string)
}

variable vpc_cidr {}

locals {
  tags = {
    Name      = var.name
    Terraform = "github.com/RelusLabs/tf-getting-started/example_08"
  }
}

provider aws {
  version = "~> 1.8.0"
  region  = "us-east-1"
}

# Pull the latest ubuntu
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

module vpc {
  source             = "./vpc"
  availability_zones = [var.availability_zones]
  name               = var.name
  tags               = local.tags
  private_cidrs      = var.private_cidrs
  public_cidrs       = var.public_cidrs
  vpc_cidr           = var.vpc_cidr
}

module instance {
  source                    = "./instance"
  ami_id                    = data.aws_ami.ubuntu.id
  instance_min_size         = "3"
  instance_max_size         = "15"
  instance_type             = var.instance_type
  name                      = var.name
  private_subnet_ids        = module.vpc.private_subnets
  public_subnet_ids         = module.vpc.public_subnets
  tags                      = local.tags
  private_security_group_id = module.vpc.private_security_group_id
  public_security_group_id  = module.vpc.public_security_group_id
}

module dns {
  source       = "./dns"
  dns_name     = "${var.name}.${var.dns_zone}"
  dns_zone     = var.dns_zone
  elb_dns_name = module.instance.elb_dns_name
  elb_zone_id  = module.instance.elb_zone_id
}

