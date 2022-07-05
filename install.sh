#!/bin/bash

path=$(find $PWD -name 'mqtt_bash_service.sh')

test -f $path
if [ $? -ne 0 ];then
    (>&2 echo "Error: unable to find main script mqtt_bash_service.sh")
    exit
fi

test -f /etc/systemd/system/mqtt_bash_service.service
if [ $? -ne 0 ];then
    cat <<EOF > /etc/systemd/system/mqtt_bash_service.service
[Unit]
Description=Mqtt Bash Service

[Service]
ExecStart=$path
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target

EOF
fi
systemctl daemon-reload
test -f /etc/mqtt_bash_service/mqtt_bash_service.conf && exit
mkdir -p /etc/mqtt_bash_service
cat <<EOF > /etc/mqtt_bash_service/mqtt_bash_service.conf
mqtt_bash_service_broker=localhost
mqtt_bash_service_broker_port=1883
mqtt_bash_service_user=
mqtt_bash_service_password=
mqtt_bash_service_qos=0
mqtt_bash_service_topic=
mqtt_bash_service_log_file=
EOF
