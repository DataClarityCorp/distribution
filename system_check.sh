#!/bin/bash

MIN_CPU_NUMBER=4
MIN_RAM_SIZE=16
MIN_FREE_DISK_SPACE=30

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

NO_ERROR=true

CPU_NUMBER=$(nproc)
if [[ $CPU_NUMBER -lt $MIN_CPU_NUMBER ]]
then
  echo 'Insufficient number of CPUs.'
  NO_ERROR=false
fi

RAM_SIZE=$(printf "%.0f" "$(grep MemTotal /proc/meminfo | awk '{print $2/1024^2}')")
if [[ $RAM_SIZE -lt $MIN_RAM_SIZE ]]
then
  echo 'Insufficient RAM size.'
  NO_ERROR=false
fi

SHOULD_REMOVE_SNAP_DIR=false
if [[ ! -d "/var/snap" ]]
then
  mkdir /var/snap
  SHOULD_REMOVE_SNAP_DIR=true
fi

SHOULD_REMOVE_MICROK8S_DIR=false
if [[ ! -d "/var/snap/microk8s" ]]
then
  mkdir /var/snap/microk8s
  SHOULD_REMOVE_MICROK8S_DIR=true
fi

FREE_DISK_SPACE=$(printf "%.0f" "$(df /var/snap/microk8s | awk 'FNR==2{print $4/1024^2}')")
if [[ $FREE_DISK_SPACE -lt $MIN_FREE_DISK_SPACE ]]
then
  echo 'Insufficient free disk space for /var/snap/microk8s.'
  NO_ERROR=false
fi

if [[ $SHOULD_REMOVE_MICROK8S_DIR == true ]]
then
  rmdir /var/snap/microk8s
fi

if [[ $SHOULD_REMOVE_SNAP_DIR == true ]]
then
  rmdir /var/snap
fi

function check_port() {
  PORT=$1
  PORT_USAGE=$(lsof -i:"$PORT" | grep LISTEN)
  if [[ -n $PORT_USAGE ]]
then
  echo "Port $PORT is already in use."
  NO_ERROR=false
fi
}

check_port 80
check_port 443
check_port 5432

function check_host() {
  HOST=$1

  ping -c 1 "$HOST" 2>&1 > /dev/null
  PING_RESULT=$(echo $?)

  if [[ $PING_RESULT -ne 0 ]]
  then
    echo "Host $HOST is not reachable."
    NO_ERROR=false
  fi
}

check_host "api.snapcraft.io"
#check_host "auth.docker.io"
#check_host "fastly.cdn.snapcraft.io"
check_host "gcr.io"
check_host "googlecode.l.googleusercontent.com"
check_host "k8s.gcr.io"
check_host "production.cloudflare.docker.com"
#check_host "quay.io"
#check_host "registry-1.docker.io"
check_host "storage.googleapis.com"

if [[ $NO_ERROR == true ]]
then
  echo 'Validation successfully passed.'
fi
