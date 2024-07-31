# if type "xrandr"; then
#     for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#         MONITOR=$m polybar top --reload --config=~/.config/polybar/config.ini &
#     done
# else
#     polybar polybar top --reload --config=~/.config/polybar/config.ini &
# fi

killall polybar

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar top --reload --config=~/.config/polybar/config.ini &
done
