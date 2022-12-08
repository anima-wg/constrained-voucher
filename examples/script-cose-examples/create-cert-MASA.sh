#!/bin/bash
# Create new cert for: MASA CA, self-signed CA certificate

# days certificate is valid
VALIDITY=3650

NAME=masa_ca

# create csr
openssl req -new -key keys/privkey_masa_ca.pem -out $NAME.csr -subj "/CN=masa.stok.nl/O=vanderstok/L=Helmond/C=NL"

# sign csr
mkdir output >& /dev/null
openssl x509 -set_serial 0xE39CDA17E1386A0A  -extfile x509v3.ext -extensions masa_ca_ext -req -in $NAME.csr -signkey keys/privkey_masa_ca.pem -out output/$NAME.pem -days $VALIDITY -sha256

# delete temp files
rm -f $NAME.csr

# convert to .der format
openssl x509 -in output/$NAME.pem -inform PEM -out output/$NAME.der -outform DER
