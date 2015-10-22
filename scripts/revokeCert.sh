#!/bin/bash
#Should work with vanilla sh, but '.' doesn't work correctly on bash, and 'source' doesn't exist on sh. So... tough luck
# This script generates a new keypair and certificate REQUEST (not certificate), in PKCS#10 format
# This request will be useful if we want another CA to sign it.
# Use: revokeCert.sh certfile [certfile ...]
#                 certfile: certificate to revoke, in PEM format. Note that all the CA generated certs are in $OUTDIR

# Note that this script generate some files that should be private on a temporal directory (by default, /var/tmp)
# If you don't like this directory, you should modify the settings.sh file

source `dirname $0`/settings.sh

case $# in

0) echo "
Usage: revokeCert.sh files
                   files: One or more files, in PEM X509 format to revoke
"

;;

*)

for i in $*
do
echo -n Revoking $i [
if $SSLDIR/openssl ca -config $CFG -revoke $i
then
  echo OK]
else
  echo FAIL]
fi

done

echo "Certificates revoked. Generating new CRL"

$SSLDIR/openssl ca -config $CFG -gencrl -crldays 720

case $? in

  0) echo "All done. New CRL is in $OUTDIR/../crl"
	   ;;
  *) echo "Error generating new CRL. Please check previous messages for error description"
	;;
    esac

;;
esac

