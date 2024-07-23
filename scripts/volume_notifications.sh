#!/bin/bash

# This shell scripts uses dunstify to notify changes in volume
# First, it parses the type of notification (increase, decrease, mute/unmute)
# Then, it gets the volume and sends the notification

# Parse the type of notification
NOTIFICATION_TYPE=$1

# Get the volume
VOLUME=$(pulsemixer --get-volume | awk '{print $1}')

# Send the notification
if [ $NOTIFICATION_TYPE == "increase" ]; then
    dunstify -a "Volume" -u low -r 2592 -i audio-volume-increase "" "Volume: $VOLUME%" -t 3000
elif [ $NOTIFICATION_TYPE == "decrease" ]; then
    if [ $VOLUME -gt 1 ]; then
        dunstify -a "Volume" -u low -r 2592 -i audio-volume-decrease "" "Volume: $VOLUME%" -t 3000
    else
        dunstify -a "volume" -u low -r 2591 -i audio-volume-muted "" "Audio muted!" -t 3000
    fi
elif [ $NOTIFICATION_TYPE == "mute" ]; then
    MUTE=$(pulsemixer --get-mute | awk '{print $1}')
    if [ $MUTE == "1" ]; then
        dunstify -a "volume" -u low -r 2591 -i audio-volume-muted "" "Audio muted!" -t 3000
    else
        dunstify -a "volume" -u low -r 2591 -i audio-volume-unmuted "" "Sound is back!" -t 3000
    fi
fi