#!/bin/bash

## params are checked in this order : Env, Config, command line argument

## init default variables
set -e 
debug=0
force=0
config_file='/etc/mqtt_bash_service/mqtt_bash_service.conf'


#loading config file if exists

until [ $# -eq 0 ];do
    case $1 in
	-b|--mqtt-broker) shift;p_broker=$1;;
	-p|--mqtt-broker-port) shift;p_broker_port=$1;;
	-t|--mqtt-topic) shift;p_topic=$1;;
	-u|--mqtt-user) shift;p_user=$1;;
	-p|--mqtt-password) shift;p_password=$1;;
	-q|--mqtt-qos) shift; p_qos=$1;;
	-c|--config) shift;config_file=$1;;
	-l|--log-file) shift;p_log_file=$1;;
	*) usage=1;; # not valid

    esac
    shift
done

test -f $config_file && source $config_file

function get_config {
    variable=$1
    mandatory=$2
    
    env_name="MQTT_BASH_SERVICE_${variable^^}"
    conf_name="mqtt_bash_service_${variable}"
    param_name="p_${variable}"

    test -z "${!env_name}"   || val=${!env_name}
    test -z "${!conf_name}"  || val=${!conf_name}
    test -z "${!param_name}" || val=${!param_name}
    if [[ ! -z "$mandatory" && "$mandatory" -eq 1 ]];then
	test -z $val       
	if [ $? -eq 0 ];then
	    (>&2 echo "Error : no $variable provided")
	    exit 1
	fi
    fi
    (>&2 echo "$variable = $val")
    echo $val
}



broker=$(get_config broker 1)
broker_port=$(get_config broker_port 1) 
topic=$(get_config topic 1)
user=$(get_config user 1)
password=$(get_config password 1)
qos=$(get_config qos 1)
log_file=$(get_config log_file 0)
action=$(get_config action 0)
echo "All params are ok"

function log_line {
    local line=$@

    if [ -z "$log_file" ];then
	return
    fi
    date=$(date +'%b %e %T')
    echo "$date $HOSTNAME mqtt_bash_service: $line" >> $log_file
}
mosquitto_sub -h $broker -t $topic -p $broker_port -u $user -P $password -q $qos | while read line;do

    if [ ! -z $action ];then
	log_line "$action $line"	    
	$action "$line"
    else
	log_line "NO ACTION $line"
    fi
done
