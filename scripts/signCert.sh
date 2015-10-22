#!/bin/bash
#Should work with vanilla sh, but '.' doesn't work correctly on bash, and 'source' doesn't exist on sh. So... tough luck
# This script signs a bunch of certificate requests
# Use: signCert.sh certrequest [certrequest ...]

# Note that this script generate some files that should be private on a temporal directory (by default, /var/tmp)
# If you don't like this directory, you should modify the settings.sh file

source `dirname $0`/settings.sh

case $# in

0) echo "
Usage: signCert.sh [-c CA] files
                   files: One or more files, in PEM PKCS#10 format to sign
"

;;

*)

if [ "$1" = "-c" ]
 then
   CA="-name $2"
   shift
   shift
 else
   CA=""
fi

$SSLDIR/openssl ca -config $CFG $CA -outdir $OUTDIR -batch -infiles $*


case $? in

  0) echo "All done. Certificates are in $OUTDIR"
	   ;;
  *) echo "Error signing certificates. Please check previous messages for error description"
	;;
    esac
   # Since we don't know at which step it failed, if it failed, better to let this out here
#   rm -f $CLAVE $SOLICITUD $CERT

;;
esac

