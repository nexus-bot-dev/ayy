#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}               ${GREEN}TROJAN ACTIVE CONNECTIONS${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}NO  USERNAME           PASSWORD (Last 8)  STATUS${NC}         ${BLUE}║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════════════════════╣${NC}"

num=1
for conf in /etc/nexus/trojan/*.conf; do
    if [[ -f "$conf" ]]; then
        username=$(grep "Username:" ${conf} | awk '{print $2}')
        password=$(grep "Password:" ${conf} | awk '{print $2}')
        pass_short="${password: -8}"
        
        if grep -q "$password" /var/log/xray/access.log 2>/dev/null; then
            status="${GREEN}CONNECTED${NC}"
        else
            status="${YELLOW}IDLE${NC}"
        fi
        
        printf "${BLUE}║${NC} ${GREEN}%-3s${NC} %-18s %-17s %b ${BLUE}║${NC}\n" "$num" "$username" "$pass_short" "$status"
        num=$((num+1))
    fi
done

echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

TOTAL=$(( num - 1 ))
echo -e "${YELLOW}Total Trojan Accounts: ${GREEN}${TOTAL}${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu-trojan
