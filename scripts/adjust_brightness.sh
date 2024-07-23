#!/bin/bash

## This shell script uses xbacklight to adjust the brightness of the screen and send notifications using dunstify

COMMAND=$1


# Adjust the brightness and send the notification

if [ $COMMAND == "increase" ]; then
    xbacklight -inc 5
    CURRENT_BRIGHTNESS=$(xbacklight -get | awk '{print $1}')
    dunstify -a "Brightness" -u low -r 2221 -i preferences-system-brightness "" "Brightness: $CURRENT_BRIGHTNESS%" -t 3000
elif [ $COMMAND == "decrease" ]; then
    CURRENT_BRIGHTNESS=$(xbacklight -get | awk '{print $1}')
    if [ $CURRENT_BRIGHTNESS -gt 5 ]; then
        xbacklight -dec 5
        CURRENT_BRIGHTNESS=$(xbacklight -get | awk '{print $1}')
        dunstify -a "Brightness" -u low -r 2221 -i preferences-system-brightness "" "Brightness: $CURRENT_BRIGHTNESS%" -t 3000
    else
        dunstify -a "Brightness" -u low -r 2221 -i preferences-system-brightness "" "Brightness: $CURRENT_BRIGHTNESS%" -t 3000
    fi 
fi