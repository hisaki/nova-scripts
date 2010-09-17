#!/bin/bash

. me/novarc

LOOPBACK_MOUNT=`sudo losetup --show --find /volumes/fake.0`
NOVA_VOLUME_ARGS="--storage_dev=${LOOPBACK_MOUNT}"

echo ${NOVA_VOLUME_ARGS}

bin/nova-volume ${NOVA_VOLUME_ARGS} --nodaemon --verbose start
