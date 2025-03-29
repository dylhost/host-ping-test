#!/bin/bash
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
        echo -e "\nDONE"
    fi
}

total=0
count=0
min=999
max=0
list=""
echo "Starting test, this may take a bit."
while getopts c:s: flag
do
    case "${flag}" in
        c) iplist=${OPTARG};;
        s) sortFlag=${OPTARG};;
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
task_in_total=$(curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/listtest | awk -F ", " -v ipList=$iplist '$4 == ipList {print $0}' | wc -l)

function ping() {
    local output=$output
    local ping=$(ping -4 -qc1 $(echo $output | cut -d "," -f 1) 2>&1 | awk -F'/' 'END{ print (/^rtt/? $5:"FAIL") }') 
    local list=$list
    local count=$count
    local total=$total
    local min=$min
    local mintxt=$mintxt
    local max=$max
    local maxtxt=$maxtxt
    echo $ping
    export list="${list}\n${ping}ms, ${output}"
    export count=$(echo "$count+1" | bc)
    export total=$(echo "$total+$ping" | bc)
    if (( $(echo "$ping" != "FAIL" | bc -l) ))
    then
        if (( $(echo "$ping < $min" | bc -l) ))
        then
            export min=$ping
            export mintxt="$output"
        fi
        if (( $(echo "$ping > $max" | bc -l) ))
        then
            export max=$ping
            export maxtxt="$output"
        fi
    fi    
    show_progress $count $task_in_total
}

export -f ping
export -f show_progress

while read output
do
    ping "$output" "$list" "$total" "$count" "$min" "$mintxt" "$max" "$maxtxt" "$task_in_total" &
    sleep 0.2s
done < <((curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/main/listtest | awk -F ", " -v ipList=$iplist '$4 == ipList {print $0}'))

echo -e $list | sort -t , -$sortFlag
echo "min/avg/max/total" $min"/"$(echo "$total/$count" | bc)""/""$max"/""$total"
echo "min provider: "$mintxt "("$min"ms)"
echo "max provider: "$maxtxt "("$max"ms)"
