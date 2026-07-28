module "networking" {

  source = "../../modules/networking"

  name = "example"

  vpc_cidr = "10.50.0.0/16"

  public_subnet_cidrs = [
    "10.50.1.0/24",
    "10.50.2.0/24"
  ]

  tags = local.tags

}

module "security_group" {
  source = "../../modules/security_group"

  name        = "example-ec2"
  description = "Example EC2 Security Group"

  vpc_id = module.networking.vpc_id

  ingress_rules = {

    ollama = {

      description = "Ollama"

      from_port = 11434
      to_port   = 11434

      ip_protocol = "tcp"

      cidr_ipv4 = "0.0.0.0/0"

    }
  }

  egress_rules = {

    all = {

      description = "All outbound"

      from_port = 0
      to_port   = 0

      ip_protocol = "-1"

      cidr_ipv4 = "0.0.0.0/0"

    }
  }

  tags = local.tags
}

data "aws_iam_policy_document" "ec2" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

module "iam" {
  source                = "../../modules/iam"
  name                  = "example"
  assume_role_policy    = data.aws_iam_policy_document.ec2.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  tags = local.tags
}

module "ec2_spot" {
  source            = "../../modules/ec2_spot"
  name              = "example"
  instance_type     = "t3.micro"
  subnet_id         = module.networking.public_subnet_ids[0]

  security_group_ids = [
    module.security_group.security_group_id
  ]

  instance_profile_name = module.iam.instance_profile_name
  spot                  = true
  root_volume_size      = 20

  user_data = <<EOF
#!/bin/bash

apt-get update

apt-get install -y \
    docker.io \
    git \
    curl

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

EOF

  tags = local.tags

}