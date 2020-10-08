#!/bin/bash
#try-cert.sh
export dir=./brski/intermediate
export cadir=./brski
export cnfdir=./conf
export format=pem
export default_crl_days=30
sn=8

DevID=pledge.1.2.3.4
serialNumber="serialNumber=$DevID"
export hwType=1.3.6.1.4.1.6715.10.1
export hwSerialNum=01020304 
export subjectAltName="otherName:1.3.6.1.5.5.7.8.4;SEQ:hmodname"
echo  $hwType - $hwSerialNum
echo $serialNumber

# remove all files
rm -r ./brski/*
#
# initialize file structure
# root level
cd $cadir
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
touch serial
echo 11223344556600 >serial
echo 1000 > crlnumber
# intermediate level
mkdir intermediate
cd intermediate
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 11223344556600 >serial
echo 1000 > crlnumber
cd ../..



# file structure is cleaned start filling

echo "#############################"
echo "create registrar keys and certificates "
echo "#############################"


echo "create root registrar certificate using ecdsa with sha256"
openssl ecparam -name prime256v1 -genkey \
  -noout -out $cadir/private/ca-regis.key

openssl req -new -x509 \
 -key $cadir/private/ca-regis.key \
 -out $cadir/certs/ca-regis.crt \
 -extensions v3_ca\
 -days 365 \
 -subj "/C=NL/ST=NB/L=Helmond/O=vanderstok\
"/OU=consultancy/CN=registrar.stok.nl"

# Combine authority certificate and key
echo "Combine authority certificate and key"
openssl pkcs12 -passin pass:watnietweet \
 -passout pass:watnietweet \
 -inkey $cadir/private/ca-regis.key \
 -in $cadir/certs/ca-regis.crt -export \
 -out $cadir/certs/ca-regis-comb.pfx

# converteer authority pkcs12 file to pem
echo "converteer authority pkcs12 file to pem"
openssl pkcs12 -passin pass:watnietweet -passout pass:watnietweet\
   -in $cadir/certs/ca-regis-comb.pfx \\
   -out $cadir/certs/ca-regis-comb.crt -nodes

#show certificate in registrar combined certificate
openssl  x509 -in $cadir/certs/ca-regis-comb.crt -text

#
# Certificate Authority for MASA
#
echo "#############################"
echo "create MASA keys and certificates "
echo "#############################"

echo "create root MASA certificate using ecdsa with sha 256 key"
openssl ecparam -name prime256v1 -genkey -noout \
 -out $cadir/private/ca-masa.key

openssl req -new -x509 \
 -days 365 -key $cadir/private/ca-masa.key \
 -out $cadir/certs/ca-masa.crt \
 -extensions v3_ca\
 -subj "/C=NL/ST=NB/L=Helmond/O=vanderstok/\
OU=manufacturer/CN=masa.stok.nl"

# Combine authority certificate and key
echo "Combine authority certificate and key for masa"
openssl pkcs12 -passin pass:watnietweet \
   -passout pass:watnietweet\
   -inkey $cadir/private/ca-masa.key \
   -in $cadir/certs/ca-masa.crt -export \
   -out $cadir/certs/ca-masa-comb.pfx

# converteer authority pkcs12 file to pem for masa
echo "converteer authority pkcs12 file to pem for masa"
openssl pkcs12 -passin pass:watnietweet \
   -passout pass:watnietweet\
   -in $cadir/certs/ca-masa-comb.pfx \
   -out $cadir/certs/ca-masa-comb.crt -nodes

#show certificate in pledge combined certificate
openssl  x509 -in $cadir/certs/ca-masa-comb.crt -text


#
# Certificate for Pledge derived from MASA certificate
#
echo "#############################"
echo "create pledge keys and certificates "
echo "#############################"


# Pledge derived Certificate

echo "create pledge derived certificate using ecdsa with sha256"
openssl ecparam -name prime256v1 -genkey \
 -noout -out $dir/private/pledge.key

echo "create pledge certificate request"
openssl req -nodes -new -sha256 \
  -key $dir/private/pledge.key -out $dir/csr/pledge.csr \
  -subj \
"/C=NL/ST=NB/L=Helmond/O=vanderstok/OU=manufacturing\
/CN=uuid:$DevID/$serialNumber"

# Sign pledge derived Certificate
echo "sign pledge derived certificate "
openssl ca -config $cnfdir/openssl-pledge.cnf \
 -extensions 8021ar_idevid\
 -days 365 -in $dir/csr/pledge.csr -out $dir/certs/pledge.crt 

# Add pledge key and pledge certificate to pkcs12 file
echo "Add pledge key and pledge certificate to pkcs12 file"
openssl pkcs12  -passin pass:watnietweet\
   -passout pass:watnietweet\
   -inkey $dir/private/pledge.key \
   -in $dir/certs/pledge.crt -export \
   -out $dir/certs/pledge-comb.pfx

# converteer pledge pkcs12 file to pem
echo "converteer pledge pkcs12 file to pem"
openssl pkcs12 -passin pass:watnietweet \
    -passout pass:watnietweet\
   -in $dir/certs/pledge-comb.pfx \
   -out $dir/certs/pledge-comb.crt -nodes

#show certificate in pledge-comb.crt
openssl  x509 -in $dir/certs/pledge-comb.crt -text

#show private key in pledge-comb.crt
openssl ecparam -name prime256v1 \
  -in $dir/certs/pledge-comb.crt -text
