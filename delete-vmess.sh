#!/bin/bash
# delete-vmess.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                ${RED}DELETE VMESS ACCOUNT${NC}                     ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -ne "${YELLOW}Enter username to delete: ${NC}"
read -r username

if [[ ! -f /etc/nexus/vmess/${username}.conf ]]; then
    echo -e "${RED}✗ User not found!${NC}"
    sleep 2
    menu-vmess
fi

echo -ne "${YELLOW}Are you sure want to delete ${RED}${username}${YELLOW}? (y/n): ${NC}"
read -r confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    uuid=$(grep "UUID:" /etc/nexus/vmess/${username}.conf | awk '{print $2}')
    
    # Remove from Xray config
    cat /usr/local/etc/xray/config.json | jq "del(.inbounds[0].settings.clients[] | select(.email==\"${username}\"))" > /tmp/xray_config.tmp
    mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json
    
    systemctl restart xray
    
    rm -f /etc/nexus/vmess/${username}.conf
    rm -f /etc/nexus/vmess/${username}.txt
    
    echo -e "${GREEN}✓ User ${username} deleted successfully!${NC}"
else
    echo -e "${YELLOW}Deletion cancelled${NC}"
fi

sleep 2
menu-vmess
