resource "aws_ssm_association" "ollama" {
  name = "AWS-RunShellScript"

  targets {
    key    = "InstanceIds"
    values = [var.instance_id]
  }

  parameters = {
    commands = <<-EOT
      #!/bin/bash

      set -e

      echo "=== Ollama installation started ==="
      date

      echo "Checking current Ollama installation..."

      if command -v ollama >/dev/null 2>&1; then
        echo "Ollama is already installed."
        ollama --version
      else
        echo "Installing Ollama..."

        curl -fsSL https://ollama.com/install.sh | sh
      fi

      echo "Configuring Ollama..."

      mkdir -p /etc/systemd/system/ollama.service.d

      cat > /etc/systemd/system/ollama.service.d/override.conf <<'EOF'
      [Service]
      Environment="OLLAMA_HOST=${var.listen_address}"
      EOF

      systemctl daemon-reload
      systemctl enable ollama
      systemctl restart ollama

      echo "Checking Ollama service..."

      systemctl --no-pager --full status ollama

      echo "Checking Ollama API..."

      for i in {1..30}; do
        if curl -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
          echo "Ollama API is ready."
          break
        fi

        echo "Waiting for Ollama API..."
        sleep 2
      done

      curl -fsS http://127.0.0.1:11434/api/tags

      echo
      echo "=== Ollama installation completed ==="
      date
    EOT
  }

  lifecycle {
    create_before_destroy = true
  }
}