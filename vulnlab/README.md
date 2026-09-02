# Vulnerable Web Lab — Ubuntu 24.04

Paket ini bikin server latihan web security lengkap: Nginx (reverse proxy),
BIND9 (DNS lokal), dan 4 aplikasi web yang SENGAJA rentan (DVWA, OWASP Juice
Shop, WebGoat, Mutillidae II) — dijalankan via Docker.

⚠️ **HANYA untuk homelab/latihan internal.** Jangan expose ke internet publik
atau jaringan produksi. Semua app di sini punya bug keamanan yang disengaja.

## Urutan eksekusi

```bash
chmod +x *.sh
./01-install-base.sh        # install nginx, bind9, docker
# logout & login lagi (supaya user masuk group docker)
./02-deploy-apps.sh         # jalankan 4 vulnerable app via docker compose
./03-setup-nginx.sh         # setup reverse proxy per domain .lab
./04-setup-dns.sh           # setup BIND9 supaya *.lab bisa di-resolve
```

## Yang kamu dapat setelah selesai

| Domain            | Aplikasi          | Kerentanan utama                          |
|--------------------|--------------------|--------------------------------------------|
| dvwa.lab           | DVWA               | SQLi, XSS, Command Injection, CSRF, File Upload |
| juiceshop.lab       | OWASP Juice Shop  | OWASP Top 10 lengkap, banyak challenge terstruktur |
| webgoat.lab         | WebGoat            | Latihan interaktif OWASP Top 10 + WebWolf |
| mutillidae.lab      | Mutillidae II      | 40+ kerentanan, mirip DVWA tapi lebih luas |

## Akses dari mesin attacker (Kali kamu)

Set DNS resolver Kali ke IP server lab ini, atau paling gampang tambahkan
manual ke `/etc/hosts` di Kali:

```
<IP_SERVER_LAB>  dvwa.lab juiceshop.lab webgoat.lab mutillidae.lab
```

## Integrasi ke Wazuh (opsional, lanjutan homelab kamu)

Supaya trafik serangan ke lab ini kelihatan di dashboard Wazuh yang sudah
dibuat sebelumnya (MITRE ATT&CK dashboard), install Wazuh agent di VM ini:

```bash
curl -sO https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.14.4-1_amd64.deb
sudo WAZUH_MANAGER='<IP_WAZUH_MANAGER>' dpkg -i ./wazuh-agent_4.14.4-1_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

Lalu aktifkan log Nginx access/error di `ossec.conf` agent supaya request
serangan (payload SQLi/XSS di access log) ikut masuk sebagai alert.

## Reset semua

```bash
docker compose down -v
sudo rm /etc/nginx/sites-enabled/*.lab.conf
sudo systemctl reload nginx
```
