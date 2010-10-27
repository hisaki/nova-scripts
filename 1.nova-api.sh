#!/bin/bash

. me/novarc

CA_DIR=/home/ohara/Projects/OpenStack/nova/trunk/CA
KEYS_PATH=/home/ohara/Projects/OpenStack/nova/data/keys
LOGFILE=LOG_nova-api_`date +%m%d-%H%M`

#NETWORK_ARGS="--flat_network=true --flat_network_gateway=192.168.1.1 --flat_network_netmask=255.255.255.0 --flat_network_network=192.168.1.0 --flat_network_ips=192.168.1.220,192.168.1.221,192.168.1.222 --flat_network_bridge=br0 --flat_network_broadcast=192.168.1.255"
NOVA_API_ARGS="--ca_path=${CA_DIR} --keys_path=${KEYS_PATH} ${NETWORK_ARGS}"

echo ${NOVA_API_ARGS} > ${LOGFILE}

bin/nova-api --FAKE_subdomain=ec2 ${NOVA_API_ARGS} --nodaemon --verbose start 2>&1 |tee -a ${LOGFILE}
#bin/nova-api ${NOVA_API_ARGS} --nodaemon --verbose start 2>&1 |tee -a ${LOGFILE}
