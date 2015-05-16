# erlang_rel
erlang release test

## Setup
* Create the first tar by `./rel.sh pack app/root/dir`
* Install the first target system by `./rel.sh install tar/file/without/ext target/dir`
* Customize `target/dir/bin/start`
  1. Add pipe file name
  2. Add heart monitor 
  3. e.g $ROOTDIR/bin/run_erl -daemon `/tmp/erlang_rel.pipe` $ROOTDIR/log "exec $ROOTDIR/bin/start_erl $ROOTDIR $RELDIR $START_ERL_DATA `-heart -env HEART_COMMAND $ROOTDIR/bin/start`"
* Use `target/dir/bin/to_erl /tmp/erlang_rel` to attach the erlang emulator 

## Upgrade
* Genetate upgrade tar by `./rel.sh upgrade from/app/root/dir to/app/root/dir`
* Copy the generated tar file to `/usr/local/erlang_rel/releases/`
* Attach to the erlang emulator by `target/dir/bin/to_erl /tmp/erlang_rel` 
* Unpack by `release_handler:unpack_release("Tar_file_without_ext").`
* List releases by `release_handler:which_releases().`
* Install release by `release_handler:install_release("Vsn").`
* Make permanent by `release_handler:make_permanent("Vsn").`
* Or do it on Release Web Console `https://<domain.name>:<port>/release`
