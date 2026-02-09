# NEXUS TUNNEL - QUICK INSTALLATION GUIDE

## 🚀 Quick Start (3 Steps)

### Step 1: Get License
Contact admin to whitelist your IP in `izin.txt`:
```
### YOUR_VPS_IP 2025-12-31 @your_telegram
```

### Step 2: Install
```bash
apt update -y && apt install -y wget curl
wget https://raw.githubusercontent.com/yourusername/nexus-tunnel/main/setup.sh
chmod +x setup.sh
./setup.sh
```

### Step 3: Open Menu
```bash
menu
```

## 📁 File Structure to Upload to GitHub

```
nexus-tunnel/
├── README.md              # Full documentation
├── INSTALL.md            # This quick guide
├── izin.txt              # License file
├── setup.sh              # Main installer
├── menu.sh               # Main menu
├── menu-ssh.sh           # SSH menu
├── menu-vmess.sh         # VMess menu
├── menu-vless.sh         # VLess menu
├── menu-trojan.sh        # Trojan menu
├── create-ssh.sh         # Create SSH
├── create-vmess.sh       # Create VMess
├── create-vless.sh       # Create VLess
├── create-trojan.sh      # Create Trojan
├── delete-ssh.sh         # Delete SSH
├── delete-vmess.sh       # Delete VMess
├── delete-vless.sh       # Delete VLess
├── delete-trojan.sh      # Delete Trojan
├── cek-ssh.sh           # Check SSH
├── cek-vmess.sh         # Check VMess
├── cek-vless.sh         # Check VLess
├── cek-trojan.sh        # Check Trojan
├── lock-ssh.sh          # Lock SSH
├── unlock-ssh.sh        # Unlock SSH
├── extend-ssh.sh        # Extend SSH
├── list-ssh.sh          # List SSH
├── change-dropbear.sh   # Change Dropbear
├── change-domain.sh     # Change domain
├── api.sh               # API handler
└── menu-system.sh       # System menu
```

## 🔑 Important URLs After Install

- **API Documentation**: http://YOUR_IP/nexusapi.html
- **API Key Location**: /etc/nexus/api-key.txt
- **Domain File**: /etc/nexus/domain

## 📞 Support

- GitHub: https://github.com/yourusername/nexus-tunnel
- Telegram: @YourTelegramUsername

## ⚙️ Default Ports

| Service | Port |
|---------|------|
| SSH | 22 |
| Dropbear | 143, 109, 69 |
| VMess | 443 |
| VLess | 8443 |
| Trojan | 9443 |
| Squid | 3128, 8080 |

## 🛠️ Basic Commands

```bash
# Open main menu
menu

# Open SSH menu
menu-ssh

# Open VMess menu
menu-vmess

# Check all services
systemctl status ssh dropbear xray nginx

# View logs
tail -f /var/log/xray/access.log
tail -f /var/log/nexus/api.log
```

## 🔄 Update Scripts

```bash
cd /usr/bin
wget -O menu https://raw.githubusercontent.com/yourusername/nexus-tunnel/main/menu.sh
chmod +x menu
```

## ⚠️ Before You Start

1. ✅ Fresh Ubuntu 20.04/22.04/24.04
2. ✅ Root access
3. ✅ Public IP address
4. ✅ Domain pointed to your IP
5. ✅ IP whitelisted in izin.txt
6. ✅ Ports 80, 443 open

## 🎯 First Time Setup Flow

```
1. Run setup.sh
2. Script checks license
3. Enter your domain
4. Wait for installation (5-10 minutes)
5. Note down your API key
6. Type 'menu' to start
```

## 📝 License File Format

```
### IP_ADDRESS YYYY-MM-DD @telegram_username
```

Example:
```
### 103.123.45.67 2025-12-31 @admin_nexus
### 104.234.56.78 2026-06-30 @reseller_indo
```

---

**Nexus Tunnel** - Premium Multi-Protocol Tunneling System
