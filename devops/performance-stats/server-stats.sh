#! /bin/bash

# Total CPU usage
# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)
# Top 5 processes by CPU usage
# Top 5 processes by memory usage

while :
do
    clear
    echo "----------------------------------------"
    echo "System Performance Statistics"
    echo "----------------------------------------"
    echo ""
    
    # CPU usage
    echo "CPU Usage:"
    mpstat 1 1 | awk '/Average/ {print $3, $4, $5, $6, $7, $8, $9, $10}'
    echo "Total CPU usage: $(mpstat 1 1 | awk '/Average/ {print $3}')%"

    # Memory usage
    echo ""
    echo "Memory Usage:"
    free -h | awk '/Mem/ {print "Total: " $2 ", Used: " $3 ", Free: " $4 ", Buffers: " $6 ", Cache: " $7}'
    echo "Total Memory usage: $(free | awk '/Mem/ {printf "%.2f", $3/$2 * 100.0}')%"
    
    # Disk usage
    echo ""
    echo "Disk Usage:"
    df -h | awk '/^\/dev/ {print $1 ": " $3 "/" $2 ", Used: " $5}'
    
    # Top 5 processes by CPU usage
    echo ""
    echo "Top 5 Processes by CPU Usage:"
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    
    # Top 5 processes by memory usage
    echo ""
    echo "Top 5 Processes by Memory Usage:"
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
    
    sleep 5
done
