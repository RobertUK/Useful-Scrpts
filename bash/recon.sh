#!/bin/sh
#
# reconnect.sh v0.2 - Reconnect WAN, for Tomato firmwares
# @author: Walter Purcaro <vuolter@gmail.com>
#
###############################################################################

# Set to 1 if this script was put on its target machine, otherwise set it to 0 and configure all the following settings
ITSELF=1

# Target machine credentials
USERNAME=''
PASSWORD=''

# ...and lan hostname
HOSTNAME='192.168.0.1'

# ...and security id for http requests
# You can retrive it launching on target machine by terminal this command:
# nvram show | grep http_id | cut -d '=' -f 2
HTTPID=''

###############################################################################

if [ "$ITSELF" -ne 0 ]
then out="$(service wan restart >/dev/null 2>&1)"
else out="$(curl "http://$HOSTNAME/service.cgi" -u "$USERNAME:$PASSWORD" -d "_service=wan-restart&_sleep=5&_http_id=$HTTPID" --ssl 2>&1)"
fi

if [ "$?" -ne 0 ]
then err="$out"
else err="$(echo "$out" | grep -i 'err')"
fi

if [ -n "$err" ]
then
  logger -p user.err -s -t "reconnect.sh[$$]" "$err"
  exit 1
fi