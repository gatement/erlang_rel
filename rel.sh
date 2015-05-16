#!/bin/sh

SASL_DIR=/usr/local/Cellar/erlang/17.5/lib/erlang/lib/sasl-2.4.1

# pack first time
if [ "pack" == "$1" -a "x" != "x$2" ] ; then
    REL_FILE=$2/release
    erl -pa ${SASL_DIR}/examples/ebin $2/ebin $2/deps/*/ebin -eval "target_system:create(\"$REL_FILE\")" -s init stop

# unpack first time
elif [ "unpack" == "$1" -a "x" != "x$2" -a "x" != "x$3" ] ; then
    erl -pa ${SASL_DIR}/examples/ebin -eval "target_system:install(\"$2\", \"$3\")" -s init stop

# upgrade
elif [ "x" != "x$1" -a "x" != "x$2" -a "x" != "x$3" -a "x" != "x$4" ] ; then
    # generate relup 
    cp $2/src/*.appup $2/ebin/
    erl -pa $1 $1/ebin $1/deps/*/ebin $2 $2/ebin $2/deps/*/ebin -eval "systools:make_relup(\"$4\",[\"$3\"],[\"$3\"])" -s init stop
    # pack
    erl -pa ${SASL_DIR}/examples/ebin $2/ebin $2/deps/*/ebin -eval "target_system:create(\"$4\")" -s init stop

else
    echo "usage: $0 pack app/root/dir"
    echo "usage: $0 unpack tar/file/without/ext target/dir"
    echo "usage: $0 pack from_dir to_dir from_rel_name_without_ext to_rel_name_without_ext"
    echo "e.g first pack  : $0 pack /app/erlang_rel"
    echo "e.g first unpack: $0 unpack /app/release /usr/local/erlang_rel"
    echo "e.g upgrade     : $0 /var/tmp/erlang_rel_4.0.0 /var/tmp/erlang_rel_4.0.1 /var/tmp/erlang_rel_4.0.0/erlang_rel_4.0.0 /var/tmp/erlang_rel_4.0.0/erlang_rel_4.0.1"
fi
