# ca_scripts
Simple scripts to create and manage a (totally non for production!) openssl ca.

This repository has a script (createCA.sh) to create a new openssl base CA. The new created CA will
have a set of scripts attached to ease the generation and revocation of certificates.

## Usage

./createCA.sh targetDir

The generated CA config file will be on targetDir/conf/openssl.conf. If you want to change anything
about the generated certificates (or just change the default values for organization and such) just
edit this file.
