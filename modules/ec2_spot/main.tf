data "aws_ami" "ubuntu" {

  most_recent = true

  owners = [
    "099720109477" # Canonical
  ]

  filter {
    name = "name"

    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name = "architecture"

    values = [
      "x86_64"
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "this" {

  ami           = var.ami_id != null ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id                     = var.subnet_id
  vpc_security_group_ids        = var.security_group_ids
  iam_instance_profile          = var.instance_profile_name
  associate_public_ip_address   = var.associate_public_ip
  disable_api_termination       = var.disable_api_termination
  
  monitoring    = var.enable_detailed_monitoring
  user_data     = var.user_data

  dynamic "instance_market_options" {
    for_each = var.market_type == "spot" ? [1] : []

    content {
      market_type = "spot"

      spot_options {
        spot_instance_type             = "one-time"
        instance_interruption_behavior = "terminate"
      }
    }
  }

  root_block_device {

    volume_size = var.root_volume_size
    volume_type = var.root_volume_type

    delete_on_termination = true
  }

  metadata_options {

    http_endpoint = "enabled"
    http_tokens = "required"
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

