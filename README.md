# 🚀 Nexus Tunnel - Premium Multi-Protocol Tunneling System

<div align="center">

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![License](https://img.shields.io/badge/license-Premium-green.svg)
![Support](https://img.shields.io/badge/support-SSH%20%7C%20VMess%20%7C%20VLess%20%7C%20Trojan-orange.svg)

**Professional Grade Tunneling Solution with API Integration**

[Features](#features) • [Installation](#installation) • [API Documentation](#api-documentation) • [Support](#support)

</div>

---

## ✨ Features

### 🔐 Multi-Protocol Support
- **SSH/OpenSSH** - Port 22, 2222
- **Dropbear** - Port 143, 109, 69 (Changeable versions)
- **VMess (WebSocket + TLS)** - Port 443
- **VLess (WebSocket + TLS)** - Port 8443
- **Trojan (WebSocket + TLS)** - Port 9443

### 🎯 Advanced Management
- ✅ Create/Delete accounts with expiry date
- ✅ Lock/Unlock user accounts
- ✅ Check active connections real-time
- ✅ Automatic SSL certificate from Let's Encrypt
- ✅ Change domain with auto SSL renewal
- ✅ Dropbear version switching
- ✅ Backup & Restore functionality

### 🌐 API Integration
- ✅ RESTful API for web panel integration
- ✅ Secure API key authentication
- ✅ JSON response format
- ✅ Complete CRUD operations
- ✅ Developer-friendly documentation

### 🔒 Security Features
- ✅ License-based IP authentication
- ✅ Expiry date validation
- ✅ Telegram username tracking
- ✅ SSL/TLS encryption
- ✅ API key protection

### 💎 Premium UI/UX
- ✅ Beautiful colored terminal interface
- ✅ Real-time system statistics
- ✅ User-friendly menus
- ✅ Detailed account information display

---

## 📋 Requirements

### Minimum Server Specifications
- **OS**: Ubuntu 20.04/22.04/24.04 LTS
- **RAM**: 1GB minimum (2GB recommended)
- **Storage**: 10GB minimum
- **Network**: Public IP address required
- **Domain**: A valid domain pointing to your server IP

### Required Packages
All dependencies will be installed automatically:
- curl, wget, screen, socat, jq, git
- nginx, squid, vnstat
- dropbear, openssh-server
- xray-core
- acme.sh (SSL certificate)

---

## 🚀 Installation

### Step 1: Prepare License

Contact admin to get your IP whitelisted. Add your IP to `izin.txt`:

```
### YOUR_IP_ADDRESS EXPIRY_DATE @telegram_username
```

Example:
```
### 103.123.45.67 2025-12-31 @admin_nexus
```

### Step 2: Install Script

```bash
wget -O setup.sh https://raw.githubusercontent.com/nexus-bot-dev/ayy/main/setup.sh && chmod +x setup.sh && ./setup.sh
```

### Step 3: Follow Installation Wizard

The installer will:
1. ✅ Verify your license
2. ✅ Request domain input
3. ✅ Install all dependencies
4. ✅ Configure SSL certificate
5. ✅ Setup all services
6. ✅ Generate API key

### Step 4: Access Menu

After installation, type:
```bash
menu
```

---

## 🎮 Menu Navigation

### Main Menu Options

```
[1] SSH Menu        - Manage SSH/Dropbear accounts
[2] VMess Menu      - Manage VMess accounts
[3] VLess Menu      - Manage VLess accounts
[4] Trojan Menu     - Manage Trojan accounts
[5] Check Service   - View all service status
[6] System Menu     - System management tools
[7] Change Domain   - Update domain and SSL
[8] Renew SSL       - Force SSL renewal
[9] Backup & Restore - Data backup tools
[0] Exit            - Exit menu
```

### SSH Menu Features

```
[1] Create SSH Account      - Add new SSH user
[2] Delete SSH Account      - Remove SSH user
[3] Check Active Users      - View connected users
[4] Lock SSH Account        - Temporarily disable user
[5] Unlock SSH Account      - Re-enable locked user
[6] Extend SSH Account      - Extend expiry date
[7] Change Dropbear Version - Switch Dropbear version
[8] Show All Accounts       - List all SSH users
```

### VMess/VLess/Trojan Menu Features

```
[1] Create Account          - Generate new account with link
[2] Delete Account          - Remove account
[3] Check Active Users      - View active connections
[4] Extend Account          - Extend expiry date
[5] Show All Accounts       - List all accounts
```

---

## 🌐 API Documentation

### Base URL
```
http://YOUR_IP/api
```

### Authentication

All API requests require API key in header:
```
X-API-Key: your_api_key_here
```

Get your API key:
```bash
cat /etc/nexus/api-key.txt
```

### API Endpoints

#### 1. Create SSH Account

**Endpoint**: `POST /api/ssh/create`

**Request Body**:
```json
{
  "username": "user123",
  "password": "pass123",
  "expired": 30
}
```

**Response**:
```json
{
  "status": "success",
  "message": "SSH account created successfully",
  "data": {
    "username": "user123",
    "password": "pass123",
    "expired": "2024-03-15"
  }
}
```

**cURL Example**:
```bash
curl -X POST http://yourip/api/ssh/create \
  -H "X-API-Key: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "user123",
    "password": "pass123",
    "expired": 30
  }'
```

---

#### 2. Create VMess Account

**Endpoint**: `POST /api/vmess/create`

**Request Body**:
```json
{
  "username": "vmess_user",
  "expired": 30
}
```

**Response**:
```json
{
  "status": "success",
  "message": "VMess account created successfully",
  "data": {
    "username": "vmess_user",
    "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "expired": "2024-03-15",
    "link": "vmess://base64encodedlink"
  }
}
```

---

#### 3. Create VLess Account

**Endpoint**: `POST /api/vless/create`

**Request Body**:
```json
{
  "username": "vless_user",
  "expired": 30
}
```

**Response**:
```json
{
  "status": "success",
  "message": "VLess account created successfully",
  "data": {
    "username": "vless_user",
    "uuid": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "expired": "2024-03-15",
    "link": "vless://uuid@domain:port?params"
  }
}
```

---

#### 4. Create Trojan Account

**Endpoint**: `POST /api/trojan/create`

**Request Body**:
```json
{
  "username": "trojan_user",
  "expired": 30
}
```

**Response**:
```json
{
  "status": "success",
  "message": "Trojan account created successfully",
  "data": {
    "username": "trojan_user",
    "password": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "expired": "2024-03-15",
    "link": "trojan://password@domain:port?params"
  }
}
```

---

#### 5. Delete SSH Account

**Endpoint**: `DELETE /api/ssh/delete`

**Request Body**:
```json
{
  "username": "user123"
}
```

**Response**:
```json
{
  "status": "success",
  "message": "SSH account deleted successfully"
}
```

---

#### 6. List SSH Accounts

**Endpoint**: `GET /api/ssh/list`

**Response**:
```json
{
  "status": "success",
  "message": "SSH accounts retrieved",
  "data": [
    {
      "username": "user1",
      "created": "2024-02-01 10:00:00",
      "expired": "2024-03-01"
    },
    {
      "username": "user2",
      "created": "2024-02-05 14:30:00",
      "expired": "2024-03-05"
    }
  ]
}
```

---

#### 7. List VMess Accounts

**Endpoint**: `GET /api/vmess/list`

**Response**:
```json
{
  "status": "success",
  "message": "VMess accounts retrieved",
  "data": [
    {
      "username": "vmess1",
      "uuid": "xxx-xxx-xxx",
      "created": "2024-02-01 10:00:00",
      "expired": "2024-03-01"
    }
  ]
}
```

---

### Error Responses

**Invalid API Key**:
```json
{
  "status": "error",
  "message": "Invalid API key"
}
```

**User Already Exists**:
```json
{
  "status": "error",
  "message": "User already exists"
}
```

**Missing Parameters**:
```json
{
  "status": "error",
  "message": "Missing required parameters"
}
```

---

## 🔧 Configuration Files

### Important Directories

```
/etc/nexus/
├── domain                  # Domain configuration
├── api-key.txt            # API key
├── cert.crt               # SSL certificate
├── cert.key               # SSL private key
├── ssh/                   # SSH account configs
├── vmess/                 # VMess account configs
├── vless/                 # VLess account configs
└── trojan/                # Trojan account configs

/var/log/nexus/
└── api.log                # API access logs
```

### Service Ports

| Service | Port | Protocol |
|---------|------|----------|
| SSH | 22 | TCP |
| Dropbear | 143, 109, 69 | TCP |
| VMess | 443 | TCP/TLS |
| VLess | 8443 | TCP/TLS |
| Trojan | 9443 | TCP/TLS |
| Squid Proxy | 3128, 8080 | TCP |
| Nginx HTTP | 80 | TCP |
| Nginx HTTPS | 443 | TCP |

---

## 📱 Client Configuration Examples

### SSH Client (HTTP Injector)

```
Host: your.domain.com
Port: 143 (Dropbear) or 22 (OpenSSH)
Username: your_username
Password: your_password

Payload:
GET / HTTP/1.1[crlf]Host: your.domain.com[crlf][crlf]
```

### VMess Client (v2rayNG)

Import link directly or use manual config:
```
Address: your.domain.com
Port: 443
UUID: your-uuid
Security: auto
Network: ws
Path: /vmess
TLS: enabled
```

### VLess Client

```
Address: your.domain.com
Port: 8443
UUID: your-uuid
Encryption: none
Network: ws
Path: /vless
TLS: enabled
```

### Trojan Client

```
Address: your.domain.com
Port: 9443
Password: your-password
Network: ws
Path: /trojan
TLS: enabled
```

---

## 🛠️ Troubleshooting

### Service Not Running

Check service status:
```bash
systemctl status ssh
systemctl status dropbear
systemctl status xray
systemctl status nginx
```

Restart services:
```bash
systemctl restart ssh
systemctl restart dropbear
systemctl restart xray
systemctl restart nginx
```

### SSL Certificate Issues

Force renew SSL:
```bash
~/.acme.sh/acme.sh --renew -d yourdomain.com --force --ecc
```

### Check Logs

View system logs:
```bash
tail -f /var/log/syslog
tail -f /var/log/xray/access.log
tail -f /var/log/nexus/api.log
```

### Firewall Configuration

Ensure ports are open:
```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 143/tcp
ufw allow 109/tcp
ufw allow 69/tcp
ufw allow 8443/tcp
ufw allow 9443/tcp
ufw reload
```

---

## 🔄 Updates

Update to latest version:
```bash
cd /usr/bin
wget -O menu https://raw.githubusercontent.com/nexus-bot-dev/ayy/main/menu.sh
chmod +x menu
```

---

## 📞 Support

- **Telegram**: @YourTelegramUsername
- **GitHub Issues**: [Create Issue](https://github.com/nexus-bot-dev/ayy/issues)
- **Documentation**: http://yourip/nexusapi.html

--- 

## 📝 License Format

File: `izin.txt`

```
### IP_ADDRESS EXPIRY_DATE @TELEGRAM_USERNAME
```

Example:
```
### 103.123.45.67 2025-12-31 @admin_nexus
### 104.234.56.78 2025-06-30 @user_premium
```

**Format Rules**:
- Must start with `###`
- IP address (IPv4)
- Expiry date (YYYY-MM-DD)
- Telegram username (with @)
- One entry per line

---

## ⚠️ Important Notes

1. **Keep your API key secret** - Never share it publicly
2. **Regular backups** - Use the backup menu regularly
3. **Monitor resources** - Check CPU/RAM usage in main menu
4. **Update SSL** - Certificates auto-renew, but check monthly
5. **License expiry** - Renew before expiration date
6. **Domain changes** - Use change-domain menu, don't edit files directly

---

## 🎯 Features Roadmap

- [ ] Add Shadowsocks support
- [ ] WebSocket TLS optimization
- [ ] Multi-user bandwidth limiting
- [ ] Telegram bot integration
- [ ] Auto backup to cloud storage
- [ ] Web panel (optional)
- [ ] Usage statistics dashboard

---

## 🙏 Credits

Developed with ❤️ for premium tunneling experience

**Technologies Used**:
- Xray-Core
- Nginx
- Dropbear
- OpenSSH
- Let's Encrypt
- Acme.sh

---

<div align="center">

**Nexus Tunnel** - *Premium Multi-Protocol Tunneling System*

[⬆ Back to Top](#-nexus-tunnel---premium-multi-protocol-tunneling-system)

</div>
