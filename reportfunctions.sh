#!/bin/bash
# prevents any direct execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This script is meant to be sourced not executed directly."
    exit 1
fi

# Error handling function
errormessage() {
    local msg="$1"
    echo "$msg" 1>&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $msg" >> /var/log/systeminfo.log
}

# CPU Report
# this function is used to generate a report about the cpu
cpureport() {
    echo "CPU Report"
    lscpu | egrep 'Model name|Architecture|CPU(s):|Max speed|Vendor ID|L1d cache|L1i cache|L2 cache|L3 cache'
}

# Computer Report
# this report is used to generate a report about the computer
computerreport() {
    echo "Computer Report"
    echo "Manufacturer: $(sudo dmidecode -s system-manufacturer)"
    echo "Model: $(sudo dmidecode -s system-product-name)"
    echo "Serial Number: $(sudo dmidecode -s system-serial-number)"
}

# OS Report
# this function is used to generate a report about the operating system
osreport() {
    echo "OS Report"
    echo "Distro: $(lsb_release -d | cut -f2)"
    echo "Version: $(lsb_release -r | cut -f2)"
    echo "Codename: $(lsb_release -c | cut -f2)"
}

# RAM Report
# this function is used to generate a report about RAM
ramreport() {
    echo "RAM Report"
    echo "Total Installed RAM: $(free -h | grep Mem | awk '{print $2}')"
    sudo dmidecode --type memory | grep -E 'Size:|Speed:|Manufacturer:|Part Number:' | grep -v 'No Module Installed'
}

# Video Report
# Function to generate a report about video card and chipset
videoreport() {
    echo "Video Report"
    lspci | grep VGA
}

# Disk Report
# this function is used to generate a report about disk drives
diskreport() {
    echo "Disk Report"
    lsblk -o NAME,SIZE,VENDOR,MODEL,MOUNTPOINT
    echo "Filesystem sizes and free space:"
    df -h | grep '^/dev'
}

# Network Report
# function used to generate a report about network interfaces
networkreport() {
    echo "Network Report"
    ip -br link
    echo "IP addresses:"
    ip -br addr
}

