#!/bin/bash
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT INT TERM
d_flag=false

while getopts c:C:h:s:t:d flag; do
    case "${flag}" in
        c) country="${OPTARG}" ;;
        C) city="${OPTARG}" ;;
        h) host="${OPTARG}" ;;
        s) sortFlag="${OPTARG}" ;;
        t) timeout="${OPTARG}" ;;
        d) d_flag=true
           nextarg="${!OPTIND}"
           [[ -n "$nextarg" && "$nextarg" != -* ]] && { url="$nextarg"; ((OPTIND++)); } || url="https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/listtest" ;;
    esac
done

country="${country:-}"
city="${city:-}"
host="${host:-}"
timeout="${timeout:-1}"
url="${url:-https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/list.txt}"
[[ -z "${sortFlag:-}" ]] && sortFlag="nr" || sortFlag="k$sortFlag"
bar_size=40

# Show progress bar
show_progress() {
    local percent=$(awk "BEGIN {printf \"%.2f\", 100 * $1 / $2}")
    local done=$(( bar_size * $1 / $2 ))
    local todo=$(( bar_size - done ))
    local done_bar=$(printf "%${done}s" | tr " " "#")
    local todo_bar=$(printf "%${todo}s" | tr " " "-")
    
    echo -ne "\rProgress : [${done_bar}${todo_bar}] ${percent}%"
    [ "$2" -eq "$1" ] && echo -e "\nWaiting for responses..."
}

# Ping a single IP
ping_ip() {
    local result=$(ping -qc2 -W "$timeout" "${1%%,*}" | awk -F '/' 'END{ print (/^r/? $5:"FAIL") }')
    echo "$result ms, $1" >> "$temp_file"
}

mapfile -t targets < <(curl -s "$url" | awk -F ", " -v c="$country" -v C="$city" -v h="$host" '$4 ~ c && $3 ~ C && $2 ~ h') # Map and sort targets
total="${#targets[@]}"
count=0
[[ $total -eq 0 ]] && { echo "No targets matched filters."; exit 0; }

# Loop through targets
for output in "${targets[@]}"; do 
    ping_ip "$output" &
    show_progress "$((++count))" "$total"
    [ "$count" -ge "$total" ] && wait -n
done

wait # Wait for curl commands to finish
sort -t , -"$sortFlag" "$temp_file" # Sort results

# Print copy-pastable valid addresses if -d (testing) flag is used, allowing for list to be maintained
[ "$d_flag" = true ] && { echo -e "\n--- Valid Addresses ---"; grep -v '^FAIL' "$temp_file" | sed 's/^[^,]*, //' | sort -t ',' -k 2,2b -k 4,4b -k 3,3b; }
