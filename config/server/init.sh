#!/bin/bash
# Launch script for the Lightsail instance (passed as user data when the
# instance is created; runs once, as root, on first boot). It prepares what
# Kamal can't do as the non-root `ubuntu` user.
set -euo pipefail

# Docker, usable by the deploy user without sudo.
curl -fsSL https://get.docker.com | sh
usermod -aG docker ubuntu

# The SQLite database directory, owned by the app's uid (see config/deploy.yml).
mkdir -p /var/lib/blog/storage
chown 1000:1000 /var/lib/blog/storage

# 1 GB of swap: deploys briefly run the old and new app containers together.
if [ ! -f /swapfile ]; then
  fallocate -l 1G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo "/swapfile none swap sw 0 0" >> /etc/fstab
fi

# Security updates install themselves (Ubuntu ships this; make sure it's on).
apt-get install -y unattended-upgrades
dpkg-reconfigure -f noninteractive unattended-upgrades

# Keep Docker's container logs from filling the disk.
cat > /etc/docker/daemon.json <<'JSON'
{ "log-driver": "json-file", "log-opts": { "max-size": "10m", "max-file": "3" } }
JSON
systemctl restart docker
