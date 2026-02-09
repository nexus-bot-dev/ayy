#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                 ${RED}DELETE SSH ACCOUNT${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -ne "${YELLOW}Enter username to delete: ${NC}"
read -r username

if ! id "$username" &>/dev/null; then
    echo -e "${RED}✗ User not found!${NC}"
    sleep 2
    menu-ssh
fi

echo -ne "${YELLOW}Are you sure want to delete ${RED}${username}${YELLOW}? (y/n): ${NC}"
read -r confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    # Kill user sessions
    pkill -u ${username}
    
    # Delete user
    userdel -r ${username} 2>/dev/null
    
    # Delete config file
    rm -f /etc/nexus/ssh/${username}.conf
    
    echo -e "${GREEN}✓ User ${username} deleted successfully!${NC}"
else
    echo -e "${YELLOW}Deletion cancelled${NC}"
fi

sleep 2
menu-ssh
