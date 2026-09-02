#!/bin/bash
# ============================================================
# Vulnerable Web Lab Setup - Ubuntu 24.04
# Web Server (Nginx) + Local DNS (BIND9) + Vulnerable Apps (Docker)
# Untuk keperluan LATIHAN INTERNAL / homelab red-blue team saja.
# JANGAN pernah expose ke internet publik.
# ============================================================
set -e

echo "[1/5] Update sistem..."
sudo apt update && sudo apt upgrade -y

echo "[2/5] Install Nginx & BIND9..."
sudo apt install -y nginx bind9 bind9utils bind9-doc dnsutils

echo "[3/5] Install Docker Engine..."
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

echo "[4/5] Buat folder project..."
mkdir -p ~/vulnlab
cd ~/vulnlab

echo "[5/5] Selesai install base. Lanjut ke 02-deploy-apps.sh"
echo "PENTING: logout/login ulang dulu supaya user masuk group docker."
