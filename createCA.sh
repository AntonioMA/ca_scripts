#!/bin/bash

case $# in
    1)  mkdir -p $1
        for i in certs config conf crl newcerts private requests scripts
        do
          mkdir -p $1/$i
        done
        cp scripts/* $1/scripts && chmod 755 $1/scripts/*
        cp config/* $1/config
        cd $1
        ABS_CA_PATH=`pwd`
        cat <<EOF > $1/scripts/settings.sh
# Common settings file
# Config file for openSSL
CFG=$ABS_CA_PATH/config/openssl.cnf
# Directory for openSSL binaries
SSLDIR=/usr/bin
# Directory for temporal files
DIRTEMP=/var/tmp
#output directory for batch signed certificates
OUTDIR=$ABS_CA_PATH/certs

# Not strictly required but...
export CFG SSLDIR DIRTEMP OUTDIR
EOF
        sed -i -e "s%YOUR_CA_DIR_HERE%${ABS_CA_PATH}%g" config/openssl.cnf
        touch conf/index.txt
        touch conf/index.txt.attr
        echo 01000000 > conf/serial
        openssl req -config config/openssl.cnf -newkey rsa:2048 -pkeyopt rsa_keygen_pubexp:3 -x509 -days 7200 -set_serial 1 -reqexts v3_ca -out conf/CA.pem -keyout private/CA.key
        ;;
    *) echo "Error, missing required parameter 'target_directory'. Usage:"
       echo "$0 target_directory"
       exit 1
      ;;
esac
