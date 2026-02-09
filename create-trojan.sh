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
echo -e "${CYAN}║${NC}               ${GREEN}CREATE TROJAN ACCOUNT${NC}                     ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Input username
echo -ne "${YELLOW}Username: ${NC}"
read -r username

# Cek apakah sudah ada
if [[ -f /etc/nexus/trojan/${username}.conf ]]; then
    echo -e "${RED}✗ User already exists!${NC}"
    sleep 2
    menu-trojan
fi

# Input masa aktif
echo -ne "${YELLOW}Expired (days): ${NC}"
read -r days

# Generate Password (UUID)
password=$(cat /proc/sys/kernel/random/uuid)
exp_date=$(date -d "+${days} days" +"%Y-%m-%d")

# Tambahkan ke config Xray
cat /usr/local/etc/xray/config.json | jq ".inbounds[2].settings.clients += [{\"password\": \"${password}\", \"email\": \"${username}\"}]" > /tmp/xray_config.tmp
mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json

# Restart Xray
systemctl restart xray

# Simpan info
mkdir -p /etc/nexus/trojan
cat > /etc/nexus/trojan/${username}.conf <<EOF
Username: ${username}
Password: ${password}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF

# Generate Trojan link
trojan_link="trojan://${password}@${DOMAIN}:9443?path=/trojan&security=tls&type=ws&host=${DOMAIN}#${username}"

clear
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}            ${CYAN}TROJAN ACCOUNT CREATED SUCCESSFULLY${NC}           ${GREEN}║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}                   ${YELLOW}ACCOUNT DETAILS${NC}                        ${BLUE}║${NC}"
echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Remarks      ${NC}: ${GREEN}${username}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Domain       ${NC}: ${GREEN}${DOMAIN}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}IP Address   ${NC}: ${GREEN}${MYIP}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Port TLS     ${NC}: ${GREEN}9443${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Password     ${NC}: ${GREEN}${password}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Network      ${NC}: ${GREEN}WS${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Path         ${NC}: ${GREEN}/trojan${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Security     ${NC}: ${GREEN}TLS${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Expired Date ${NC}: ${RED}${exp_date}${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                   ${PURPLE}TROJAN LINK${NC}                            ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}${trojan_link}${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Save to file
echo "${trojan_link}" > /etc/nexus/trojan/${username}.txt

echo -e "${YELLOW}Link saved to: ${GREEN}/etc/nexus/trojan/${username}.txt${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu-trojan
