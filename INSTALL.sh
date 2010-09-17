#!/bin/bash

BASE_DIR=/home/ohara/Projects/OpenStack/nova
REDIS_DIR=$BASE_DIR/Redis
TEMP_DIR=$BASE_DIR/Temp
TODO_FILE=$BASE_DIR/README.todo
BZR_LOGIN=your-nick-name-at-launchpad

echo 'Assume that you already'
echo '   - Install git-core'
echo '   - Copy ~/.ssh/id_rsa.pub into launchpad'

echo -n 'Are you OK to proceed? [y/n] '
read ANS

if [ $ANS != 'y' ]; then
  echo 'Exit..'
  exit 0
fi

echo '== Install common packages and python libraries for nova =='
sudo apt-get install -y bzr unzip curl build-essential
sudo apt-get install -y aoetools vlan
sudo apt-get install -y python-m2crypto python-ipy python-twisted-bin python-twisted-core python-twisted-web python-carrot python-boto python-daemon python-setuptools python-libxml2 python-dev python-libvirt

sleep 2

echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+ Several manual installation required.. Just download packages under Temp'
echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
if [ -d $TEMP_DIR ]; then
  rm -rf $TEMP_DIR
fi

mkdir $TEMP_DIR
pushd $TEMP_DIR
echo 'python-redis'
git clone http://github.com/andymccurdy/redis-py.git
echo 'tornado-1.1'
wget http://github.com/downloads/facebook/tornado/tornado-1.1.tar.gz
echo 'gflags'
wget http://google-gflags.googlecode.com/files/gflags-1.3.tar.gz
echo 'python-gflags'
wget http://python-gflags.googlecode.com/files/python-gflags-1.3.tar.gz
popd

echo "- Manual Install for python-redis, tornado, gflags and python-gflags" >> $TODO_FILE
echo "  from $TEMP_DIR" >> $TODO_FILE

sleep 1

echo 'Check out bzr repository from launchpad'
pushd $BASE_DIR
#bzr whoami $BZR_MAIL
bzr lp-login $BZR_LOGIN
bzr branch lp:nova trunk
echo "- bzr whoami config" >> $TODO_FILE
popd

sleep 1
echo 'modprobe aoe'
sudo modprobe -v aoe

sleep 2
echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo '+ Common packages installation is finished'
echo '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'

function install_compute {
  echo 'Install Compute-Node'
  sudo apt-get install -y kpartx kvm libvirt-bin libvirt0
  sudo apt-get install -y bridge-utils
  sudo modprobe kvm
  echo "- Set up bridge" >> $TODO_FILE
}

function install_controller {
  echo 'Install Controller-Node'
  sudo apt-get install rabbitmq-server
  echo 'redis-server'
  mkdir -p $REDIS_DIR
  pushd $REDIS_DIR
  wget http://redis.googlecode.com/files/redis-2.0.1.tar.gz
  echo "- Manual install for redis-server from $REDIS_DIR" >> $TODO_FILE
  popd
}

echo
echo 'You want to install ether Everything[1], Compute-Node[2], Controller-Node[3] ?'
echo '  1)Everything: Compute-Node + Controller-Node (everything-in-one system)'
echo '  2)Compute-Node: nova-compute, nova-network'
echo '  3)Controller-Node: nova-api, nova-objectstore (TBD for nova-volume)'
echo -n '  Which one [1/2/3]? '
read NODE

if [ $NODE == 1 ]; then
  install_compute
  install_controller
elif [ $NODE == 2 ]; then
  install_compute
elif [ $NODE == 3 ]; then
  install_controller
else
  echo 'Unexpected number!'
  exit 1
fi

echo '==  Finished =='
exit 0

