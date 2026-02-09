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
║                      SSH MANAGEMENT                       ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Hitung total akun
TOTAL_SSH=$(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd | wc -l)
ACTIVE_SSH=$(ps -aux | grep sshd | grep -v root | grep priv | wc -l)
LOCKED_SSH=$(awk -F: '$2 == "!" {print $1}' /etc/shadow | wc -l)

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Total Accounts  ${NC}: ${GREEN}${TOTAL_SSH}${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Active Users    ${NC}: ${GREEN}${ACTIVE_SSH}${NC}"
echo -e "${BLUE}║${NC}  ${YELLOW}Locked Accounts ${NC}: ${RED}${LOCKED_SSH}${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                        ${PURPLE}SSH MENU${NC}                          ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} Create SSH Account                                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} Delete SSH Account                                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} Check Active SSH Users                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} Lock SSH Account                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} Unlock SSH Account                                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[6]${NC} Extend SSH Account                                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[7]${NC} Change Dropbear Version                           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[8]${NC} Show All SSH Accounts                             ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[0]${NC} Back to Main Menu                                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -ne "${YELLOW}Select menu ${NC}[${GREEN}0-8${NC}]${YELLOW}: ${NC}"
read -r menu

case $menu in
    1) create-ssh ;;
    2) delete-ssh ;;
    3) cek-ssh ;;
    4) lock-ssh ;;
    5) unlock-ssh ;;
    6) extend-ssh ;;
    7) change-dropbear ;;
    8) list-ssh ;;
    0) menu ;;
    *) echo -e "${RED}Invalid option${NC}" ; sleep 1 ; menu-ssh ;;
esac
