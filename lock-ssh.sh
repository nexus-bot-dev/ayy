#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                  ${RED}LOCK SSH ACCOUNT${NC}                        ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -ne "${YELLOW}Enter username to lock: ${NC}"
read -r username

if ! id "$username" &>/dev/null; then
    echo -e "${RED}✗ User not found!${NC}"
    sleep 2
    menu-ssh
fi

# Lock account
passwd -l ${username}

# Kill active sessions
pkill -u ${username}

echo -e "${GREEN}✓ User ${username} locked successfully!${NC}"
sleep 2
menu-ssh
