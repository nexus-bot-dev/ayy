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
echo -e "${CYAN}║${NC}                 ${GREEN}CREATE SSH ACCOUNT${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Input username
echo -ne "${YELLOW}Username: ${NC}"
read -r username

# Cek apakah user sudah ada
if id "$username" &>/dev/null; then
    echo -e "${RED}✗ User already exists!${NC}"
    sleep 2
    menu-ssh
fi

# Input password
echo -ne "${YELLOW}Password: ${NC}"
read -r password

# Input masa aktif
echo -ne "${YELLOW}Expired (days): ${NC}"
read -r days

# Hitung tanggal expired
exp_date=$(date -d "+${days} days" +"%Y-%m-%d")

# Buat user
useradd -M -N -s /bin/false -e ${exp_date} ${username}
echo "${username}:${password}" | chpasswd

# Simpan info user
mkdir -p /etc/nexus/ssh
cat > /etc/nexus/ssh/${username}.conf <<EOF
Username: ${username}
Password: ${password}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF

clear
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}              ${CYAN}SSH ACCOUNT CREATED SUCCESSFULLY${NC}             ${GREEN}║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}                   ${YELLOW}ACCOUNT DETAILS${NC}                        ${BLUE}║${NC}"
echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Domain/IP    ${NC}: ${GREEN}${DOMAIN}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}IP Address   ${NC}: ${GREEN}${MYIP}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Username     ${NC}: ${GREEN}${username}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Password     ${NC}: ${GREEN}${password}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Expired Date ${NC}: ${RED}${exp_date}${NC}"
echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC}                    ${YELLOW}CONNECTION INFO${NC}                       ${BLUE}║${NC}"
echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}SSH Port     ${NC}: ${GREEN}22${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Dropbear     ${NC}: ${GREEN}143, 109, 69${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}SSL/TLS      ${NC}: ${GREEN}443, 447${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Squid Proxy  ${NC}: ${GREEN}3128, 8080${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}BadVPN       ${NC}: ${GREEN}7100-7300${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                  ${PURPLE}PAYLOAD EXAMPLES${NC}                        ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}Direct:${NC}"
echo -e "${CYAN}║${NC} GET / HTTP/1.1[crlf]Host: ${DOMAIN}[crlf][crlf]"
echo -e "${CYAN}║${NC}"
echo -e "${CYAN}║${NC} ${YELLOW}WebSocket:${NC}"
echo -e "${CYAN}║${NC} GET wss://bug.com/ HTTP/1.1[crlf]Host: ${DOMAIN}[crlf]"
echo -e "${CYAN}║${NC} Upgrade: websocket[crlf][crlf]"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu-ssh
