#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                ${PURPLE}EXTEND SSH ACCOUNT${NC}                    ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -ne "${YELLOW}Enter username: ${NC}"
read -r username

if ! id "$username" &>/dev/null; then
    echo -e "${RED}✗ User not found!${NC}"
    sleep 2
    menu-ssh
fi

# Get current expiry
current_exp=$(chage -l ${username} | grep "Account expires" | awk -F: '{print $2}' | xargs)

echo ""
echo -e "${YELLOW}Current expiry: ${GREEN}${current_exp}${NC}"
echo ""

echo -ne "${YELLOW}Add days: ${NC}"
read -r days

# Calculate new expiry
new_exp_date=$(date -d "+${days} days" +"%Y-%m-%d")

# Update user expiry
chage -E ${new_exp_date} ${username}

# Update config file
sed -i "s/Expired:.*/Expired: ${new_exp_date}/" /etc/nexus/ssh/${username}.conf

echo ""
echo -e "${GREEN}✓ Account extended successfully!${NC}"
echo -e "${YELLOW}New expiry date: ${GREEN}${new_exp_date}${NC}"
sleep 2
menu-ssh
