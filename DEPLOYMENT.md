# 🚀 PANDUAN UPLOAD KE GITHUB

## Langkah 1: Persiapan Repository

### Buat Repository Baru di GitHub
1. Login ke GitHub.com
2. Klik tombol **New Repository**
3. Nama repository: `nexus-tunnel`
4. Deskripsi: "Premium Multi-Protocol Tunneling System"
5. Pilih **Public**
6. ✅ Add README file (skip, kita sudah punya)
7. Klik **Create Repository**

## Langkah 2: Upload Files

### Via Web Interface (Mudah)

1. Di halaman repository yang baru dibuat, klik **Add file** → **Upload files**
2. Drag & drop semua file berikut:

```
✅ README.md
✅ INSTALL.md
✅ izin.txt
✅ setup.sh
✅ menu.sh
✅ menu-ssh.sh
✅ menu-vmess.sh
✅ menu-vless.sh
✅ menu-trojan.sh
✅ menu-system.sh
✅ create-ssh.sh
✅ create-vmess.sh
✅ create-vless.sh
✅ create-trojan.sh
✅ delete-ssh.sh
✅ delete-vmess.sh
✅ delete-vless.sh
✅ delete-trojan.sh
✅ cek-ssh.sh
✅ cek-vmess.sh
✅ cek-vless.sh
✅ cek-trojan.sh
✅ lock-ssh.sh
✅ unlock-ssh.sh
✅ extend-ssh.sh
✅ list-ssh.sh
✅ change-dropbear.sh
✅ change-domain.sh
✅ api.sh
```

3. Commit message: "Initial commit - Nexus Tunnel v1.0"
4. Klik **Commit changes**

### Via Git Command Line (Advanced)

```bash
# Clone folder dari server
cd /home/claude
tar -czf nexus-tunnel.tar.gz nexus-tunnel/

# Download ke komputer lokal
# Kemudian extract dan upload ke GitHub

# Atau langsung dari server (jika sudah ada git)
cd /home/claude/nexus-tunnel
git init
git add .
git commit -m "Initial commit - Nexus Tunnel v1.0"
git branch -M main
git remote add origin https://github.com/yourusername/nexus-tunnel.git
git push -u origin main
```

## Langkah 3: Update File izin.txt

**PENTING**: Setelah upload, edit file `izin.txt` di GitHub:

1. Buka file `izin.txt` di repository
2. Klik ikon **pensil** (Edit)
3. Tambahkan IP yang akan diizinkan:

```
### 103.123.45.67 2025-12-31 @admin_nexus
### 104.234.56.78 2026-06-30 @reseller_vip
```

4. Format: `### IP_ADDRESS EXPIRY_DATE @TELEGRAM_USERNAME`
5. Klik **Commit changes**

## Langkah 4: Update URL di setup.sh

Setelah upload, edit file `setup.sh`:

1. Buka `setup.sh` di repository
2. Klik edit
3. Ubah baris ini:
```bash
REPO="https://raw.githubusercontent.com/yourusername/nexus-tunnel/main"
```
Ganti `yourusername` dengan username GitHub Anda

4. Commit changes

## Langkah 5: Test Installation

Test installer dari repository:

```bash
wget https://raw.githubusercontent.com/yourusername/nexus-tunnel/main/setup.sh
chmod +x setup.sh
./setup.sh
```

## Langkah 6: Buat Release (Opsional)

1. Di repository, klik **Releases** → **Create a new release**
2. Tag version: `v1.0.0`
3. Release title: `Nexus Tunnel v1.0 - Initial Release`
4. Description:
```markdown
## 🚀 Nexus Tunnel v1.0 - Premium Multi-Protocol Tunneling

### ✨ Features
- ✅ SSH/Dropbear Support
- ✅ VMess (WebSocket + TLS)
- ✅ VLess (WebSocket + TLS)  
- ✅ Trojan (WebSocket + TLS)
- ✅ RESTful API Integration
- ✅ Auto SSL Certificate
- ✅ Beautiful Terminal UI

### 📦 Installation
```bash
wget https://raw.githubusercontent.com/yourusername/nexus-tunnel/main/setup.sh
chmod +x setup.sh
./setup.sh
```

### 📝 Requirements
- Ubuntu 20.04/22.04/24.04
- IP whitelisted in izin.txt
- Valid domain name

### 📞 Support
Telegram: @YourTelegramUsername
```

5. Klik **Publish release**

## Langkah 7: Custom Domain (Opsional)

Gunakan raw.githubusercontent.com untuk instalasi:

```bash
# Format lengkap
https://raw.githubusercontent.com/USERNAME/nexus-tunnel/main/setup.sh

# Contoh
https://raw.githubusercontent.com/johndoe/nexus-tunnel/main/setup.sh
```

## Langkah 8: Update README dengan Link Installer

Edit README.md dan update link instalasi:

```markdown
## Installation

```bash
wget -O setup.sh https://raw.githubusercontent.com/YOUR_USERNAME/nexus-tunnel/main/setup.sh && chmod +x setup.sh && ./setup.sh
```
```

## 🔧 Struktur Repository yang Benar

```
nexus-tunnel/
│
├── 📄 README.md              # Dokumentasi lengkap
├── 📄 INSTALL.md            # Panduan instalasi cepat
├── 📄 DEPLOYMENT.md         # File ini
│
├── 📁 Core Files
│   ├── izin.txt             # License file
│   ├── setup.sh             # Main installer
│   └── api.sh               # API handler
│
├── 📁 Menu Scripts
│   ├── menu.sh              # Main menu
│   ├── menu-ssh.sh          # SSH management
│   ├── menu-vmess.sh        # VMess management
│   ├── menu-vless.sh        # VLess management
│   ├── menu-trojan.sh       # Trojan management
│   └── menu-system.sh       # System tools
│
├── 📁 SSH Scripts
│   ├── create-ssh.sh
│   ├── delete-ssh.sh
│   ├── cek-ssh.sh
│   ├── lock-ssh.sh
│   ├── unlock-ssh.sh
│   ├── extend-ssh.sh
│   ├── list-ssh.sh
│   └── change-dropbear.sh
│
├── 📁 VMess Scripts
│   ├── create-vmess.sh
│   ├── delete-vmess.sh
│   └── cek-vmess.sh
│
├── 📁 VLess Scripts
│   ├── create-vless.sh
│   ├── delete-vless.sh
│   └── cek-vless.sh
│
├── 📁 Trojan Scripts
│   ├── create-trojan.sh
│   ├── delete-trojan.sh
│   └── cek-trojan.sh
│
└── 📁 System Scripts
    └── change-domain.sh
```

## 📝 Checklist Sebelum Launch

- [ ] Semua file sudah di upload
- [ ] izin.txt sudah diupdate dengan IP yang benar
- [ ] URL di setup.sh sudah diganti dengan username GitHub yang benar
- [ ] Test instalasi berhasil di VPS fresh
- [ ] API key generation berfungsi
- [ ] Semua menu dapat diakses
- [ ] SSL certificate berhasil di-install
- [ ] README.md sudah dilengkapi
- [ ] Telegram username untuk support sudah benar

## 🎯 Tips Marketing

### Buat README Badge
Tambahkan di bagian atas README.md:

```markdown
![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![License](https://img.shields.io/badge/license-Premium-green.svg)
![Downloads](https://img.shields.io/github/downloads/yourusername/nexus-tunnel/total)
![Stars](https://img.shields.io/github/stars/yourusername/nexus-tunnel)
```

### Screenshot
Ambil screenshot:
1. Menu utama
2. Create account VMess dengan link
3. API documentation page
4. System monitoring

Upload ke repository dalam folder `screenshots/`

### Video Demo (Opsional)
Buat video tutorial pendek:
1. Instalasi
2. Create account
3. Test koneksi
4. API usage

Upload ke YouTube dan link di README

## 🔒 Security Notes

1. **Jangan commit** file yang berisi:
   - Private key
   - Real IP addresses
   - Real telegram usernames di izin.txt
   - API keys

2. **Gunakan placeholder** di izin.txt:
```
### 103.123.45.67 2025-12-31 @example_user
```

3. **Instruksikan user** untuk contact Anda untuk whitelist

## 📞 Support Channels

Setup beberapa channel support:
- Telegram Group
- Telegram Channel untuk updates
- GitHub Issues untuk bug reports
- Email untuk license requests

---

**Selamat!** Script Anda sudah siap dipublikasikan! 🎉
