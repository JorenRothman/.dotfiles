#!/bin/sh
# One snapshot of system stats for the bar's system menu, one "key values..." line each

for h in /sys/class/hwmon/hwmon*; do
    case "$(cat "$h/name")" in
        k10temp | coretemp) echo "cputemp $(cat "$h/temp1_input")" ;;
        # On Ryzen APUs the iGPU's PPT sensor reports the whole CPU socket, in µW
        amdgpu) [ "$(cat "$h/power1_label" 2>/dev/null)" = PPT ] && echo "cpupower $(cat "$h/power1_input")" ;;
    esac
done

echo "load $(cut -d' ' -f1-3 /proc/loadavg)"
echo "uptime $(cut -d' ' -f1 /proc/uptime)"
echo "cores $(nproc)"
echo "disk $(df -B1 --output=size,used / | tail -n1)"

if command -v nvidia-smi >/dev/null; then
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu,power.draw \
        --format=csv,noheader,nounits | head -n1 | tr -d ',' | sed 's/^/gpu /'
fi

ps -eo rss=,comm= | sed 's/^ */proc /'
