# Scripts to generate COSE examples

This subdirectory contains the shell scripts and key material to create the COSE examples used in the Constrained BRSKI draft.

## How to build
When scripts or `make` are run locally in this directory, an output subdirectory 'output' will be created. 

Use `make copy` to copy the output files from this directory (i.e. the generated certs, voucher, hex files, etc.) 
to the 'examples/cose-example' directory from where they will be included in the IETF draft when it is built with `make`.

## Required Tools

```
make
cbor2diag.rb  (in Ruby, install with 'gem install cbor-diag' - see https://github.com/cabo/cbor-diag )
xxd
hexdump
openssl
```