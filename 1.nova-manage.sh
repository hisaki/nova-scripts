#!/bin/bash

OPENSTACK_USERNAME=ohara
OPENSTACK_PROJECTNAME=myproj
CA_DIR=/home/ohara/Projects/OpenStack/nova/trunk/CA
KEYS_PATH=/home/ohara/Projects/OpenStack/nova/data/keys

MYSQL_PASS=nova
SQL_CONN=mysql://root:${MYSQL_PASS}@localhost/nova


NOVA_MANAGE_ARGS="--ca_path=${CA_DIR} --credentials_template=nova/auth/novarc.template --keys_path=${KEYS_PATH} --vpn_client_template=nova/cloudpipe/client.ovpn.template --sql_connection=${SQL_CONN}"
#NOVA_MANAGE_ARGS="--ca_path=${CA_DIR} --credentials_template=nova/auth/novarc.template --keys_path=${KEYS_PATH} --vpn_client_template=nova/cloudpipe/client.ovpn.template"


bin/nova-manage ${NOVA_MANAGE_ARGS} user admin ${OPENSTACK_USERNAME}
bin/nova-manage ${NOVA_MANAGE_ARGS} project create ${OPENSTACK_PROJECTNAME} ${OPENSTACK_USERNAME}
bin/nova-manage ${NOVA_MANAGE_ARGS} network create 10.0.0.0/8 3 16

bin/nova-manage ${NOVA_MANAGE_ARGS} user list
bin/nova-manage ${NOVA_MANAGE_ARGS} project list

if [ -d me ]; then
  rm -rf me
fi
mkdir me
bin/nova-manage ${NOVA_MANAGE_ARGS} project zip ${OPENSTACK_PROJECTNAME} ${OPENSTACK_USERNAME} me/nova.zip
(cd me; unzip nova.zip)
