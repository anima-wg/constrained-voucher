#!/bin/bash
# Utility script to convert certificate .pem file to a good-looking, width-constrained
# .txt file output.
#
openssl x509 -text -noout -certopt ext_parse -in $1 | \
  sed -E 's/^    //g' | \
  sed -E 's/^    / /g' | \
  sed -E 's/    /  /g' | \
  sed -E 's/^( +)  keyid:/\1 keyid:/g' | \
  sed -E 's/^0:d=0(.+)/    \1/g' | \
  sed -E 's/^( +)(.{48}.{0,24}, )(.+)/\1\2\n\1        \3/g'
