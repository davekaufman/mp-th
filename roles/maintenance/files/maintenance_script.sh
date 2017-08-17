#!/bin/bash
# Description: unspecified maintenance task

# useful vars
dd_port=8125                              # dogstatsd port
dd_host=localhost                         # dogstatsd host
facility="local0.notice"                  # syslog facility / level
logfile="/var/log/maintenance_script.log" # logfile

# have we met before?
[[ -f "/tmp/maintenance-completed" ]] && echo "previously run successfully" && exit 0

# only one instance of this script may run at a time
exec 200<$0 && flock -en 200 || exit 200


# log start to syslog and file via logger
logger -p ${facility} -t maintenance_script "beginning run of maintenance script"  -s 2>${logfile}

# log start as datadog event
# viz. https://help.datadoghq.com/hc/en-us/articles/206441345-Send-metrics-and-events-using-dogstatsd-and-the-shell
event_title="maintenance script start"
event_text="$(hostname)"
echo "_e{${#event_title},${#event_text}}:${event_title}|${event_text}|#maintenance_script"  >/dev/udp/${dd_host}/${dd_port}

# first datadog metric 
echo -n "custom_metric_1:$RANDOM|g|#maintenance_script" >/dev/udp/${dd_host}/${dd_port}	

logger -p ${facility} -t maintenance_script "starting sleep in lieu of real maintenance tasks"  -s 2>${logfile}

# sleep here is standing in for whatever the unspecified long-running maintenance tasks are
sleep 2m || exit 1

# custom metrics 2 and 3 
echo -n "custom_metric_2:$RANDOM|g|#maintenance_script" >/dev/udp/${dd_host}/${dd_port}	
echo -n "custom_metric_3:$RANDOM|g|#maintenance_script" >/dev/udp/${dd_host}/${dd_port}	

# end
logger -p ${facility} -t maintenance_script "ending successful run of maintenance script"  -s 2>${logfile}

# log completion of script as datadog event
event_title="maintenance script end"
event_text="$(hostname)"
echo "_e{${#event_title},${#event_text}}:${event_title}|${event_text}|#maintenance_script"  >/dev/udp/${dd_host}/${dd_port}

# write sempahore for pseudo-idempotency
touch /tmp/maintenance_completed

