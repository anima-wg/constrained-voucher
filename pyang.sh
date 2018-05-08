#!/bin/sh

# use local copy?
if [ -x pyang/bin/pyang ]
then
    p=`pwd`/pyang
    export PATH=$p/bin:$PATH
    export MANPATH=$p/man:$MANPATH
    export PYTHONPATH=$p:$PYTHONPATH
    export YANG_MODPATH=$p/modules:$YANG_MODPATH
    export PYANG_XSLT_DIR=$p/xslt
    export PYANG_RNG_LIBDIR=$p/schema
    export W=$p
fi
which pyang >&2
pyang "$@"
    
