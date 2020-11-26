.SUFFIXES: .vrq .b64 .diag .vch

all: vr_00-D0-E5-F2-00-03.b64 vr_00-D0-E5-F2-00-03.diag \
	parboiled_vr_00-D0-E5-F2-00-03.b64 parboiled_vr_00-D0-E5-F2-00-03.diag \
	voucher_00-D0-E5-F2-00-03.b64 voucher_00-D0-E5-F2-00-03.diag \
	key_00-D0-E5-F2-00-03.pem device_00-D0-E5-F2-00-03.crt-txt \
	masa_00-D0-E5-F2-00-03.crt-txt voucher_status.hex

%.b64:  %.vrq
	base64 -w 60 $< >$@

%.diag: %.vrq
	cbor2diag.rb $< | fold -60 >$@

%.b64:  %.vch
	base64 -w 60 $< >$@

%.diag: %.vch
	cbor2diag.rb $< | fold -60 >$@

%.crt-txt: %.crt
	openssl x509 -noout -text -in $< | sed -e's/  / /g' | fold -60 >$@

#%.diag: %.hex
#	xxd -r -p $< | cbor2diag.rb | fold -60 >$@

%.bin: %.diag
	diag2cbor.rb $< | fold -60 >$@

%.hex: %.bin
	xxd -p $< | fold -60 >$@

update:
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-03/vr_00-D0-E5-F2-00-03.vrq .
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-03/parboiled_vr_00-D0-E5-F2-00-03.vrq .
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-03/voucher_00-D0-E5-F2-00-03.vch .
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-03/key.pem key_00-D0-E5-F2-00-03.pem
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-03/device.crt device_00-D0-E5-F2-00-03.crt
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-03/masa.crt masa_00-D0-E5-F2-00-03.crt



