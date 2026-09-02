#!/bin/bash
set -e
cd "$(dirname "$(readlink -f "$0")")"

echo "[1/3] Copy config Nginx per aplikasi..."
sudo cp configs/*.lab.conf /etc/nginx/sites-available/

echo "[2/3] Aktifkan site..."
for conf in configs/*.lab.conf; do
    name=$(basename "$conf")
    sudo ln -sf /etc/nginx/sites-available/"$name" /etc/nginx/sites-enabled/"$name"
done

echo "[3/3] Test config & reload Nginx..."
sudo nginx -t
sudo systemctl reload nginx

echo "Nginx siap. Domain lab yang aktif:"
echo "  dvwa.lab | juiceshop.lab | webgoat.lab | mutillidae.lab"
echo "Lanjut ke 04-setup-dns.sh supaya domain-domain ini bisa di-resolve."
