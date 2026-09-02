#!/bin/bash
set -e
cd "$(dirname "$(readlink -f "$0")")"

SERVER_IP=$(hostname -I | awk '{print $1}')
echo "Terdeteksi IP server: $SERVER_IP"

echo "[1/4] Generate zone file dengan IP asli..."
sed "s/SERVER_IP_PLACEHOLDER/$SERVER_IP/g" dns/db.lab | sudo tee /etc/bind/db.lab > /dev/null

echo "[2/4] Daftarkan zone 'lab' ke BIND9..."
if ! grep -q "zone \"lab\"" /etc/bind/named.conf.local 2>/dev/null; then
sudo tee -a /etc/bind/named.conf.local > /dev/null << ZONE

zone "lab" {
    type master;
    file "/etc/bind/db.lab";
};
ZONE
fi

echo "[3/4] Test config & restart BIND9..."
sudo named-checkzone lab /etc/bind/db.lab
sudo named-checkconf
sudo systemctl restart bind9
sudo systemctl enable bind9

echo "[4/4] Selesai. Domain lab yang bisa di-resolve dari server ini:"
echo "  dvwa.lab | juiceshop.lab | webgoat.lab | mutillidae.lab -> $SERVER_IP"
echo ""
echo "CATATAN PENTING:"
echo "Supaya mesin KAMU (attacker box / browser) bisa resolve domain .lab ini,"
echo "kamu harus set DNS server mesin kamu ke IP server ini ($SERVER_IP),"
echo "ATAU tambahkan manual di /etc/hosts / C:\\Windows\\System32\\drivers\\etc\\hosts:"
echo "  $SERVER_IP  dvwa.lab juiceshop.lab webgoat.lab mutillidae.lab"
