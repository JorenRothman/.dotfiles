#!/bin/bash

PREV="/tmp/cpu_prev"
HIST="/tmp/cpu_hist"
MAX=10  # 10 bars

# Read CPU totals
read -ra CPU < <(grep '^cpu ' /proc/stat)
unset CPU[0]  # remove "cpu" label

total=0
for v in "${CPU[@]}"; do total=$((total + v)); done
idle=$((CPU[3] + CPU[4]))  # idle + iowait

# First run
if [ ! -f "$PREV" ]; then
    echo "$total $idle 0" > "$PREV"
    echo "<span>▁▁▁▁▁▁▁▁▁▁ 0%</span>"
    exit
fi

# Read previous totals
read prev_total prev_idle prev_cpu < "$PREV"
diff_total=$((total - prev_total))
diff_idle=$((idle - prev_idle))

# Save current totals
echo "$total $idle $prev_cpu" > "$PREV"

# Avoid tiny diffs
if [ $diff_total -lt 50 ]; then
    cpu=$prev_cpu
else
    # Floating point calculation to avoid truncation errors
    cpu=$(awk -v t="$diff_total" -v i="$diff_idle" 'BEGIN { printf "%d", ((t - i) * 100 / t + 0.5) }')
fi

# Update history
read -ra hist <<< "$(cat "$HIST" 2>/dev/null)"
hist+=("$cpu")
while [ ${#hist[@]} -gt $MAX ]; do hist=("${hist[@]:1}"); done
printf "%s " "${hist[@]}" > "$HIST"

# Map history to bars
bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
graph=""
for v in "${hist[@]}"; do
    idx=$(( v / 12 ))
    (( idx > 7 )) && idx=7
    graph+="${bars[$idx]}"
done

# Output graph + percentage
echo "<span>${graph} ${cpu}%</span>"
