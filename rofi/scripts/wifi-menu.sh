#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
# nmcli dev wifi rescan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dir=~/.config/rofi/styles

echo "dir: $dir"

FIELDS=SSID,SECURITY
POSITION=0
YOFF=0
XOFF=0
FONT="Iosevka Nerd Font 12"

LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

if [[ ! -z $CURRSSID ]]; then
	HIGHLINE=$(echo  "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc )
fi

# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt 8 ] && [[ "$CONSTATE" =~ "enabled" ]]; then
	LINENUM=8
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	LINENUM=1
fi

if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="Toggle Wi-fi off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="Toggle Wi-fi on"
fi

# Create a separator for the list using --
separator() {
    # Separator must have the same width as the box and is just a line of -
    for i in $(seq 1 $(expr $RWIDTH - 2)); do
        echo -n "-"
    done
}


# CHENTRY=$(echo -e "$TOGGLE\nManual Mode\n$LIST" | uniq -u | rofi -dmenu -no-config -theme $dir/wifi_menu.rasi -p "Wi-Fi Settings " -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH")
# Use separator between manual mode and the list
CHENTRY=$(echo -e "$TOGGLE\nManual Mode\n$(separator)\n$LIST" | uniq -u | rofi -dmenu -no-config -theme $dir/wifi_menu.rasi -p "Wi-Fi Settings " -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH")

#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
#echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "Manual Mode" ] ; then
	# Manual entry of the SSID and password (if appplicable)
	MSSID=$(echo "enter the SSID of the network (SSID,password)" | rofi -dmenu -no-config -theme $dir/wifi_menu.rasi -p "Manual Entry: " -font "$FONT" -lines 1)
	# Separating the password from the entered string
	MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

	#echo "$MSSID"
	#echo "$MPASS"

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		nmcli dev wifi con "$MSSID"
	else
		nmcli dev wifi con "$MSSID" password "$MPASS"
	fi

elif [ "$CHENTRY" = "Toggle Wi-fi on" ]; then
	nmcli radio wifi on

elif [ "$CHENTRY" = "Toggle Wi-fi off" ]; then
	nmcli radio wifi off

else

	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		nmcli con up "$CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASSPROMPT=$(echo "if connection is stored, hit enter" | rofi -dmenu -no-config -theme $dir/wifi_menu.rasi -p "password: " -lines 1 -font "$FONT" )

			# Read the entered password
			WIFIPASS=""

			# If the user hits enter, then the connection is attempted without a password
			echo "$WIFIPASSPROMPT" 
			echo "$CHSSID"
			if [ "$WIFIPASS" = "" ]; then
				nmcli dev wifi con "$CHSSID"
			fi
		fi
		# nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
		# Attempt to connect to wifi using the entered password, if fails then prompt the user for the password again
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
	fi

fi
