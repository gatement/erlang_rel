# erlang_rel
erlang release test

## setup
* create the firt pack by `./rel.sh pack app/root/dir`
* install the first target system by `./rel.sh unpack tar/file/without/ext target/dir`
* update `target/dir/bin/start` to localize
  1. add pipe file name
  2. add heart monitor 
  e.g $ROOTDIR/bin/run_erl -daemon /tmp/erlang_rel $ROOTDIR/log "exec $ROOTDIR/bin/start_erl $ROOTDIR $RELDIR $START_ERL_DATA -heart -env HEART_COMMAND $ROOTDIR/bin/start" 
* use `target/dir/bin/to_erl /tmp/erlang_rel` to attach the erlang emulator 
