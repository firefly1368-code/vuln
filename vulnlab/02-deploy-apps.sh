#!/bin/bash
set -e
cd ~/vulnlab
echo "[1/2] Menjalankan semua vulnerable app via Docker Compose..."
docker compose up -d

echo "[2/2] Status container:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "App berjalan di localhost saja (127.0.0.1), belum bisa diakses dari luar."
echo "Lanjut ke 03-setup-nginx.sh untuk expose lewat domain lab lokal."
