DRAFT:=dtsecurity-zerotouch-join
VERSION:=$(shell ./getver ${DRAFT}.mkd )
YANGDATE=$(shell date +%Y-%m-%d)
CWTDATE=ietf-cwt-voucher@${YANGDATE}.yang

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

${CWTDATE}: ietf-cwt-voucher.yang
	sed -e"s/YYYY-MM-DD/${YANGDATE}/" ietf-cwt-voucher.yang > ${CWTDATE}

ietf-cwt-voucher-tree.txt: ${CWTDATE}
	pyang --path=../../anima/voucher:../../anima/bootstrap -f tree --tree-print-groupings ${CWTDATE} > ietf-voucher-request-tree.txt

%.xml: %.mkd ${CWTDATE} ietf-cwt-voucher-tree.txt
	kramdown-rfc2629 ${DRAFT}.mkd | ./insert-figures >${DRAFT}.xml
	git add ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc $? $@

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?




version:
	echo Version: ${VERSION}

.PRECIOUS: ${DRAFT}.xml
