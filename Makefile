DRAFT:=dtsecurity-zerotouch-join
VERSION:=$(shell ./getver ${DRAFT}.mkd )

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

ietf-cwt-voucher-tree.txt: ietf-cwt-voucher.yang
	pyang -f tree --tree-print-groupings ietf-cwt-voucher.yang > ietf-cwt-voucher-tree.txt

%.xml: %.mkd ietf-cwt-voucher.yang ietf-cwt-voucher-tree.txt
	kramdown-rfc2629 ${DRAFT}.mkd | ./insert-figures >${DRAFT}.xml
	git add ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc $? $@

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?


version:
	echo Version: ${VERSION}

.PRECIOUS: ${DRAFT}.xml
