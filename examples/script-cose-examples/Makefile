
all: output/masa_ca.pem \
	output/masa_ca.hex \
	output/pledge.pem \
	output/pledge.hex \
	output/domain_ca.pem \
	output/domain_ca.hex \
	output/registrar.pem \
	output/registrar.hex \
	output/pvr.hex \
	output/rvr.hex \
	output/voucher.hex \
	output/pvr.cbordiag \
	output/rvr.cbordiag \
	output/voucher.cbordiag \
	output/privkey_pledge.txt

output/masa_ca.pem: 
	./create-cert-MASA.sh

output/masa_ca.hex: 
	./create-cert-MASA.sh
	
output/pledge.pem: output/masa_ca.pem
	./create-cert-Pledge.sh

output/pledge.hex: output/masa_ca.pem
	./create-cert-Pledge.sh

output/domain_ca.pem: 
	./create-cert-DomainCA.sh

output/domain_ca.hex: 
	./create-cert-DomainCA.sh

output/registrar.pem: output/domain_ca.pem
	./create-cert-Registrar.sh

output/registrar.hex: output/domain_ca.pem
	./create-cert-Registrar.sh

# take PVR hex string and format it for inclusion in draft
output/pvr.hex: cose-hex/pvr.hex
	cat cose-hex/pvr.hex | xxd -r -p | hexdump -ve '32/1 "%.2X " "\n"' > output/pvr.hex

output/rvr.hex: cose-hex/rvr.hex
	cat cose-hex/rvr.hex | xxd -r -p | hexdump -ve '32/1 "%.2X " "\n"' > output/rvr.hex

output/voucher.hex: cose-hex/voucher.hex
	cat cose-hex/voucher.hex | xxd -r -p | hexdump -ve '32/1 "%.2X " "\n"' > output/voucher.hex

output/pvr.cbordiag: cose-hex/pvr.hex
	cat cose-hex/pvr.hex | xxd -r -p | cbor2diag.rb > output/pvr.cbordiag
	
output/rvr.cbordiag: cose-hex/rvr.hex
	cat cose-hex/rvr.hex | xxd -r -p | cbor2diag.rb > output/rvr.cbordiag
	
output/voucher.cbordiag: cose-hex/voucher.hex
	cat cose-hex/voucher.hex | xxd -r -p | cbor2diag.rb > output/voucher.cbordiag

output/privkey_pledge.txt: keys/privkey_pledge.pem
	openssl ec -inform PEM -noout -text -in keys/privkey_pledge.pem > output/privkey_pledge.txt

copy: all
	cp output/* ../cose-examples/

clean:
	rm -rf ./output

