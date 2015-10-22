#!/bin/bash

if [ $# = 2 ]; then
  CERT=$1
  INFORM=$2
else if [ $# = 1 ]; then
       CERT=$1
     else
      echo "uso:$0 cert [inform]"
      exit 1
     fi
fi

source `dirname $0`/settings.sh

$SSLDIR/openssl x509 -in $CERT -noout -text
