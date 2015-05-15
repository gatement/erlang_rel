#!/bin/sh

SASL_DIR=/usr/local/Cellar/erlang/17.5/lib/erlang/lib/sasl-2.4.1

if [ "x" != "x$1" -a "x" != "x$2" -a "x" != "x$3" -a "x" != "x$4" ] ; then
    # generate relup 
    cp $2/src/*.appup $2/ebin/
    erl -pa $1 $1/ebin $1/deps/*/ebin $2 $2/ebin $2/deps/*/ebin -eval "systools:make_relup(\"$4\",[\"$3\"],[\"$3\"])" -s init stop
    # pack
    erl -pa ${SASL_DIR}/examples/ebin $2/ebin $2/deps/*/ebin -eval "target_system:create(\"$4\")" -s init stop
elif [ "x" != "x$1" -a "x" != "x$2" ] ; then
    # pack first time
    REL_PATH=$1/release
    echo $REL_PATH
    erl -pa ${SASL_DIR}/examples/ebin $1/ebin $1/deps/*/ebin -eval "target_system:create(\"$REL_PATH\")" -s init stop
else
    echo "usage: $0 app/root/dir | $0 from_dir to_dir from_rel_name_without_ext to_rel_name_without_ext"
    echo "e.g. first pack: $0 /app/erlang_rel"
    echo "e.g. upgrade   : $0 /var/tmp/gizwits_monitor_4.0.0 /var/tmp/gizwits_monitor_4.0.1 /var/tmp/gizwits_monitor_4.0.0/gizwits_monitor_4.0.0 /var/tmp/gizwits_monitor_4.0.0/gizwits_monitor_4.0.1"
fi
