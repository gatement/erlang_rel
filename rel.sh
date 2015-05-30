#!/bin/sh

SASL_DIR=/usr/local/erlang-17.4/lib/erlang/lib/sasl-2.4.1

# make first tar
if [ "pack" == "$1" -a "x" != "x$2" -a "x" != "x$3" ] ; then
    REL_FILE=$2/release

    # generate sys.config corresponding template file
    cp -f sys.config.$3 sys.config

    # make tar
    erl -pa ${SASL_DIR}/examples/ebin $2/ebin $2/deps/*/ebin -eval "target_system:create(\"$REL_FILE\")" -s init stop

# install first target system
elif [ "install" == "$1" -a "x" != "x$2" -a "x" != "x$3" ] ; then
    # install target system
    erl -pa ${SASL_DIR}/examples/ebin -eval "target_system:install(\"$2\", \"$3\")" -s init stop

# make upgrade tar
elif [ "upgrade" == "$1" -a "x" != "x$2" -a "x" != "x$3" -a "x" != "x$4" ] ; then
    FROM_REL_FILE=$2/release
    TO_REL_FILE=$3/release

    # generate sys.config corresponding template file
    cp -f sys.config.$4 sys.config

    # copy appup file
    cp $3/src/*.appup $3/ebin/

    # generate relup
    erl -pa $2 $2/ebin $2/deps/*/ebin $3 $3/ebin $3/deps/*/ebin -eval "systools:make_relup(\"$TO_REL_FILE\",[\"$FROM_REL_FILE\"],[\"$FROM_REL_FILE\"])" -s init stop

    # pack
    erl -pa ${SASL_DIR}/examples/ebin $3/ebin $3/deps/*/ebin -eval "target_system:create(\"$TO_REL_FILE\")" -s init stop

else
    echo "usage: $0 pack app/root/dir env"
    echo "usage: $0 install tar/file/without/ext target/dir"
    echo "usage: $0 upgrade from/app/root/dir to/app/root/dir env"
    echo "e.g make first pack  : $0 pack /app/erlang_rel prod"
    echo "e.g first install    : $0 install /app/release /usr/local/erlang_rel"
    echo "e.g make upgrade pack: $0 upgrade /var/tmp/erlang_rel_0.1.0 /var/tmp/erlang_rel_0.2.0 prod"
fi
