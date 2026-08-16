resource "aws_ssm_association" "jenkins" {
  name             = "AWS-RunShellScript"
  association_name = "jenkins-install"

  targets {
    key    = "InstanceIds"
    values = [var.instance_id]
  }

  parameters = {
    commands = <<-EOF
      #!/bin/bash

      set -e

      echo "=== Jenkins installation started ==="
      date

      echo "Waiting for cloud-init to finish..."

      if command -v cloud-init >/dev/null 2>&1; then
        cloud-init status --wait
      fi

      if [ -n "${var.jenkins_data_device}" ]; then

        echo "=== Configuring persistent Jenkins storage ==="

        JENKINS_DEVICE="${var.jenkins_data_device}"
        JENKINS_MOUNT="${var.jenkins_data_mount_point}"

        echo "Waiting for ${JENKINS_DEVICE}..."

        for i in {1..60}; do
          if [ -b "${JENKINS_DEVICE}" ]; then
            echo "Device ${JENKINS_DEVICE} is available."
            break
          fi

          echo "Waiting for ${JENKINS_DEVICE}... ($i/60)"
          sleep 2
        done

        if [ ! -b "${JENKINS_DEVICE}" ]; then
          echo "ERROR: ${JENKINS_DEVICE} did not become available."
          exit 1
        fi

        echo "Checking filesystem..."

        if ! blkid "${JENKINS_DEVICE}" >/dev/null 2>&1; then
          echo "No filesystem detected. Creating ext4 filesystem..."

          mkfs.ext4 -F "${JENKINS_DEVICE}"
        else
          echo "Filesystem already exists."
        fi

        mkdir -p "${JENKINS_MOUNT}"

        UUID=$(blkid -s UUID -o value "${JENKINS_DEVICE}")

        if ! grep -q "UUID=${UUID}" /etc/fstab; then
          echo "Adding Jenkins volume to /etc/fstab..."

          echo "UUID=${UUID} ${JENKINS_MOUNT} ext4 defaults,nofail 0 2" \
            >> /etc/fstab
        fi

        mountpoint -q "${JENKINS_MOUNT}" || mount "${JENKINS_MOUNT}"

        echo "Persistent Jenkins storage mounted:"
        df -h "${JENKINS_MOUNT}"

      fi


      wait_for_apt() {
        echo "Waiting for APT/dpkg to become available..."

        for i in {1..60}; do
          if ! fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 \
            && ! fuser /var/lib/dpkg/lock >/dev/null 2>&1 \
            && ! fuser /var/lib/apt/lists/lock >/dev/null 2>&1 \
            && ! fuser /var/cache/apt/archives/lock >/dev/null 2>&1; then
            echo "APT is available."
            return 0
          fi

          echo "APT is busy, waiting... ($i/60)"
          sleep 5
        done

        echo "ERROR: APT is still locked after waiting."
        return 1
      }

      echo "Installing Java 21..."

      wait_for_apt
      apt-get update

      wait_for_apt
      apt-get install -y fontconfig openjdk-21-jre

      echo "Installing Jenkins repository..."

      install -d -m 0755 /etc/apt/keyrings

      curl -fsSL \
        https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key \
        -o /etc/apt/keyrings/jenkins-keyring.asc

      chmod 0644 /etc/apt/keyrings/jenkins-keyring.asc

      echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
        > /etc/apt/sources.list.d/jenkins.list

      echo "Installing Jenkins..."

      wait_for_apt
      apt-get update

      wait_for_apt
      apt-get install -y jenkins

      echo "Configuring Jenkins port..."

      mkdir -p /etc/systemd/system/jenkins.service.d

      cat > /etc/systemd/system/jenkins.service.d/override.conf <<'SYSTEMD'
      [Service]
      Environment="JENKINS_PORT=${var.jenkins_port}"
      SYSTEMD

      systemctl daemon-reload
      systemctl enable jenkins
      systemctl restart jenkins

      echo "Waiting for Jenkins to start..."

      for i in {1..30}; do
        if systemctl is-active --quiet jenkins; then
          echo "Jenkins service is running."
          break
        fi

        echo "Jenkins is not ready yet... ($i/30)"
        sleep 2
      done

      if ! systemctl is-active --quiet jenkins; then
        echo "ERROR: Jenkins failed to start."
        systemctl status jenkins --no-pager || true
        journalctl -u jenkins --no-pager -n 50 || true
        exit 1
      fi

      echo "Checking Jenkins HTTP endpoint..."

      if curl -fsS "http://127.0.0.1:${var.jenkins_port}/login" >/dev/null; then
        echo "Jenkins HTTP endpoint is responding."
      else
        echo "WARNING: Jenkins service is running but HTTP endpoint is not responding yet."
      fi

      echo "=== Jenkins installation completed ==="
      date
    EOF
  }
}