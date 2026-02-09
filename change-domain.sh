#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                   ${PURPLE}CHANGE DOMAIN${NC}                         ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

CURRENT_DOMAIN=$(cat /etc/nexus/domain)
echo -e "${YELLOW}Current domain: ${GREEN}${CURRENT_DOMAIN}${NC}"
echo ""

echo -ne "${YELLOW}Enter new domain: ${NC}"
read -r new_domain

if [[ -z "$new_domain" ]]; then
    echo -e "${RED}Domain cannot be empty!${NC}"
    sleep 2
    menu
fi

echo ""
echo -e "${CYAN}Updating domain configuration...${NC}"

# Update domain file
echo "$new_domain" > /etc/nexus/domain

# Update nginx config
sed -i "s/${CURRENT_DOMAIN}/${new_domain}/g" /etc/nginx/sites-available/nexus

# Renew SSL certificate
echo -e "${CYAN}Installing new SSL certificate...${NC}"
~/.acme.sh/acme.sh --issue -d ${new_domain} --standalone -k ec-256 --force
~/.acme.sh/acme.sh --installcert -d ${new_domain} --fullchainpath /etc/nexus/cert.crt --keypath /etc/nexus/cert.key --ecc

# Restart services
systemctl restart nginx
systemctl restart xray

echo ""
echo -e "${GREEN}✓ Domain updated successfully!${NC}"
echo -e "${GREEN}New domain: ${new_domain}${NC}"
echo ""
echo -ne "${YELLOW}Press Enter to continue...${NC}"
read
menu
