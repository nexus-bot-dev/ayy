#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Cek expired license
check_exp() {
    MYIP=$(curl -s https://api.ipify.org)
    wget -q -O /tmp/izin.txt "https://raw.githubusercontent.com/yourusername/nexus-tunnel/main/izin.txt"
    
    if grep -q "### ${MYIP}" /tmp/izin.txt; then
        LICENSE_INFO=$(grep "### ${MYIP}" /tmp/izin.txt)
        EXPIRY=$(echo ${LICENSE_INFO} | awk '{print $3}')
        TELE_USER=$(echo ${LICENSE_INFO} | awk '{print $4}')
        
        # Hitung sisa hari
        EXP_DATE=$(date -d "${EXPIRY}" +%s)
        TODAY=$(date +%s)
        DAYS_LEFT=$(( ($EXP_DATE - $TODAY) / 86400 ))
        
        echo "${DAYS_LEFT}" > /etc/nexus/exp-days.txt
        echo "${TELE_USER}" > /etc/nexus/tele-user.txt
    fi
    
    rm -f /tmp/izin.txt
}

# System info
get_info() {
    DOMAIN=$(cat /etc/nexus/domain 2>/dev/null || echo "Not Set")
    MYIP=$(curl -s https://api.ipify.org)
    CITY=$(curl -s https://ipapi.co/${MYIP}/city)
    DAYS_LEFT=$(cat /etc/nexus/exp-days.txt 2>/dev/null || echo "0")
    TELE_USER=$(cat /etc/nexus/tele-user.txt 2>/dev/null || echo "Unknown")
    
    # Hitung total users
    SSH_TOTAL=$(grep -c "^" /etc/passwd 2>/dev/null | awk '{print $1-20}')
    VMESS_TOTAL=$(ls -1 /etc/nexus/vmess/ 2>/dev/null | wc -l)
    VLESS_TOTAL=$(ls -1 /etc/nexus/vless/ 2>/dev/null | wc -l)
    TROJAN_TOTAL=$(ls -1 /etc/nexus/trojan/ 2>/dev/null | wc -l)
    
    # CPU & RAM
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    RAM_USAGE=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
    UPTIME=$(uptime -p | sed 's/up //')
}

# Main menu display
show_menu() {
    clear
    check_exp
    get_info
    
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███╗   ██╗        ║
║   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║████╗  ██║        ║
║   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║██╔██╗ ██║        ║
║   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║██║╚██╗██║        ║
║   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝██║ ╚████║        ║
║   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝        ║
║                                                           ║
║              Premium Tunneling System v1.0                ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}                    ${GREEN}SYSTEM INFORMATION${NC}                    ${BLUE}║${NC}"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}Domain     ${NC}: ${GREEN}${DOMAIN}${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}IP Address ${NC}: ${GREEN}${MYIP}${NC} (${CITY})"
    echo -e "${BLUE}║${NC}  ${YELLOW}Owner      ${NC}: ${GREEN}${TELE_USER}${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}Expired    ${NC}: ${GREEN}${DAYS_LEFT} Days${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}CPU Usage  ${NC}: ${GREEN}${CPU_USAGE}%${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}RAM Usage  ${NC}: ${GREEN}${RAM_USAGE}%${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}Uptime     ${NC}: ${GREEN}${UPTIME}${NC}"
    echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${BLUE}║${NC}  ${YELLOW}SSH Users  ${NC}: ${GREEN}${SSH_TOTAL}${NC} accounts"
    echo -e "${BLUE}║${NC}  ${YELLOW}VMess      ${NC}: ${GREEN}${VMESS_TOTAL}${NC} accounts"
    echo -e "${BLUE}║${NC}  ${YELLOW}VLess      ${NC}: ${GREEN}${VLESS_TOTAL}${NC} accounts"
    echo -e "${BLUE}║${NC}  ${YELLOW}Trojan     ${NC}: ${GREEN}${TROJAN_TOTAL}${NC} accounts"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                       ${PURPLE}MAIN MENU${NC}                          ${CYAN}║${NC}"
    echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} SSH Menu        ${GREEN}[6]${NC}  System Menu               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} VMess Menu      ${GREEN}[7]${NC}  Change Domain             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} VLess Menu      ${GREEN}[8]${NC}  Renew SSL Certificate     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} Trojan Menu     ${GREEN}[9]${NC}  Backup & Restore          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} Check Service   ${GREEN}[0]${NC}  Exit                      ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -ne "${YELLOW}Select menu ${NC}[${GREEN}1-9${NC}]${YELLOW}: ${NC}"
    read -r menu
    
    case $menu in
        1) menu-ssh ;;
        2) menu-vmess ;;
        3) menu-vless ;;
        4) menu-trojan ;;
        5) check-service ;;
        6) menu-system ;;
        7) change-domain ;;
        8) renew-ssl ;;
        9) backup-menu ;;
        0) exit 0 ;;
        *) echo -e "${RED}Invalid option${NC}" ; sleep 1 ; menu ;;
    esac
}

# Check service status
check-service() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                    ${GREEN}SERVICE STATUS${NC}                        ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    services=("ssh" "dropbear" "xray" "nginx" "vnstat")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet $service; then
            status="${GREEN}● Running${NC}"
        else
            status="${RED}● Stopped${NC}"
        fi
        printf "  ${YELLOW}%-15s${NC} : %b\n" "$service" "$status"
    done
    
    echo ""
    echo -ne "${YELLOW}Press Enter to continue...${NC}"
    read
    menu
}

# Renew SSL
renew-ssl() {
    clear
    echo -e "${CYAN}Renewing SSL Certificate...${NC}"
    
    DOMAIN=$(cat /etc/nexus/domain)
    ~/.acme.sh/acme.sh --renew -d ${DOMAIN} --force --ecc
    ~/.acme.sh/acme.sh --installcert -d ${DOMAIN} --fullchainpath /etc/nexus/cert.crt --keypath /etc/nexus/cert.key --ecc
    
    systemctl restart xray
    systemctl restart nginx
    
    echo -e "${GREEN}✓ SSL Certificate renewed${NC}"
    sleep 2
    menu
}

# Backup menu
backup-menu() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                  ${GREEN}BACKUP & RESTORE${NC}                       ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}[1]${NC} Backup Data"
    echo -e "  ${GREEN}[2]${NC} Restore Data"
    echo -e "  ${GREEN}[0]${NC} Back to Menu"
    echo ""
    echo -ne "${YELLOW}Select option: ${NC}"
    read -r opt
    
    case $opt in
        1) backup-data ;;
        2) restore-data ;;
        0) menu ;;
        *) backup-menu ;;
    esac
}

backup-data() {
    clear
    echo -e "${CYAN}Creating backup...${NC}"
    
    BACKUP_FILE="/root/nexus-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf ${BACKUP_FILE} /etc/nexus /etc/passwd /etc/shadow /etc/group
    
    echo -e "${GREEN}✓ Backup created: ${BACKUP_FILE}${NC}"
    echo ""
    echo -ne "${YELLOW}Press Enter to continue...${NC}"
    read
    menu
}

restore-data() {
    clear
    echo -e "${CYAN}Restore from backup${NC}"
    echo ""
    
    ls -lh /root/nexus-backup-*.tar.gz 2>/dev/null || echo "No backup files found"
    echo ""
    
    echo -ne "${YELLOW}Enter backup file path: ${NC}"
    read -r BACKUP_FILE
    
    if [[ -f "$BACKUP_FILE" ]]; then
        tar -xzf ${BACKUP_FILE} -C /
        echo -e "${GREEN}✓ Restore completed${NC}"
    else
        echo -e "${RED}File not found${NC}"
    fi
    
    sleep 2
    menu
}

# Run menu
show_menu
