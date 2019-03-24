if [[ "$1" == "logs" ]] ; then
	followLogs
elif [[ "$1" == "stop" ]] ; then
	stopPrevious
	stop
elif [[ "$1" == "create" ]] ; then
	# stopPrevious
	stop
	sleep 2
	rmDocker
	createAndStartDocker
	followLogs
elif [[ "$1" == "startOnly" ]] ; then
	start
elif [[ "$1" == "start" ]] ; then
	stopPrevious
	start
else
	echo "Unknown command '$1'"
fi
