#!/bin/sh

if [ $# != 2 ] 
then
 echo "uso:$0 host port"
 exit 1
fi

HOST=$1
PORT=$2

/usr/local/ssl/bin/openssl s_client -connect $HOST:$PORT -state -debug
