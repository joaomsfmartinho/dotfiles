#!/usr/bin/env bash

# Starts todoist-cli, syncs and shows the list of tasks

dir=~/.config/rofi/styles

FIELDS=ID,"DUE DATE",TASK
POSITION=0
YOFF=0
XOFF=0
FONT="Iosevka Nerd Font 12"

# Get the list of tasks
RES_CSV=$(todoist-cli --csv l -f "#Inbox")

# Parse the CSV, careful don't parse if between ""
RES=$(echo "$RES_CSV" | awk -F '",' '{gsub(/^"/, "", $1); gsub(/,"/, ",", $NF); print $1 "," $2 "," $3 "," $4 "," $5 "," $6}')


# Divide the list into an array of lines
IFS=$'\n' read -d '' -r -a TASKS <<< "$RES"

# Get the number of lines
NUMTASKS=${#TASKS[@]}

# If there is this string in any line "#Inbox,", remove
for i in "${!TASKS[@]}"; do
    TASKS[$i]=$(echo "${TASKS[$i]}" | sed 's/#Inbox,//g' | sed 's/,/ /4' | sed 's/,,/,/g'\
    | sed 's/\.,,,/./g' | sed 's/.",,,/./g')
done

# Print the tasks
# printf '%s\n' "${TASKS[@]}"

# Program rofi
