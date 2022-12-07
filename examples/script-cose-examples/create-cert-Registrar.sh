#!/bin/bash
# Create new cert for: Registrar in a company domain

# days certificate is valid
VALIDITY=1095

# cert filename
NAME=registrar

# create csr
openssl req -new -key keys/privkey_registrar.pem -out $NAME.csr -subj "/CN=Custom-ER Registrar/OU=Office dept/O=Custom-ER, Inc./L=Ottowa/ST=ON/C=CA"

# sign csr
openssl x509 -set_serial 0xC3F62149B2E30E3E -CAform PEM -CA output/domain_ca.pem -extfile x509v3.ext -extensions registrar_ext -req -in $NAME.csr -CAkey keys/privkey_domain_ca.pem -out output/$NAME.pem -days $VALIDITY -sha256

# delete temp files
rm -f $NAME.csr

# convert to .der format
openssl x509 -in output/$NAME.pem -inform PEM -out output/$NAME.der -outform DER

