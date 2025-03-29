#!/bin/bash
while getopts c:s: flag
do
    case "${flag}" in
        c) iplist=${OPTARG};;
        s) sortFlag=${OPTARG};;
        t) timeout=${OPTARG};;
        dev) url="https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/listtest.txt";;
    esac
done

if [ -z ${iplist+x} ]
    then
        iplist=""
fi

if [ -z ${sortFlag} ]
    then
        sortFlag="nr"
    else
        sortFlag="k"+$sortFlag
fi

if [ -z ${timeout} ]
    then
        timeout=1
fi

if [ -z ${dev} ]
    then
        url="https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/list.txt
fi

# Progress bar
bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=2
function show_progress {
    current="$1"
    total="$2"

    # calculate the progress in percentage
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # output the bar
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"

    if [ $total -eq $current ]; then
        echo -e "\nWaiting for responses..."
    fi
}

# Function to ping an IP and log the result
ping_ip() {
    local ip=$(echo $1 | cut -d "," -f 1 2>&1)
    local result
    result=$(ping -qc2 -W "$timeout" "$ip" | awk -F '/' 'END{ print (/^rtt/? $5:"FAIL") }')
    echo "$result ms, $1" >> output.txt
}

count=0
task_in_total=$(curl -s $url | awk -F ", " -v ipList=$iplist '$4 ~ ipList {print $0}' | wc -l)

while read output
do
    # Run ping in background
    ping_ip "$output" "$timeout" "$list" &
    count=$(echo "$count+1" | bc)
    show_progress $count $task_in_total
    if [ $count -ge $task_in_total ]; then
        wait -n  # Wait for any background job to complete
    fi
done < <((curl -s $url | awk -F ", " -v ipList=$iplist '$4 ~ ipList {print $0}'))


# Wait for remaining jobs to complete
wait

cat output.txt | sort -t , -$sortFlag
rm output.txt
