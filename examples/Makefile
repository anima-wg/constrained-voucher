.SUFFIXES: .vrq .b64 .diag .vch

all: vr_00-D0-E5-F2-00-02.b64 vr_00-D0-E5-F2-00-02.diag \
	parboiled_vr_00-D0-E5-F2-00-02.b64 parboiled_vr_00-D0-E5-F2-00-02.diag \
	voucher_00-D0-E5-F2-00-02.b64 voucher_00-D0-E5-F2-00-02.diag


%.b64:  %.vrq
	base64 -w 60 $< >$@

%.diag: %.vrq
	cbor2diag.rb $< | fold -60 >$@

%.b64:  %.vch
	base64 -w 60 $< >$@

%.diag: %.vch
	cbor2diag.rb $< | fold -60 >$@

update:
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-02/parboiled_vr_00-D0-E5-F2-00-02.vrq .
	cp /corp/projects/pandora/reach/spec/files/product/00-D0-E5-F2-00-02/voucher_00-D0-E5-F2-00-02.vch .



