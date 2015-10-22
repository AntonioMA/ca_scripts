#!/bin/bash
#Should work with vanilla sh, but '.' doesn't work correctly on bash, and 'source' doesn't exist on sh. So... tough luck
# This script generates a new keypair and certificate, in PKCS#12 format
# Use: newCert.sh outputfile outputFilePassword
#                 outputFile: Path and filename of the output PKCS#12
#                 outputFilePassword: Pasword of the previous file

# Note that this script generate some files that should be private on a temporal directory (by default, /var/tmp)
# If you don't like this directory, you should modify the settings.sh file

source `dirname $0`/settings.sh

case $# in
2)

    OUTP12=$1

    CLAVE=$DIRTEMP/clave$$.pem
    SOLICITUD=$DIRTEMP/solicitud$$.pem
    CERT=$DIRTEMP/cert$$.pem

    $SSLDIR/openssl req -config $CFG -new -reqexts v3_req -keyout $CLAVE -out $SOLICITUD -days 720 -passin pass:$2 -passout pass:$2 && \
        $SSLDIR/openssl ca -config $CFG -out $CERT -batch -infiles $SOLICITUD && \
        $SSLDIR/openssl pkcs12 -export -in $CERT -inkey $CLAVE -out $OUTP12 -passin pass:$2 -passout pass:$2

    case $? in

	0) echo "All done. $OUTP12 file has been created with $2 password"
	   ;;
 	*) echo "Error generating P12 file. Please check previous messages for error description"
	;;
    esac
   # Since we don't know at which step it failed, if it failed, better to let this out here
   rm -f $CLAVE $SOLICITUD $CERT

;;
*) echo "
Usage: newCert.sh outputfile outputFilePassword
                  outputFile: Path and filename of the output PKCS#12
                  outputFilePassword: Pasword of the previous file
"
;;
esac

