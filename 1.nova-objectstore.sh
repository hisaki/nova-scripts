#!/bin/bash

. me/novarc

CA_DIR=/home/ohara/Projects/OpenStack/nova/trunk/CA
KEYS_PATH=/home/ohara/Projects/OpenStack/nova/data/keys
IMAGES_PATH=/home/ohara/Projects/OpenStack/nova/data/images
BUCKETS_PATH=/home/ohara/Projects/OpenStack/nova/data/buckets
LOGFILE=LOG_nova-objectstore_`date +%m%d-%H%M`

MYSQL_PASS=nova
SQL_CONN=mysql://root:${MYSQL_PASS}@localhost/nova

#NETWORK_ARGS="--flat_network=true --flat_network_gateway=192.168.1.1 --flat_network_netmask=255.255.255.0 --flat_network_network=192.168.1.0 --flat_network_ips=192.168.1.220,192.168.1.221,192.168.1.222 --flat_network_bridge=br0 --flat_network_broadcast=192.168.1.255"
NOVA_OBJECTSTORE_ARGS="--ca_path=${CA_DIR} --keys_path=${KEYS_PATH} ${NETWORK_ARGS} --images_path=${IMAGES_PATH} --buckets_path=${BUCKETS_PATH} --sql_connection=${SQL_CONN}"
#NOVA_OBJECTSTORE_ARGS="--ca_path=${CA_DIR} --keys_path=${KEYS_PATH} ${NETWORK_ARGS} --images_path=${IMAGES_PATH} --buckets_path=${BUCKETS_PATH}"

echo ${NOVA_OBJECTSTORE_ARGS} > ${LOGFILE}

bin/nova-objectstore ${NOVA_OBJECTSTORE_ARGS} --nodaemon --verbose start 2>&1 |tee -a ${LOGFILE}
