#!/bin/bash

echo "========================================="
echo "      SERVER PERFORMANCE STATISTICS"
echo "========================================="
echo

# -----------------------------
# OS Information
# -----------------------------
echo "OS Version:"
if [ -f /etc/os-release ]; then
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
else
    uname -a
fi
echo

# -----------------------------
# Uptime
# -----------------------------
echo "Uptime:"
uptime -p
echo

# -----------------------------
# Load Average
# -----------------------------
echo "Load Average:"
uptime | awk -F'load average:' '{print $2}'
echo

# -----------------------------
# CPU Usage
# -----------------------------
echo "Total CPU Usage:"

cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'%' -f1)
cpu_usage=$(awk "BEGIN {print 100 - $cpu_idle}")

printf "%.2f%%\n" "$cpu_usage"
echo

# -----------------------------
# Memory Usage
# -----------------------------
echo "Memory Usage:"

read total used free <<< $(free -m | awk '/Mem:/ {print $2, $3, $4}')

mem_percent=$(awk "BEGIN {printf \"%.2f\", ($used/$total)*100}")

echo "Total memory : ${total} MB "
echo "Total usage: ${used} MB"
echo "Usage: ${mem_percent}%"

echo "Disk usage: "

df -h / | awk '
NR==2 {
	print "Total disk : " $2
	print "Used disk : " $3
 	print "Usage : " $4 
}'
echo 
 
echo "Top 5 processes by CPU USAGE"
ps -eo pid,user,comm,%cpu --sort=-%cpu | head -6
echo

echo "Top 5 Processes by memory usage"
ps -eo pid,user,comm,%mem --sort=-%mem | head -6
echo

echo "Logged-in Users: "
who 
echo

if [ -f /var/log/auth.log ]; then
	echo "Failed Login Attemps:"
	grep "Failed password" /var/log/auth.log | tail -5
elif [ -f /var/log/secure ]; then
	echo "Failed Login Attemps:"
	grep "Failed password" /var/log/secure | tail -5
fi

echo 
echo "=========================================================================="
echo "              END OF REPORT "
echo "=========================================================================="

