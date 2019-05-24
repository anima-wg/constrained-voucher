all: vr_00-D0-E5-F2-00-02.b64 vr_00-D0-E5-F2-00-02.diag


vr_00-D0-E5-F2-00-02.b64:  vr_00-D0-E5-F2-00-02.vrq
	base64 vr_00-D0-E5-F2-00-02.vrq >vr_00-D0-E5-F2-00-02.b64

vr_00-D0-E5-F2-00-02.diag: vr_00-D0-E5-F2-00-02.vrq
	cbor2diag.rb vr_00-D0-E5-F2-00-02.vrq | fold -60 >vr_00-D0-E5-F2-00-02.diag


