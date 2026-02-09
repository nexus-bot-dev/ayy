#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}              ${PURPLE}CHANGE DROPBEAR VERSION${NC}                   ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Tampilkan versi saat ini
CURRENT_VERSION=$(dropbear -V 2>&1 | head -n1)
echo -e "${YELLOW}Current version: ${GREEN}${CURRENT_VERSION}${NC}"
echo ""

echo -e "${YELLOW}Available versions:${NC}"
echo -e "  ${GREEN}[1]${NC} Dropbear 2022.83"
echo -e "  ${GREEN}[2]${NC} Dropbear 2020.81"
echo -e "  ${GREEN}[3]${NC} Dropbear 2019.78"
echo -e "  ${GREEN}[0]${NC} Cancel"
echo ""
echo -ne "${YELLOW}Select version: ${NC}"
read -r version

case $version in
    1) DROPBEAR_VERSION="2022.83" ;;
    2) DROPBEAR_VERSION="2020.81" ;;
    3) DROPBEAR_VERSION="2019.78" ;;
    0) menu-ssh ;;
    *) echo -e "${RED}Invalid option${NC}" ; sleep 1 ; change-dropbear ;;
esac

echo ""
echo -e "${CYAN}Installing Dropbear ${DROPBEAR_VERSION}...${NC}"

# Stop dropbear
systemctl stop dropbear

# Download and install
cd /tmp
wget -q https://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VERSION}.tar.bz2
tar -xjf dropbear-${DROPBEAR_VERSION}.tar.bz2
cd dropbear-${DROPBEAR_VERSION}

./configure
make && make install

# Restart dropbear
systemctl start dropbear

# Cleanup
cd /tmp
rm -rf dropbear-${DROPBEAR_VERSION}*

echo -e "${GREEN}✓ Dropbear ${DROPBEAR_VERSION} installed successfully!${NC}"
sleep 2
menu-ssh
