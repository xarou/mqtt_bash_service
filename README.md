# mqtt_bash_service
a systemd service with a bash script running command based on mqtt topic

# Setup 
1 install mosquitto-clients (Debian like: apt install mosquitto-clients)
2 run install.sh (This will create the systemd service, and the configuration file /etc/mqtt_bash_service/mqtt_bash_service.conf)
3 edit configuration according to your needs 
4 systemctl start mqtt_bash_service

# Configuration

1 set the following variables according to your needs: 

mqtt_bash_service_broker=<BROKER_HOST>
mqtt_bash_service_broker_port=<BROKER_PORT>
mqtt_bash_service_user=<USER>
mqtt_bash_service_password=<PASSWORD>
mqtt_bash_service_qos=<0|1|2>
mqtt_bash_service_topic=<TOPIC>
mqtt_bash_service_log_file=<log_file>
mqtt_bash_service_action=<script or command to be run reciving messages as parameters> 
