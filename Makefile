DRAFT:=dtsecurity-zerotouch-join
VERSION:=$(shell ./getver ${DRAFT}.mkd )
YANGDATE=$(shell date +%Y-%m-%d)
CWTDATE1=ietf-cwt-voucher@${YANGDATE}.yang
CWTDATE2=ietf-cwt-voucher-request@${YANGDATE}.yang

# git clone this from https://github.com/mbj4668/pyang.git
# then, cd pyang/plugins;
#       wget https://raw.githubusercontent.com/core-wg/yang-cbor/master/sid.py
# sorry.
PYANGDIR=/sandel/src/pyang

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

${CWTDATE1}: ietf-cwt-voucher.yang
	sed -e"s/YYYY-MM-DD/${YANGDATE}/" ietf-cwt-voucher.yang > ${CWTDATE1}

${CWTDATE2}: ietf-cwt-voucher-request.yang
	sed -e"s/YYYY-MM-DD/${YANGDATE}/" ietf-cwt-voucher-request.yang > ${CWTDATE2}

ietf-cwt-voucher-tree.txt: ${CWTDATE1}
	pyang --path=../../anima/voucher:../../anima/bootstrap -f tree --tree-print-groupings --tree-line-length=70 ${CWTDATE1} > ietf-cwt-voucher-tree.txt

ietf-cwt-voucher-request-tree.txt: ${CWTDATE2}
	pyang --path=../../anima/voucher:../../anima/bootstrap -f tree --tree-print-groupings --tree-line-length=70 ${CWTDATE2} > ietf-cwt-voucher-request-tree.txt

%.xml: %.mkd ${CWTDATE1} ${CWTDATE2} ietf-cwt-voucher-tree.txt ietf-cwt-voucher-request-tree.txt
	kramdown-rfc2629 ${DRAFT}.mkd | ./insert-figures >${DRAFT}.xml
	git add ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc $? $@

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	curl -S -F "user=mcr+ietf@sandelman.ca" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit

ietf-cwt-voucher.sidlist: ${CWTDATE1}
	PYTHONPATH=${PYANGDIR}:$PYTHONPATH YANG_MODPATH=${PYANGDIR}/modules:$YANG_MODPATH PYANG_XSLT_DIR=${PYANGDIR}/xslt PYANG_RNG_LIBDIR=${PYANGDIR}/schema pyang --path=../../anima/voucher:../../anima/bootstrap --list-sid ${CWTDATE1}

version:
	echo Version: ${VERSION}

.PRECIOUS: ${DRAFT}.xml
