DRAFT:=constrained-voucher
VERSION:=$(shell ./getver ${DRAFT}.mkd )
YANGDATE=2021-04-15
CWTDATE1=yang/ietf-voucher-constrained@${YANGDATE}.yang
CWTSIDDATE1=ietf-voucher-constrained@${YANGDATE}.sid
CWTSIDLIST1=ietf-voucher-constrained-sid.txt
CWTDATE2=yang/ietf-voucher-request-constrained@${YANGDATE}.yang
CWTSIDLIST2=ietf-voucher-request-constrained-sid.txt
CWTSIDDATE2=ietf-voucher-request-constrained@${YANGDATE}.sid
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
PYANG=./pyang.sh
PYANGPATH=--path=../../anima/bootstrap/yang --path ${HOME}/.local/share/yang/modules/ietf

# git clone this from https://github.com/mbj4668/pyang.git
# then, cd pyang/plugins;
#       wget https://raw.githubusercontent.com/core-wg/yang-cbor/master/sid.py
# sorry.
PYANGDIR=/sandel/src/pyang

${DRAFT}-${VERSION}.txt: ${DRAFT}.txt
	cp ${DRAFT}.txt ${DRAFT}-${VERSION}.txt
	: git add ${DRAFT}-${VERSION}.txt ${DRAFT}.txt

${CWTDATE1}: ietf-voucher-constrained.yang
	mkdir -p yang
	sed -e"s/YYYY-MM-DD/${YANGDATE}/" ietf-voucher-constrained.yang > ${CWTDATE1}

${CWTDATE2}: ietf-voucher-request-constrained.yang
	mkdir -p yang
	sed -e"s/YYYY-MM-DD/${YANGDATE}/" ietf-voucher-request-constrained.yang > ${CWTDATE2}

ietf-voucher-constrained-tree.txt: ${CWTDATE1}
	${PYANG} ${PYANGPATH} -f tree --tree-print-groupings --tree-line-length=70 ${CWTDATE1} > ietf-voucher-constrained-tree.txt

ietf-voucher-request-constrained-tree.txt: ${CWTDATE2}
	${PYANG} ${PYANGPATH} -f tree --tree-print-groupings --tree-line-length=70 ${CWTDATE2} > ietf-voucher-request-constrained-tree.txt

%.xml: %.mkd ${CWTDATE1} ${CWTDATE2} ietf-voucher-constrained-tree.txt ietf-voucher-request-constrained-tree.txt ${CWTSIDLIST1} ${CWTSIDLIST2} ${EXAMPLES}
	kramdown-rfc2629 -3 ${DRAFT}.mkd | perl insert-figures >${DRAFT}.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --v2v3 ${DRAFT}.xml
	mv ${DRAFT}.v2v3.xml ${DRAFT}.xml

%.txt: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --text -o $@ $?

%.html: %.xml
	unset DISPLAY; XML_LIBRARY=$(XML_LIBRARY):./src xml2rfc --html -o $@ $?

submit: ${DRAFT}.xml
	curl -S -F "user=mcr+ietf@sandelman.ca" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submit

# Base SID value for voucher: 2450
${CWTSIDLIST1}: ${CWTDATE1} ${CWTSIDDATE1}
	mkdir -p yang
	${PYANG} ${PYANGPATH} --sid-list --sid-update-file=${CWTSIDDATE1} ${CWTDATE1} | ./truncate-sid-table >ietf-voucher-constrained-sid.txt

boot-sid1:
	${PYANG} ${PYANGPATH} --sid-list --generate-sid-file 2450:50 ${CWTDATE1}

boot-sid2:
	${PYANG} ${PYANGPATH} --sid-list --generate-sid-file 2500:50 ${CWTDATE2}


# Base SID value for voucher request: 2500
${CWTSIDLIST2}: ${CWTDATE2}  ${CWTSIDDATE2}
	mkdir -p yang
	${PYANG} ${PYANGPATH} --sid-list --sid-update-file=${CWTSIDDATE2} ${CWTDATE2} | ./truncate-sid-table >ietf-voucher-request-constrained-sid.txt

version:
	echo Version: ${VERSION}

clean:
	-rm -f ${DRAFT}.xml ${CWTDATE1} ${CWTDATE2}

.PRECIOUS: ${DRAFT}.xml
