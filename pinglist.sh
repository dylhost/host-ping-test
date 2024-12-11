total=0
count=0
min=999
max=0
list=""
echo "Starting test, this may take a bit."
while read output
do
    ping=$(ping -4 -qc1 $(echo $output | cut -d ";" -f 1) 2>&1 | awk -F'/' 'END{ print (/^rtt/? $5:"FAIL") }')
    list="${list}\n${ping}ms ; ${output}"
    echo -n "."
    total=$(echo "$total+$ping" | bc)
    count=$(echo "$count+1" | bc)
    if (( $(echo "$ping" != "FAIL" | bc -l) ))
    then
        if (( $(echo "$ping < $min" | bc -l) ))
        then
            min=$ping
            mintxt="$output"
        fi
        if (( $(echo "$ping > $max" | bc -l) ))
        then
            max=$ping
            maxtxt="$output"
        fi
    fi
done < <((curl -s https://raw.githubusercontent.com/dylhost/host-ping-test/refs/heads/dev/list.txt| tail -n +4))

echo -e $list | sort -nr
echo "min/avg/max/total" $min"/"$(echo "$total/$count" | bc)""/""$max"/""$total"
echo "min provider: "$mintxt "("$min"ms)"
echo "max provider: "$maxtxt "("$max"ms)"
