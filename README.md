# erlang_rel
erlang release test

## Setup
* Create the first tar by `./rel.sh pack app/root/dir`
* Install the first target system by `./rel.sh install tar/file/without/ext target/dir`
* Customize `target/dir/bin/start`
  1. Add pipe file name
  2. Add heart monitor 
  3. e.g $ROOTDIR/bin/run_erl -daemon `/tmp/erlang_rel` $ROOTDIR/log "exec $ROOTDIR/bin/start_erl $ROOTDIR $RELDIR $START_ERL_DATA `-heart -env HEART_COMMAND $ROOTDIR/bin/start`"
* Use `target/dir/bin/to_erl /tmp/erlang_rel` to attach the erlang emulator 
