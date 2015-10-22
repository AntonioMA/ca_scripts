#!/bin/bash
#Should work with vanilla sh, but '.' doesn't work correctly on bash, and 'source' doesn't exist on sh. So... tough luck
# This script generates a new keypair and certificate REQUEST (not certificate), in PKCS#10 format
# This request will be useful if we want another CA to sign it.
# Use: newReq.sh outputfile outputFilePassword
#                 outputFile: Path and filename of the output PKCS#12
#                 outputFilePassword: Pasword of the previous file

# Note that this script generate some files that should be private on a temporal directory (by default, /var/tmp)
# If you don't like this directory, you should modify the settings.sh file

source `dirname $0`/settings.sh

case $# in
2)

    OUTP12=$1

    SOLICITUD=request_$1.pem
    CLAVE=clave_$1.pem

    $SSLDIR/openssl req -config $CFG -new -reqexts v3_req -keyout $CLAVE -out $SOLICITUD -days 720 -passin pass:$2 -passout pass:$2

    case $? in

	0) echo "All done. $CLAVE and $SOLICITUD files have been created with $2 password"
	   ;;
 	*) echo "Error generating request file. Please check previous messages for error description"
	;;
    esac

;;
*) echo "
Usage: newReq.sh template outputFilePassword
                  template: Template for the output files. Output files will be generated on the current dir with XX_template.pem names
                  outputFilePassword: Pasword of the previous file
"
;;
esac
