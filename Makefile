DRAFT:=constrained-voucher
VERSION:=$(shell ./getver ${DRAFT}.mkd )
EXAMPLES=two-ca-chain.txt
EXAMPLES+=pinning-options.txt
EXAMPLES+=$(wildcard examples/voucher-example*.txt)
EXAMPLES+=$(wildcard examples/voucher-request-example*.txt)
EXAMPLES+=examples/voucher-status.hex
EXAMPLES+=examples/voucher-statusdiag.txt
EXAMPLES+=$(wildcard examples/cose-examples/*.txt)
EXAMPLES+=$(wildcard examples/cose-examples/*.hex)
EXAMPLES+=$(wildcard examples/script-cose-examples/*.sh)
EXAMPLES+=$(wildcard examples/script-cose-examples/*.ext)
EXAMPLES+=$(wildcard examples/cose-examples/keys/*.pem)

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

%.xml: %.mkd ${EXAMPLES}
	kramdown-rfc2629 -3 ${DRAFT}.mkd | perl insert-figures >${DRAFT}.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --v2v3 ${DRAFT}.xml
	mv ${DRAFT}.v2v3.xml ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --text -o $@ $?

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	curl -S -F "user=mcr+ietf@sandelman.ca" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit

version:
	echo Version: ${VERSION}

clean:
	-rm -f ${DRAFT}.xml

.PRECIOUS: ${DRAFT}.xml
