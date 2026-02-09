#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                  ${GREEN}ALL SSH ACCOUNTS${NC}                       ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}NO  USERNAME          CREATED              EXPIRED       STATUS${NC}  ${BLUE}║${NC}"
echo -e "${BLUE}╠══════════════════════════════════════════════════════════════════════╣${NC}"

num=1
for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
    if [[ -f /etc/nexus/ssh/${user}.conf ]]; then
        created=$(grep "Created:" /etc/nexus/ssh/${user}.conf | cut -d' ' -f2-)
        expired=$(grep "Expired:" /etc/nexus/ssh/${user}.conf | awk '{print $2}')
        
        # Check if expired
        exp_timestamp=$(date -d "${expired}" +%s)
        now_timestamp=$(date +%s)
        
        if [[ ${now_timestamp} -gt ${exp_timestamp} ]]; then
            status="${RED}EXPIRED${NC}"
        else
            # Check if locked
            if passwd -S ${user} 2>/dev/null | grep -q "L"; then
                status="${YELLOW}LOCKED${NC}"
            else
                status="${GREEN}ACTIVE${NC}"
            fi
        fi
        
        printf "${BLUE}║${NC} ${GREEN}%-3s${NC} %-17s %-20s %-13s %b ${BLUE}║${NC}\n" "$num" "$user" "$created" "$expired" "$status"
        num=$((num+1))
    fi
done

echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

TOTAL=$(( num - 1 ))
echo -e "${YELLOW}Total SSH Accounts: ${GREEN}${TOTAL}${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu-ssh
