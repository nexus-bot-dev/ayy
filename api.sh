#!/bin/bash

# Nexus Tunnel API Handler
# HTTP API untuk integrasi dengan web panel

API_KEY=$(cat /etc/nexus/api-key.txt)
LOG_FILE="/var/log/nexus/api.log"

# Fungsi logging
log_api() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> ${LOG_FILE}
}

# Fungsi validasi API key
validate_api_key() {
    local provided_key=$1
    if [[ "${provided_key}" != "${API_KEY}" ]]; then
        echo '{"status":"error","message":"Invalid API key"}'
        log_api "UNAUTHORIZED: Invalid API key attempt"
        exit 1
    fi
}

# Fungsi response JSON
json_response() {
    local status=$1
    local message=$2
    local data=$3
    
    if [[ -z "$data" ]]; then
        echo "{\"status\":\"${status}\",\"message\":\"${message}\"}"
    else
        echo "{\"status\":\"${status}\",\"message\":\"${message}\",\"data\":${data}}"
    fi
}

# API: Create SSH Account
api_create_ssh() {
    local username=$1
    local password=$2
    local days=$3
    
    # Validasi input
    if [[ -z "$username" || -z "$password" || -z "$days" ]]; then
        json_response "error" "Missing required parameters"
        return
    fi
    
    # Cek user exists
    if id "$username" &>/dev/null; then
        json_response "error" "User already exists"
        return
    fi
    
    # Buat user
    exp_date=$(date -d "+${days} days" +"%Y-%m-%d")
    useradd -M -N -s /bin/false -e ${exp_date} ${username}
    echo "${username}:${password}" | chpasswd
    
    # Simpan info
    mkdir -p /etc/nexus/ssh
    cat > /etc/nexus/ssh/${username}.conf <<EOF
Username: ${username}
Password: ${password}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF
    
    log_api "SSH account created: ${username}"
    
    data="{\"username\":\"${username}\",\"password\":\"${password}\",\"expired\":\"${exp_date}\"}"
    json_response "success" "SSH account created successfully" "${data}"
}

# API: Create VMess Account
api_create_vmess() {
    local username=$1
    local days=$2
    
    if [[ -z "$username" || -z "$days" ]]; then
        json_response "error" "Missing required parameters"
        return
    fi
    
    if [[ -f /etc/nexus/vmess/${username}.conf ]]; then
        json_response "error" "User already exists"
        return
    fi
    
    uuid=$(cat /proc/sys/kernel/random/uuid)
    exp_date=$(date -d "+${days} days" +"%Y-%m-%d")
    domain=$(cat /etc/nexus/domain)
    
    # Update Xray config
    cat /usr/local/etc/xray/config.json | jq ".inbounds[0].settings.clients += [{\"id\": \"${uuid}\", \"email\": \"${username}\"}]" > /tmp/xray_config.tmp
    mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json
    systemctl restart xray
    
    # Simpan info
    mkdir -p /etc/nexus/vmess
    cat > /etc/nexus/vmess/${username}.conf <<EOF
Username: ${username}
UUID: ${uuid}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF
    
    # Generate link
    vmess_json="{\"v\":\"2\",\"ps\":\"${username}\",\"add\":\"${domain}\",\"port\":\"443\",\"id\":\"${uuid}\",\"aid\":\"0\",\"net\":\"ws\",\"path\":\"/vmess\",\"type\":\"none\",\"host\":\"${domain}\",\"tls\":\"tls\"}"
    vmess_link="vmess://$(echo -n ${vmess_json} | base64 -w 0)"
    
    log_api "VMess account created: ${username}"
    
    data="{\"username\":\"${username}\",\"uuid\":\"${uuid}\",\"expired\":\"${exp_date}\",\"link\":\"${vmess_link}\"}"
    json_response "success" "VMess account created successfully" "${data}"
}

# API: Create VLess Account
api_create_vless() {
    local username=$1
    local days=$2
    
    if [[ -z "$username" || -z "$days" ]]; then
        json_response "error" "Missing required parameters"
        return
    fi
    
    if [[ -f /etc/nexus/vless/${username}.conf ]]; then
        json_response "error" "User already exists"
        return
    fi
    
    uuid=$(cat /proc/sys/kernel/random/uuid)
    exp_date=$(date -d "+${days} days" +"%Y-%m-%d")
    domain=$(cat /etc/nexus/domain)
    
    # Update Xray config
    cat /usr/local/etc/xray/config.json | jq ".inbounds[1].settings.clients += [{\"id\": \"${uuid}\", \"email\": \"${username}\"}]" > /tmp/xray_config.tmp
    mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json
    systemctl restart xray
    
    # Simpan info
    mkdir -p /etc/nexus/vless
    cat > /etc/nexus/vless/${username}.conf <<EOF
Username: ${username}
UUID: ${uuid}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF
    
    # Generate link
    vless_link="vless://${uuid}@${domain}:8443?path=/vless&security=tls&encryption=none&type=ws&host=${domain}#${username}"
    
    log_api "VLess account created: ${username}"
    
    data="{\"username\":\"${username}\",\"uuid\":\"${uuid}\",\"expired\":\"${exp_date}\",\"link\":\"${vless_link}\"}"
    json_response "success" "VLess account created successfully" "${data}"
}

# API: Create Trojan Account
api_create_trojan() {
    local username=$1
    local days=$2
    
    if [[ -z "$username" || -z "$days" ]]; then
        json_response "error" "Missing required parameters"
        return
    fi
    
    if [[ -f /etc/nexus/trojan/${username}.conf ]]; then
        json_response "error" "User already exists"
        return
    fi
    
    uuid=$(cat /proc/sys/kernel/random/uuid)
    exp_date=$(date -d "+${days} days" +"%Y-%m-%d")
    domain=$(cat /etc/nexus/domain)
    
    # Update Xray config
    cat /usr/local/etc/xray/config.json | jq ".inbounds[2].settings.clients += [{\"password\": \"${uuid}\", \"email\": \"${username}\"}]" > /tmp/xray_config.tmp
    mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json
    systemctl restart xray
    
    # Simpan info
    mkdir -p /etc/nexus/trojan
    cat > /etc/nexus/trojan/${username}.conf <<EOF
Username: ${username}
Password: ${uuid}
Created: $(date +"%Y-%m-%d %H:%M:%S")
Expired: ${exp_date}
EOF
    
    # Generate link
    trojan_link="trojan://${uuid}@${domain}:9443?path=/trojan&security=tls&type=ws&host=${domain}#${username}"
    
    log_api "Trojan account created: ${username}"
    
    data="{\"username\":\"${username}\",\"password\":\"${uuid}\",\"expired\":\"${exp_date}\",\"link\":\"${trojan_link}\"}"
    json_response "success" "Trojan account created successfully" "${data}"
}

# API: Delete SSH Account
api_delete_ssh() {
    local username=$1
    
    if [[ -z "$username" ]]; then
        json_response "error" "Username required"
        return
    fi
    
    if ! id "$username" &>/dev/null; then
        json_response "error" "User not found"
        return
    fi
    
    pkill -u ${username}
    userdel -r ${username} 2>/dev/null
    rm -f /etc/nexus/ssh/${username}.conf
    
    log_api "SSH account deleted: ${username}"
    json_response "success" "SSH account deleted successfully"
}

# API: Delete VMess Account
api_delete_vmess() {
    local username=$1
    
    if [[ -z "$username" ]]; then
        json_response "error" "Username required"
        return
    fi
    
    if [[ ! -f /etc/nexus/vmess/${username}.conf ]]; then
        json_response "error" "User not found"
        return
    fi
    
    uuid=$(grep "UUID:" /etc/nexus/vmess/${username}.conf | awk '{print $2}')
    
    # Remove from Xray config
    cat /usr/local/etc/xray/config.json | jq "del(.inbounds[0].settings.clients[] | select(.email==\"${username}\"))" > /tmp/xray_config.tmp
    mv /tmp/xray_config.tmp /usr/local/etc/xray/config.json
    systemctl restart xray
    
    rm -f /etc/nexus/vmess/${username}.conf
    rm -f /etc/nexus/vmess/${username}.txt
    
    log_api "VMess account deleted: ${username}"
    json_response "success" "VMess account deleted successfully"
}

# API: List SSH Accounts
api_list_ssh() {
    accounts="["
    first=true
    
    for user in $(awk -F: '$3 >= 1000 && $3 < 65534 {print $1}' /etc/passwd); do
        if [[ -f /etc/nexus/ssh/${user}.conf ]]; then
            if [[ "$first" == false ]]; then
                accounts+=","
            fi
            
            created=$(grep "Created:" /etc/nexus/ssh/${user}.conf | cut -d' ' -f2-)
            expired=$(grep "Expired:" /etc/nexus/ssh/${user}.conf | awk '{print $2}')
            
            accounts+="{\"username\":\"${user}\",\"created\":\"${created}\",\"expired\":\"${expired}\"}"
            first=false
        fi
    done
    
    accounts+="]"
    
    json_response "success" "SSH accounts retrieved" "${accounts}"
}

# API: List VMess Accounts
api_list_vmess() {
    accounts="["
    first=true
    
    for conf in /etc/nexus/vmess/*.conf; do
        if [[ -f "$conf" ]]; then
            if [[ "$first" == false ]]; then
                accounts+=","
            fi
            
            username=$(grep "Username:" ${conf} | awk '{print $2}')
            uuid=$(grep "UUID:" ${conf} | awk '{print $2}')
            created=$(grep "Created:" ${conf} | cut -d' ' -f2-)
            expired=$(grep "Expired:" ${conf} | awk '{print $2}')
            
            accounts+="{\"username\":\"${username}\",\"uuid\":\"${uuid}\",\"created\":\"${created}\",\"expired\":\"${expired}\"}"
            first=false
        fi
    done
    
    accounts+="]"
    
    json_response "success" "VMess accounts retrieved" "${accounts}"
}

# Main API handler
main() {
    # Parse request
    read -r method path protocol
    
    # Read headers
    declare -A headers
    while read -r line; do
        line=$(echo "$line" | tr -d '\r\n')
        [[ -z "$line" ]] && break
        
        key=$(echo "$line" | cut -d: -f1)
        value=$(echo "$line" | cut -d: -f2- | sed 's/^ *//')
        headers["$key"]="$value"
    done
    
    # Validate API key
    api_key_header="${headers[X-API-Key]}"
    validate_api_key "$api_key_header"
    
    # Read body untuk POST
    if [[ "$method" == "POST" ]]; then
        content_length="${headers[Content-Length]}"
        if [[ -n "$content_length" ]]; then
            read -r -n "$content_length" body
        fi
    fi
    
    # Response headers
    echo "HTTP/1.1 200 OK"
    echo "Content-Type: application/json"
    echo "Access-Control-Allow-Origin: *"
    echo ""
    
    # Route handling
    case "$path" in
        "/api/ssh/create")
            username=$(echo "$body" | jq -r '.username')
            password=$(echo "$body" | jq -r '.password')
            days=$(echo "$body" | jq -r '.expired')
            api_create_ssh "$username" "$password" "$days"
            ;;
        "/api/vmess/create")
            username=$(echo "$body" | jq -r '.username')
            days=$(echo "$body" | jq -r '.expired')
            api_create_vmess "$username" "$days"
            ;;
        "/api/vless/create")
            username=$(echo "$body" | jq -r '.username')
            days=$(echo "$body" | jq -r '.expired')
            api_create_vless "$username" "$days"
            ;;
        "/api/trojan/create")
            username=$(echo "$body" | jq -r '.username')
            days=$(echo "$body" | jq -r '.expired')
            api_create_trojan "$username" "$days"
            ;;
        "/api/ssh/delete")
            username=$(echo "$body" | jq -r '.username')
            api_delete_ssh "$username"
            ;;
        "/api/vmess/delete")
            username=$(echo "$body" | jq -r '.username')
            api_delete_vmess "$username"
            ;;
        "/api/ssh/list")
            api_list_ssh
            ;;
        "/api/vmess/list")
            api_list_vmess
            ;;
        *)
            json_response "error" "Endpoint not found"
            ;;
    esac
}

# Run main handler
main
