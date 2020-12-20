#! /usr/local/bin/bash

# BTWiFi Logon Script Copyright (C) 2020 Robert Murphy
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# See http://www.gnu.org/licenses/ for the full text of the GNU
# General Public License.

#By default the script will run 10 times with a 5 second sleep between iterations. This is useful if you want
#to schedule the script via cron to run every minute and you are finding that you are disconnected in less than a minute and
#are a little impatient :) 

username="username@btinternet.com"
password="password"
actionUrl="https://www.btwifi.com:8443/tbbLogon"
queryUrl="https://www.btwifi.com:8443/home"
scriptVersion="0.5"
iterations="5"
DBG=true


i="0"


$DBG && echo && logger "BT WiFi Connect. Script ver: $scriptVersion" 


IS_LOGGED_IN=$(curl $queryUrl --max-time 8 2>/dev/null | grep "accountLogoff")
MAYBE_LOGGED_IN=$(curl $queryUrl --max-time 8 2>/dev/null | grep "You may have lost your connection to the BTWiFi signal.")

while [ $i -lt $iterations ]
do
	$DBG && echo && logger "Iteration: $i"

	if [ "$IS_LOGGED_IN" ]
	then
		[[ $DBG ]] && echo && logger "BT: Already logged in. Nothing to do."
	else
  
	[[ $DBG ]] && echo && logger "BT: Not logged in. Attempting to login..."

	
	OUT=$(curl -v --insecure --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36" --data-raw "password=$password&username=$username&xhtmlLogon=https://www.btwifi.com:8443/tbbLogon" "https://www.btwifi.com:8443/tbbLogon")
	
	LOGON_SUCCESS=$(curl "https://www.btwifi.com:8443/home" --max-time 15 2>/dev/null | grep "accountLogoff")
	if [ "$LOGON_SUCCESS" ]
	then
		$DBG && echo && logger "BT: You're online!"
	else
		$DBG && echo && logger "BT: Failed to login."
	fi
fi

i=$[$i+1]

$DBG && logger -t "Sleeping for 5s.."

sleep 5

done


