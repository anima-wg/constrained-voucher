#!/bin/bash
# Create new cert for: Domain CA

# days certificate is valid
VALIDITY=3650

# filename of cert
NAME=domain_ca

# create an example Domain CA of company.
openssl req -new -key keys/privkey_domain_ca.pem -out $NAME.csr -subj "/CN=Custom-ER Global CA/OU=IT/O=Custom-ER, Inc./L=San Jose/ST=CA/C=US"
openssl x509 -set_serial 0x2AEA0413A42DC1CE -extfile x509v3.ext -extensions domain_ca_ext -req -in $NAME.csr -signkey keys/privkey_domain_ca.pem -out output/$NAME.pem -days $VALIDITY -sha256

# delete temp files
rm -f $NAME.csr

# convert to .der / .hex format
openssl x509 -in output/$NAME.pem -inform PEM -out output/$NAME.der -outform DER
hexdump -ve '1/1 "%.2X "' output/$NAME.der > output/$NAME.hex

# show cert
openssl x509 -text -noout -in output/$NAME.pem

