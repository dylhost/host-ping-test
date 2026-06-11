#!/bin/bash

temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT INT TERM

while getopts c:C:h:s:t:d flag; do
    case "${flag}" in
        c) country="${OPTARG}" ;;
        C) city="${OPTARG}" ;;
        h) host="${OPTARG}" ;;
        s) sortFlag="${OPTARG}" ;;
        t) timeout="${OPTARG}" ;;
        d) nextarg="${!OPTIND}"
            [[ -n "$nextarg" && "$nextarg" != -* ]] && { url="$nextarg"; ((OPTIND++)); } || url="https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/listtest";;
    esac
done

# Default settings
country="${country:-}"
city="${city:-}"
host="${host:-}"
timeout="${timeout:-1}"
url="${url:-https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/list.txt}"
[[ -z "${sortFlag:-}" ]] && sortFlag="nr" || sortFlag="k$sortFlag"

# Progress bar settings
bar_size=40

# Function to print a progress bar
show_progress() {
    local current="$1" total="$2"
    
    # Use native bash math for integers; use awk for the 2-decimal percentage
    local percent=$(awk "BEGIN {printf \"%.2f\", 100 * $current / $total}")
    local done=$(( bar_size * current / total ))
    local todo=$(( bar_size - done ))
    
    local done_sub_bar=$(printf "%${done}s" | tr " " "#")
    local todo_sub_bar=$(printf "%${todo}s" | tr " " "-")
    
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"
    [ "$total" -eq "$current" ] && echo -e "\nWaiting for responses..."
}

# Function to ping an IP and log the result
ping_ip() {
    local ip="${1%%,*}" # Native Bash string manipulation (replaces echo + cut)
    local result=$(ping -qc2 -W "$timeout" "$ip" | awk -F '/' 'END{ print (/^r/? $5:"FAIL") }')
    echo "$result ms, $1" >> "$temp_file"
}

mapfile -t targets < <(curl -s "$url" | awk -F ", " -v c="$country" -v C="$city" -v h="$host" '$4 ~ c && $3 ~ C && $2 ~ h') # Fetch targets & filter

task_in_total="${#targets[@]}"
count=0

[[ $task_in_total -eq 0 ]] && { echo "No targets matched the provided filters."; exit 0; } # Prevent division by zero errors if filters match nothing

# Multi-thread pings iterating through our array
for output in "${targets[@]}"; do 
    ping_ip "$output" &
    ((count++))
    show_progress "$count" "$task_in_total"
    [ "$count" -ge "$task_in_total" ] && wait -n
done

wait # Wait for remaining jobs to complete
sort -t , -"$sortFlag" "$temp_file" # Sort output
