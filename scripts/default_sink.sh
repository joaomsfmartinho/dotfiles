#!/bin/bash

# This script sets the default audio sink in PulseAudio depending if an
# external monitor is connected or not.

echo "Setting default audio sink..."

# Get the current connected monitors
MONITORS=$(xrandr -q | grep " connected" | cut -d ' ' -f1)

# Print monitors available
echo "Monitors available: $MONITORS"



# Check if the external monitor is connected
# If the length of MONITORS is greater than 1, then an external monitor is connected
if [ ${#MONITORS} -gt 6 ]; then
    # Get external monitor sink
    SINK=$(pactl list short sinks | grep "hdmi" | awk '{print $2}')

    # Print sink
    echo "Sink has changed: $SINK"

    # Set the default sink
    pactl set-default-sink $SINK
else
    # Get internal monitor sink
    SINK=$(pactl list short sinks | grep "analog" | awk '{print $2}')

    # Set the default sink
    pactl set-default-sink $SINK
fi