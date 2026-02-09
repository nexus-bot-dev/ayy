#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

DOMAIN=$(cat /etc/nexus/domain)
MYIP=$(curl -s https://api.ipify.org)

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                ${GREEN}CREATE VMESS ACCOUNT${NC}                     ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Input username
echo -ne "${YELLOW}Username: ${NC}"
read -r username

# Cek apakah sudah ada
if [[ -f /etc/nexus/vmess/${username}.conf ]]; then
    echo -e "${RED}✗ User already exists!${NC}"
    sleep 2
    menu-vmess
fi

# Input masa aktif
echo -ne "${YELLOW}Expired (days): ${NC}"
read -r days

# Generate UUID
uuid=$(cat /proc/sys/kernel/random/uuid)
exp_date=$(date -d "+${days} days" +"%Y-%m-%d")

# Tambahkan ke config Xray
cat /usr/local/etc/xray/config.json | jq ".inbounds[0].settings.clients += [{\"id\": \"${uuid}\", \"email\": \"${username}\"}]" > /tmp/xray_config.tmp
mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json

# Restart Xray
systemctl restart xray

# Simpan info
mkdir -p /etc/nexus/vmess
cat > /etc/nexus/vmess/${username}.conf <<EOF
Username: ${username}
UUID: ${uuid}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF

# Generate VMess link
vmess_json=$(cat <<VMESSJSON
{
  "v": "2",
  "ps": "${username}",
  "add": "${DOMAIN}",
  "port": "443",
  "id": "${uuid}",
  "aid": "0",
  "net": "ws",
  "path": "/vmess",
  "type": "none",
  "host": "${DOMAIN}",
  "tls": "tls"
}
VMESSJSON
)

vmess_link="vmess://$(echo -n ${vmess_json} | base64 -w 0)"

clear
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}             ${CYAN}VMESS ACCOUNT CREATED SUCCESSFULLY${NC}           ${GREEN}║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}                   ${YELLOW}ACCOUNT DETAILS${NC}                        ${BLUE}║${NC}"
echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Remarks      ${NC}: ${GREEN}${username}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Domain       ${NC}: ${GREEN}${DOMAIN}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}IP Address   ${NC}: ${GREEN}${MYIP}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Port TLS     ${NC}: ${GREEN}443${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}UUID         ${NC}: ${GREEN}${uuid}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}AlterID      ${NC}: ${GREEN}0${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Security     ${NC}: ${GREEN}auto${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Network      ${NC}: ${GREEN}WS${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Path         ${NC}: ${GREEN}/vmess${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Expired Date ${NC}: ${RED}${exp_date}${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                    ${PURPLE}VMESS LINK${NC}                            ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}${vmess_link}${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Save to file
echo "${vmess_link}" > /etc/nexus/vmess/${username}.txt

echo -e "${YELLOW}Link saved to: ${GREEN}/etc/nexus/vmess/${username}.txt${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu-vmess
