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
║                     VMESS MANAGEMENT                      ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Hitung total akun
TOTAL_VMESS=$(ls -1 /etc/nexus/vmess/ 2>/dev/null | wc -l)
ACTIVE_VMESS=$(grep -c "vmess://" /var/log/xray/access.log 2>/dev/null || echo "0")

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Total Accounts  ${NC}: ${GREEN}${TOTAL_VMESS}${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Active Users    ${NC}: ${GREEN}${ACTIVE_VMESS}${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                       ${PURPLE}VMESS MENU${NC}                         ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} Create VMess Account                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} Delete VMess Account                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} Check Active VMess Users                          ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} Extend VMess Account                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} Show All VMess Accounts                           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[0]${NC} Back to Main Menu                                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -ne "${YELLOW}Select menu ${NC}[${GREEN}0-5${NC}]${YELLOW}: ${NC}"
read -r menu

case $menu in
    1) create-vmess ;;
    2) delete-vmess ;;
    3) cek-vmess ;;
    4) extend-vmess ;;
    5) list-vmess ;;
    0) menu ;;
    *) echo -e "${RED}Invalid option${NC}" ; sleep 1 ; menu-vmess ;;
esac
