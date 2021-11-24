#!/bin/bash



mydomain="itthings.co.uk"
myhostname1="@"
myhostname2="www" 
myhostname3="www2"
myhostname4="AADTest"
myhostname5="test" 
myhostname6="test2"
myhostname7="flappybird"
gdapikey="key:secret"



myip=$(curl -s  'https://ifconfig.me/ip')
dnsdata=$(curl -s -X GET -H "Authorization: sso-key $gdapikey"  "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname")

gdip=$(echo $dnsdata | cut -d ',' -f 1 | tr -d '"' | cut -d ":" -f 2)

echo "`date '+%Y-%m-%d %H:%M:%S'` - Current External IP is $myip, GoDaddy $myhostname1 DNS IP is $gdip"

#echo "myip: " $myip
#echo "dnsdata: " $dnsdata
#echo "gdip: " $gdip


if [ "$gdip" != "$myip" -a "$myip" != "" ]; then
  echo "IP has changed!! Updating on GoDaddy"

  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname1" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger  -s  "Changed IP on $myhostname1.$mydomain from $gdip to $myip"


  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname2" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger -s  "Changed IP on $myhostname2$mydomain from $gdip to $myip"
 

 
  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname3" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger  -s  "Changed IP on $myhostname3.$mydomain from $gdip to $myip"



  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname4" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger  -s  "Changed IP on $myhostname4.$mydomain from $gdip to $myip"



  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname5" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger  -s "Changed IP on $myhostname5.$mydomain from $gdip to $myip"

  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname6" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger  -s "Changed IP on $myhostname6.$mydomain from $gdip to $myip"

  curl -s --insecure -X PUT "https://api.godaddy.com/v1/domains/$mydomain/records/A/$myhostname7" -H "Authorization: sso-key $gdapikey" -H "Content-Type: application/json" -d "[{\"data\": \"$myip\"}]"
  logger  -s "Changed IP on $myhostname7.$mydomain from $gdip to $myip"


fi