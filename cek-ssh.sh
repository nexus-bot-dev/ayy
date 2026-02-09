#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                 ${GREEN}ACTIVE SSH CONNECTIONS${NC}                   ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

data=($(ps aux | grep -i dropbear | awk '{print $2}'))
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}NO  USERNAME           IP ADDRESS        LOGIN TIME${NC}       ${BLUE}║${NC}"
echo -e "${BLUE}╠════════════════════════════════════════════════════════════════╣${NC}"

num=1
for pid in "${data[@]}"; do
    num_users=$(cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | wc -l)
    username=$(cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | awk '{print $10}' | tail -n $num | head -n 1)
    ipaddress=$(cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | awk '{print $12}' | tail -n $num | head -n 1)
    login_time=$(cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | awk '{print $1" "$2" "$3}' | tail -n $num | head -n 1)
    
    if [[ ! -z "$username" ]]; then
        printf "${BLUE}║${NC} ${GREEN}%-3s${NC} %-18s %-17s %-15s ${BLUE}║${NC}\n" "$num" "$username" "$ipaddress" "$login_time"
    fi
    num=$((num+1))
done

echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

TOTAL_ACTIVE=$(ps aux | grep -i dropbear | grep -v grep | wc -l)
echo -e "${YELLOW}Total Active Connections: ${GREEN}${TOTAL_ACTIVE}${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu-ssh
