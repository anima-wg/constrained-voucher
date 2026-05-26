#!/bin/bash
# File: create-cert-MASA-server.sh
# Create new cert for: MASA TLS server, signed by the MASA CA (root CA)

# days certificate is valid
VALIDITY=1095

# cert filename
NAME=masa

# create csr
openssl req -new -key keys/privkey_masa.pem -out $NAME.csr \
            -subj "/CN=masa-server.stok.nl/O=vanderstok/L=Helmond/C=NL"

# sign csr
mkdir output >& /dev/null
openssl x509 -set_serial 0xA7B41C90D5F2386B -CAform PEM -CA \
 output/masa_ca.pem -extfile x509v3.ext -extensions masa_ext \
 -req -in $NAME.csr -CAkey keys/privkey_masa_ca.pem \
 -out output/$NAME.pem -days $VALIDITY -sha256

# delete temp files
rm -f $NAME.csr

# convert to .der format
openssl x509 -in output/$NAME.pem -inform PEM -out output/$NAME.der \
             -outform DER
