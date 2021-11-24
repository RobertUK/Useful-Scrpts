
#!/bin/bash

port=80
reconnect=0


usage() { echo "Usage: $0 -p port_number [-r report only, no reconnect!]" 1>&2; exit 1; }

# Call getopt to validate the provided input. 
options=$(getopt -a -o rh --long p: -- "$@")
eval set -- "$options"
while true; do
    case "$1" in
    -r)
        reconnect=1
        ;;
    --p)
        shift; # The arg is next in position args
        port=$1
        ;;
    -h)
        usage
            ;;
    --)
        shift
        break
	;;
    esac
    shift
done



if [  $reconnect  -eq 1 ] 
then 
	logger -s -p user.notice -t check_port.sh "check_port.sh -p $port -r (will reconnect if bad)" 
else
	logger -s -p user.notice -t check_port.sh "check_port.sh -p $port (report only)"
fi

    IP_ADDRESS=$(curl  --max-time 15 ifconfig.me/ip -s)
    RESULT=$(curl --data "portNumber=$port&remoteAddress=$IP_ADDRESS"  -s  --max-time 30 --insecure https://ports.yougetsignal.com/check-port.php  |grep -i open -c -w )
        #echo $RESULT
    if [ $RESULT = 0 ]
    then
        logger -s -p user.notice -t check_port.sh "Current IP: $IP_ADDRESS Port $port is NOT open!"
       
        if [  $reconnect = 0 ]
	then	
		logger -s -p user.notice -t check_port.sh "Script finished!"
                exit 1
        else
                logger -s -p user.notice -t check_port.sh "Reconnecting...( $RESULT)"
		 sleep 2
		 /opt/recon.sh
		sleep 10
		logger -s -p user.notice -t check_port.sh "Rerun!!"
		logger -s -p user.notice -t check_port.sh $(curl --data "portNumber=$port&remoteAddress=$IP_ADDRESS"  -s  --max-time 30 --insecure https://ports.yougetsignal.com/check-port.php  |grep -i open -c -w )
		exit 1
        fi

    else
        logger -s -p user.notice -t check_port.sh "Current IP: $IP_ADDRESS Port $port IS open!"
        exit 1
    fi
