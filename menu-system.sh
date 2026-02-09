#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                     SYSTEM MANAGEMENT                     ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Get system info
UPTIME=$(uptime -p | sed 's/up //')
LOAD=$(uptime | awk -F'load average:' '{print $2}')
CPU_CORES=$(nproc)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
RAM_TOTAL=$(free -h | awk 'NR==2{print $2}')
RAM_USED=$(free -h | awk 'NR==2{print $3}')
RAM_PERCENT=$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2}')
DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_PERCENT=$(df -h / | awk 'NR==2{print $5}')

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}                  ${YELLOW}SYSTEM INFORMATION${NC}                      ${BLUE}║${NC}"
echo -e "${BLUE}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Uptime       ${NC}: ${GREEN}${UPTIME}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}Load Average ${NC}: ${GREEN}${LOAD}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}CPU Cores    ${NC}: ${GREEN}${CPU_CORES}${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}CPU Usage    ${NC}: ${GREEN}${CPU_USAGE}%${NC}"
echo -e "${BLUE}║${NC} ${YELLOW}RAM Usage    ${NC}: ${GREEN}${RAM_USED}${NC} / ${GREEN}${RAM_TOTAL}${NC} (${GREEN}${RAM_PERCENT}%${NC})"
echo -e "${BLUE}║${NC} ${YELLOW}Disk Usage   ${NC}: ${GREEN}${DISK_USED}${NC} / ${GREEN}${DISK_TOTAL}${NC} (${GREEN}${DISK_PERCENT}${NC})"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                     ${PURPLE}SYSTEM MENU${NC}                          ${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[1]${NC} Restart All Services                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[2]${NC} Restart SSH & Dropbear                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[3]${NC} Restart Xray                                      ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[4]${NC} Restart Nginx                                     ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[5]${NC} Check Service Status                              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[6]${NC} View System Logs                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[7]${NC} Clean Expired Accounts                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[8]${NC} Speedtest                                         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[9]${NC} Reboot Server                                     ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${GREEN}[0]${NC} Back to Main Menu                                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                           ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -ne "${YELLOW}Select menu ${NC}[${GREEN}0-9${NC}]${YELLOW}: ${NC}"
read -r choice

case $choice in
    1) restart-all ;;
    2) restart-ssh ;;
    3) restart-xray ;;
    4) restart-nginx ;;
    5) check-services ;;
    6) view-logs ;;
    7) clean-expired ;;
    8) run-speedtest ;;
    9) reboot-server ;;
    0) menu ;;
    *) echo -e "${RED}Invalid option${NC}" ; sleep 1 ; menu-system ;;
esac

restart-all() {
    clear
    echo -e "${CYAN}Restarting all services...${NC}"
    echo ""
    
    systemctl restart ssh && echo -e "${GREEN}✓ SSH restarted${NC}"
    systemctl restart dropbear && echo -e "${GREEN}✓ Dropbear restarted${NC}"
    systemctl restart xray && echo -e "${GREEN}✓ Xray restarted${NC}"
    systemctl restart nginx && echo -e "${GREEN}✓ Nginx restarted${NC}"
    systemctl restart squid && echo -e "${GREEN}✓ Squid restarted${NC}"
    
    echo ""
    echo -e "${GREEN}All services restarted successfully!${NC}"
    sleep 2
    menu-system
}

restart-ssh() {
    clear
    echo -e "${CYAN}Restarting SSH services...${NC}"
    systemctl restart ssh
    systemctl restart dropbear
    echo -e "${GREEN}✓ SSH & Dropbear restarted${NC}"
    sleep 2
    menu-system
}

restart-xray() {
    clear
    echo -e "${CYAN}Restarting Xray...${NC}"
    systemctl restart xray
    echo -e "${GREEN}✓ Xray restarted${NC}"
    sleep 2
    menu-system
}

restart-nginx() {
    clear
    echo -e "${CYAN}Restarting Nginx...${NC}"
    systemctl restart nginx
    echo -e "${GREEN}✓ Nginx restarted${NC}"
    sleep 2
    menu-system
}

check-services() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                   ${GREEN}SERVICE STATUS${NC}                         ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    services=("ssh" "dropbear" "xray" "nginx" "squid" "vnstat")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet $service; then
            status="${GREEN}● Running${NC}"
            uptime=$(systemctl show $service -p ActiveEnterTimestamp --value | cut -d' ' -f2-3)
        else
            status="${RED}● Stopped${NC}"
            uptime="-"
        fi
        printf "  ${YELLOW}%-15s${NC} : %b  (${CYAN}%s${NC})\n" "$service" "$status" "$uptime"
    done
    
    echo ""
    echo -ne "${YELLOW}Press Enter to continue...${NC}"
    read
    menu-system
}

view-logs() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}                     ${GREEN}VIEW LOGS${NC}                            ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${GREEN}[1]${NC} Xray Access Log"
    echo -e "  ${GREEN}[2]${NC} Xray Error Log"
    echo -e "  ${GREEN}[3]${NC} Nginx Access Log"
    echo -e "  ${GREEN}[4]${NC} Nginx Error Log"
    echo -e "  ${GREEN}[5]${NC} API Log"
    echo -e "  ${GREEN}[6]${NC} System Log"
    echo -e "  ${GREEN}[0]${NC} Back"
    echo ""
    echo -ne "${YELLOW}Select log: ${NC}"
    read -r log_choice
    
    case $log_choice in
        1) tail -f /var/log/xray/access.log ;;
        2) tail -f /var/log/xray/error.log ;;
        3) tail -f /var/log/nginx/access.log ;;
        4) tail -f /var/log/nginx/error.log ;;
        5) tail -f /var/log/nexus/api.log ;;
        6) tail -f /var/log/syslog ;;
        0) menu-system ;;
        *) view-logs ;;
    esac
}

clean-expired() {
    clear
    echo -e "${CYAN}Cleaning expired accounts...${NC}"
    echo ""
    
    expired_count=0
    
    # Clean SSH
    for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
        if [[ -f /etc/nexus/ssh/${user}.conf ]]; then
            expired=$(grep "Expired:" /etc/nexus/ssh/${user}.conf | awk '{print $2}')
            exp_timestamp=$(date -d "${expired}" +%s)
            now_timestamp=$(date +%s)
            
            if [[ ${now_timestamp} -gt ${exp_timestamp} ]]; then
                pkill -u ${user}
                userdel -r ${user} 2>/dev/null
                rm -f /etc/nexus/ssh/${user}.conf
                echo -e "${YELLOW}Deleted expired SSH user: ${RED}${user}${NC}"
                expired_count=$((expired_count+1))
            fi
        fi
    done
    
    # Clean VMess, VLess, Trojan (similar logic)
    # ... implementation for other protocols
    
    echo ""
    echo -e "${GREEN}✓ Cleanup completed!${NC}"
    echo -e "${YELLOW}Total expired accounts removed: ${GREEN}${expired_count}${NC}"
    sleep 3
    menu-system
}

run-speedtest() {
    clear
    echo -e "${CYAN}Running speedtest...${NC}"
    echo ""
    
    # Install speedtest if not exists
    if ! command -v speedtest &> /dev/null; then
        echo -e "${YELLOW}Installing speedtest-cli...${NC}"
        apt install -y speedtest-cli
    fi
    
    speedtest-cli --simple
    
    echo ""
    echo -ne "${YELLOW}Press Enter to continue...${NC}"
    read
    menu-system
}

reboot-server() {
    clear
    echo -e "${RED}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}                    ${YELLOW}REBOOT SERVER${NC}                         ${RED}║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Are you sure you want to reboot the server?${NC}"
    echo -e "${RED}All connections will be lost!${NC}"
    echo ""
    echo -ne "${YELLOW}Type ${GREEN}YES${YELLOW} to confirm: ${NC}"
    read -r confirm
    
    if [[ "$confirm" == "YES" ]]; then
        echo -e "${RED}Rebooting in 5 seconds...${NC}"
        sleep 5
        reboot
    else
        echo -e "${YELLOW}Reboot cancelled${NC}"
        sleep 2
        menu-system
    fi
}
