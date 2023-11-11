#!/bin/bash
# File: create-cert-Pledge.sh
# Create new cert for: Pledge IDevID

# days certificate is valid - try to get close to the 802.1AR 
# specified 9999-12-31 end date.
SECONDS1=`date +%s` # time now
SECONDS2=`date --date="9999-12-31 23:59:59Z" +%s` # target end time
let VALIDITY="(${SECONDS2}-${SECONDS1})/(24*3600)"
echo "Using validity param -days ${VALIDITY}"

NAME=pledge

# create csr for device
# conform to 802.1AR guidelines, using only CN + serialNumber when 
# manufacturer is already present as CA.
# CN is not even mandatory, but just good practice.
openssl req -new -key keys/privkey_pledge.pem -out $NAME.csr -subj \
             "/CN=Stok IoT sensor Y-42/serialNumber=JADA123456789"

# sign csr - it uses faketime only to get endtime to 23:59:59Z
faketime '23:59:59Z' \
openssl x509 -set_serial 32429 -CAform PEM -CA output/masa_ca.pem \
  -CAkey keys/privkey_masa_ca.pem -extfile x509v3.ext -extensions \
  pledge_ext -req -in $NAME.csr -out output/$NAME.pem \
  -days $VALIDITY -sha256

# Note: alternative method using 'ca' command. Currently 
# doesn't work without 'country' subject field.
# openssl ca -rand_serial -enddate 99991231235959Z -certform PEM \
#  -cert output/masa_ca.pem -keyfile keys/privkey_masa_ca.pem \
#  -extfile x509v3.ext -extensions pledge_ext -in $NAME.csr \ 
#  -out $NAME.pem -outdir output

# delete temp files
rm -f $NAME.csr

# convert to .der format
openssl x509 -in output/$NAME.pem -inform PEM -out output/$NAME.der \
             -outform DER
