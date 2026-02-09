#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                    TROJAN MANAGEMENT                      ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Hitung total akun
TOTAL_TROJAN=$(ls -1 /etc/nexus/trojan/ 2>/dev/null | wc -l)
ACTIVE_TROJAN=$(grep -c "trojan://" /var/log/xray/access.log 2>/dev/null || echo "0")

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Total Accounts  ${NC}: ${GREEN}${TOTAL_TROJAN}${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Active Users    ${NC}: ${GREEN}${ACTIVE_TROJAN}${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                      ${PURPLE}TROJAN MENU${NC}                         ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} Create Trojan Account                             ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} Delete Trojan Account                             ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} Check Active Trojan Users                         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} Extend Trojan Account                             ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} Show All Trojan Accounts                          ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[0]${NC} Back to Main Menu                                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -ne "${YELLOW}Select menu ${NC}[${GREEN}0-5${NC}]${YELLOW}: ${NC}"
read -r menu

case $menu in
    1) create-trojan ;;
    2) delete-trojan ;;
    3) cek-trojan ;;
    4) extend-trojan ;;
    5) list-trojan ;;
    0) menu ;;
    *) echo -e "${RED}Invalid option${NC}" ; sleep 1 ; menu-trojan ;;
esac
