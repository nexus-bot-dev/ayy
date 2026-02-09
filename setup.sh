#!/bin/bash

# Nexus Tunnel Installer
# Premium Multi-Protocol Tunneling System
# Support: SSH, VMess, VLess, Trojan

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO="https://raw.githubusercontent.com/yourusername/nexus-tunnel/main"

clear

echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███╗   ██╗        ║
║   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║████╗  ██║        ║
║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║██╔██╗ ██║        ║
║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██║╚██╗██║        ║
║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║ ╚████║        ║
║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝        ║
║                                                           ║
║              Premium Tunneling System v1.0                ║
║         SSH • VMess • VLess • Trojan • API                ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Cek root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Script ini harus dijalankan sebagai root!${NC}"
   exit 1
fi

# Fungsi cek izin
check_license() {
    MYIP=$(curl -s https://api.ipify.org)
    echo -e "${YELLOW}Checking license for IP: ${MYIP}${NC}"
    
    # Download file izin
    wget -q -O /tmp/izin.txt "${REPO}/izin.txt"
    
    if ! grep -q "### ${MYIP}" /tmp/izin.txt; then
        echo -e "${RED}"
        echo "╔═══════════════════════════════════════════════╗"
        echo "║         ACCESS DENIED - NO LICENSE           ║"
        echo "╚═══════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "${YELLOW}IP Anda: ${MYIP}${NC}"
        echo -e "${YELLOW}Silakan hubungi admin untuk mendapatkan izin akses${NC}"
        echo -e "${CYAN}Telegram: @YourTelegramUsername${NC}"
        rm -f /tmp/izin.txt
        exit 1
    fi
    
    # Ambil informasi lisensi
    LICENSE_INFO=$(grep "### ${MYIP}" /tmp/izin.txt)
    EXPIRY=$(echo ${LICENSE_INFO} | awk '{print $3}')
    TELE_USER=$(echo ${LICENSE_INFO} | awk '{print $4}')
    
    # Cek masa aktif
    CURRENT_DATE=$(date +%Y-%m-%d)
    if [[ "${CURRENT_DATE}" > "${EXPIRY}" ]]; then
        echo -e "${RED}License expired pada: ${EXPIRY}${NC}"
        rm -f /tmp/izin.txt
        exit 1
    fi
    
    echo -e "${GREEN}✓ License Valid${NC}"
    echo -e "${CYAN}User: ${TELE_USER}${NC}"
    echo -e "${CYAN}Expired: ${EXPIRY}${NC}"
    echo ""
    rm -f /tmp/izin.txt
    sleep 2
}

# Input Domain
input_domain() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           DOMAIN CONFIGURATION                ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "Masukkan domain Anda: " DOMAIN
    
    if [[ -z "${DOMAIN}" ]]; then
        echo -e "${RED}Domain tidak boleh kosong!${NC}"
        exit 1
    fi
    
    echo "${DOMAIN}" > /etc/nexus/domain
    echo -e "${GREEN}✓ Domain tersimpan: ${DOMAIN}${NC}"
}

# Install dependencies
install_dependencies() {
    echo -e "${CYAN}Installing dependencies...${NC}"
    
    apt update -y
    apt upgrade -y
    apt install -y curl wget screen socat jq git
    apt install -y vnstat squid nginx build-essential
    
    echo -e "${GREEN}✓ Dependencies installed${NC}"
}

# Install SSL Certificate
install_ssl() {
    echo -e "${CYAN}Installing SSL Certificate...${NC}"
    
    # Install acme.sh
    curl https://get.acme.sh | sh
    source ~/.bashrc
    
    DOMAIN=$(cat /etc/nexus/domain)
    
    # Issue certificate
    ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    ~/.acme.sh/acme.sh --issue -d ${DOMAIN} --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d ${DOMAIN} --fullchainpath /etc/nexus/cert.crt --keypath /etc/nexus/cert.key --ecc
    
    chmod 644 /etc/nexus/cert.crt
    chmod 644 /etc/nexus/cert.key
    
    echo -e "${GREEN}✓ SSL Certificate installed${NC}"
}

# Install SSH Server
install_ssh() {
    echo -e "${CYAN}Installing SSH & Dropbear...${NC}"
    
    apt install -y dropbear openssh-server
    
    # Konfigurasi SSH
    sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
    sed -i 's/PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
    
    # Konfigurasi Dropbear
    echo 'DROPBEAR_PORT=143' > /etc/default/dropbear
    echo 'DROPBEAR_EXTRA_ARGS="-p 109 -p 69"' >> /etc/default/dropbear
    
    systemctl restart ssh
    systemctl restart dropbear
    
    echo -e "${GREEN}✓ SSH installed${NC}"
}

# Install Xray
install_xray() {
    echo -e "${CYAN}Installing Xray-Core...${NC}"
    
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
    
    # Buat direktori
    mkdir -p /etc/nexus/vmess
    mkdir -p /etc/nexus/vless
    mkdir -p /etc/nexus/trojan
    
    # Generate UUID default
    UUID=$(cat /proc/sys/kernel/random/uuid)
    echo "${UUID}" > /etc/nexus/uuid.txt
    
    # Konfigurasi Xray
    cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": 443,
      "protocol": "vmess",
      "settings": {
        "clients": []
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/nexus/cert.crt",
              "keyFile": "/etc/nexus/cert.key"
            }
          ]
        },
        "wsSettings": {
          "path": "/vmess"
        }
      }
    },
    {
      "port": 8443,
      "protocol": "vless",
      "settings": {
        "clients": [],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/nexus/cert.crt",
              "keyFile": "/etc/nexus/cert.key"
            }
          ]
        },
        "wsSettings": {
          "path": "/vless"
        }
      }
    },
    {
      "port": 9443,
      "protocol": "trojan",
      "settings": {
        "clients": []
      },
      "streamSettings": {
        "network": "ws",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/nexus/cert.crt",
              "keyFile": "/etc/nexus/cert.key"
            }
          ]
        },
        "wsSettings": {
          "path": "/trojan"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF
    
    systemctl enable xray
    systemctl restart xray
    
    echo -e "${GREEN}✓ Xray installed${NC}"
}

# Setup Nginx
setup_nginx() {
    echo -e "${CYAN}Setting up Nginx...${NC}"
    
    DOMAIN=$(cat /etc/nexus/domain)
    
    cat > /etc/nginx/sites-available/nexus <<EOF
server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ${DOMAIN};
    
    ssl_certificate /etc/nexus/cert.crt;
    ssl_certificate_key /etc/nexus/cert.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    root /var/www/html;
    index index.html index.php;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
    
    location /vmess {
        proxy_pass http://127.0.0.1:443;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
    
    location /vless {
        proxy_pass http://127.0.0.1:8443;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
    
    location /trojan {
        proxy_pass http://127.0.0.1:9443;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
}
EOF
    
    ln -sf /etc/nginx/sites-available/nexus /etc/nginx/sites-enabled/
    rm -f /etc/nginx/sites-enabled/default
    
    systemctl restart nginx
    
    echo -e "${GREEN}✓ Nginx configured${NC}"
}

# Download scripts
download_scripts() {
    echo -e "${CYAN}Downloading management scripts...${NC}"
    
    cd /usr/bin
    
    # Main menu
    wget -q -O menu "${REPO}/menu.sh" && chmod +x menu
    
    # SSH Menu
    wget -q -O menu-ssh "${REPO}/menu-ssh.sh" && chmod +x menu-ssh
    wget -q -O create-ssh "${REPO}/create-ssh.sh" && chmod +x create-ssh
    wget -q -O delete-ssh "${REPO}/delete-ssh.sh" && chmod +x delete-ssh
    wget -q -O cek-ssh "${REPO}/cek-ssh.sh" && chmod +x cek-ssh
    wget -q -O lock-ssh "${REPO}/lock-ssh.sh" && chmod +x lock-ssh
    wget -q -O unlock-ssh "${REPO}/unlock-ssh.sh" && chmod +x unlock-ssh
    wget -q -O change-dropbear "${REPO}/change-dropbear.sh" && chmod +x change-dropbear
    
    # VMess Menu
    wget -q -O menu-vmess "${REPO}/menu-vmess.sh" && chmod +x menu-vmess
    wget -q -O create-vmess "${REPO}/create-vmess.sh" && chmod +x create-vmess
    wget -q -O delete-vmess "${REPO}/delete-vmess.sh" && chmod +x delete-vmess
    wget -q -O cek-vmess "${REPO}/cek-vmess.sh" && chmod +x cek-vmess
    
    # VLess Menu
    wget -q -O menu-vless "${REPO}/menu-vless.sh" && chmod +x menu-vless
    wget -q -O create-vless "${REPO}/create-vless.sh" && chmod +x create-vless
    wget -q -O delete-vless "${REPO}/delete-vless.sh" && chmod +x delete-vless
    wget -q -O cek-vless "${REPO}/cek-vless.sh" && chmod +x cek-vless
    
    # Trojan Menu
    wget -q -O menu-trojan "${REPO}/menu-trojan.sh" && chmod +x menu-trojan
    wget -q -O create-trojan "${REPO}/create-trojan.sh" && chmod +x create-trojan
    wget -q -O delete-trojan "${REPO}/delete-trojan.sh" && chmod +x delete-trojan
    wget -q -O cek-trojan "${REPO}/cek-trojan.sh" && chmod +x cek-trojan
    
    # System Menu
    wget -q -O menu-system "${REPO}/menu-system.sh" && chmod +x menu-system
    wget -q -O change-domain "${REPO}/change-domain.sh" && chmod +x change-domain
    
    # API
    wget -q -O nexus-api "${REPO}/api.sh" && chmod +x nexus-api
    
    echo -e "${GREEN}✓ Scripts downloaded${NC}"
}

# Setup API
setup_api() {
    echo -e "${CYAN}Setting up API...${NC}"
    
    # Generate API Key
    API_KEY=$(openssl rand -hex 16)
    echo "${API_KEY}" > /etc/nexus/api-key.txt
    
    # Setup API web
    mkdir -p /var/www/html/api
    
    cat > /var/www/html/nexusapi.html <<'APIEOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nexus Tunnel API Documentation</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border-radius: 20px; padding: 40px; }
        h1 { font-size: 2.5em; margin-bottom: 10px; text-align: center; }
        .subtitle { text-align: center; opacity: 0.9; margin-bottom: 40px; }
        .endpoint { background: rgba(255,255,255,0.15); padding: 20px; margin: 20px 0; border-radius: 10px; border-left: 4px solid #4CAF50; }
        .method { display: inline-block; padding: 5px 15px; border-radius: 5px; font-weight: bold; margin-right: 10px; }
        .post { background: #2196F3; }
        .get { background: #4CAF50; }
        .delete { background: #f44336; }
        code { background: rgba(0,0,0,0.3); padding: 2px 8px; border-radius: 4px; font-family: 'Courier New', monospace; }
        .params { margin-top: 15px; }
        .param-item { margin: 10px 0; padding-left: 20px; }
        .example { background: rgba(0,0,0,0.4); padding: 15px; border-radius: 8px; margin-top: 10px; overflow-x: auto; }
        pre { color: #fff; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Nexus Tunnel API</h1>
        <p class="subtitle">Complete API Documentation for Developers</p>
        
        <div class="endpoint">
            <h2>Authentication</h2>
            <p>Semua request API memerlukan API Key di header:</p>
            <div class="example">
                <pre>X-API-Key: YOUR_API_KEY</pre>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <strong>/api/ssh/create</strong>
            <p>Membuat akun SSH baru</p>
            <div class="params">
                <strong>Parameters:</strong>
                <div class="param-item">• <code>username</code> (string, required) - Username SSH</div>
                <div class="param-item">• <code>password</code> (string, required) - Password</div>
                <div class="param-item">• <code>expired</code> (integer, required) - Masa aktif (hari)</div>
            </div>
            <div class="example">
                <strong>Example Request:</strong>
                <pre>
curl -X POST http://yourip/api/ssh/create \
  -H "X-API-Key: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "user123",
    "password": "pass123",
    "expired": 30
  }'</pre>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <strong>/api/vmess/create</strong>
            <p>Membuat akun VMess baru</p>
            <div class="params">
                <strong>Parameters:</strong>
                <div class="param-item">• <code>username</code> (string, required) - Username VMess</div>
                <div class="param-item">• <code>expired</code> (integer, required) - Masa aktif (hari)</div>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <strong>/api/vless/create</strong>
            <p>Membuat akun VLess baru</p>
            <div class="params">
                <strong>Parameters:</strong>
                <div class="param-item">• <code>username</code> (string, required) - Username VLess</div>
                <div class="param-item">• <code>expired</code> (integer, required) - Masa aktif (hari)</div>
            </div>
        </div>

        <div class="endpoint">
            <span class="method post">POST</span>
            <strong>/api/trojan/create</strong>
            <p>Membuat akun Trojan baru</p>
            <div class="params">
                <strong>Parameters:</strong>
                <div class="param-item">• <code>username</code> (string, required) - Username Trojan</div>
                <div class="param-item">• <code>expired</code> (integer, required) - Masa aktif (hari)</div>
            </div>
        </div>

        <div class="endpoint">
            <span class="method get">GET</span>
            <strong>/api/ssh/list</strong>
            <p>Mendapatkan daftar semua akun SSH</p>
        </div>

        <div class="endpoint">
            <span class="method get">GET</span>
            <strong>/api/vmess/list</strong>
            <p>Mendapatkan daftar semua akun VMess</p>
        </div>

        <div class="endpoint">
            <span class="method delete">DELETE</span>
            <strong>/api/ssh/delete</strong>
            <p>Menghapus akun SSH</p>
            <div class="params">
                <strong>Parameters:</strong>
                <div class="param-item">• <code>username</code> (string, required) - Username yang akan dihapus</div>
            </div>
        </div>

        <div class="endpoint">
            <h2>Response Format</h2>
            <p>Semua response API menggunakan format JSON:</p>
            <div class="example">
                <strong>Success Response:</strong>
                <pre>{
  "status": "success",
  "message": "Account created successfully",
  "data": {
    "username": "user123",
    "expired": "2024-03-15"
  }
}</pre>
            </div>
            <div class="example">
                <strong>Error Response:</strong>
                <pre>{
  "status": "error",
  "message": "Invalid API key"
}</pre>
            </div>
        </div>
    </div>
</body>
</html>
APIEOF
    
    echo -e "${GREEN}✓ API configured${NC}"
    echo -e "${YELLOW}API Key: ${API_KEY}${NC}"
}

# Main installation
main_install() {
    check_license
    
    # Buat direktori
    mkdir -p /etc/nexus
    mkdir -p /var/log/nexus
    
    input_domain
    install_dependencies
    install_ssl
    install_ssh
    install_xray
    setup_nginx
    download_scripts
    setup_api
    
    # Finish
    clear
    echo -e "${GREEN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║          ✓ INSTALLATION COMPLETED SUCCESSFULLY           ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    DOMAIN=$(cat /etc/nexus/domain)
    API_KEY=$(cat /etc/nexus/api-key.txt)
    
    echo -e "${CYAN}Domain    : ${DOMAIN}${NC}"
    echo -e "${CYAN}API Key   : ${API_KEY}${NC}"
    echo -e "${CYAN}API Docs  : http://$(curl -s https://api.ipify.org)/nexusapi.html${NC}"
    echo ""
    echo -e "${YELLOW}Ketik ${GREEN}menu${YELLOW} untuk membuka panel${NC}"
    echo ""
}

# Run installation
main_install
