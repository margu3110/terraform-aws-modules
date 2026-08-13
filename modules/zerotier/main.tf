resource "aws_ssm_association" "zerotier" {
  name = "AWS-RunShellScript"

  targets {
    key    = "InstanceIds"
    values = [var.instance_id]
  }

  parameters = {
    commands = <<-EOT
      #!/bin/bash

      set -e

      if command -v cloud-init >/dev/null 2>&1; then
          echo "Waiting for cloud-init to finish..."
          cloud-init status --wait
      fi

      echo "Cloud-init completed."
      
      echo "=== ZeroTier installation started ==="
      date

      if command -v zerotier-cli >/dev/null 2>&1; then
        echo "ZeroTier is already installed."
      else
        echo "Installing ZeroTier..."

        curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/main/doc/contact%40zerotier.com.gpg' | gpg --import

        if z=$(curl -s 'https://install.zerotier.com/' | gpg); then
          echo "$z" | bash
        else
          echo "ERROR: Failed to download or verify ZeroTier installer."
          exit 1
        fi
      fi

      echo
      echo "Checking ZeroTier service..."

      systemctl enable zerotier-one
      systemctl start zerotier-one

      systemctl --no-pager --full status zerotier-one

      echo
      echo "Checking ZeroTier version..."

      zerotier-cli -v

      echo
      echo "Joining ZeroTier network..."
      zerotier-cli join ${var.network_id}

      echo
      echo "Checking ZeroTier networks..."
      zerotier-cli listnetworks

      echo
      echo "Checking ZeroTier status..."

      zerotier-cli info

      echo
      echo "=== ZeroTier installation completed ==="
      date
    EOT
  }
}