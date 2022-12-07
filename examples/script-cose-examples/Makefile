#
# Makefile for COSE examples for Appendix

all: certs certs_hex_txt artifacts

certs: cert_masa_ca cert_pledge cert_domain_ca cert_registrar

artifacts: pvr rvr voucher pvr-nonsigned rvr-nonsigned voucher-nonsigned

certs_hex_txt: certs masa_ca pledge domain_ca registrar

cert_masa_ca: x509v3.ext
	./create-cert-MASA.sh
	
cert_pledge: cert_masa_ca x509v3.ext
	./create-cert-Pledge.sh

cert_domain_ca: x509v3.ext
	./create-cert-DomainCA.sh

cert_registrar: cert_domain_ca x509v3.ext
	./create-cert-Registrar.sh

# Create .hex and .txt versions of certs.
masa_ca pledge domain_ca registrar: certs
	hexdump -ve '32/1 "%.2X" "\n"' output/$@.der > output/$@.hex
	openssl ec -inform PEM -noout -text -in keys/privkey_$@.pem > output/privkey_$@.txt
	./pem2txt.sh output/$@.pem > output/$@.txt

# take any kind of hex string and format it in lines, for inclusion in draft.
# Also create CBOR diagnostic .txt version.
pvr rvr voucher pvr-nonsigned rvr-nonsigned voucher-nonsigned: 
	cat cose-hex/$@.hex | xxd -r -p | hexdump -ve '32/1 "%.2X" "\n"' > output/$@.hex
	cat cose-hex/$@.hex | xxd -r -p | cbor2diag.rb | sed -E 's/(.{68})/\1\n/g' > output/$@.txt

copy:
	cp output/* ../cose-examples/

clean:
	rm -rf ./output

