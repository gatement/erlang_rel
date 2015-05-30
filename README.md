# erlang_rel
erlang release test

## Setup
* `make`
* Create the first tar by `./rel.sh pack app/root/dir env`
* Install the first target system by `./rel.sh install tar/file/without/ext target/dir`
* Customize `target/dir/bin/start`
  1. Add pipe file name
  2. Add heart monitor 
  3. e.g $ROOTDIR/bin/run_erl -daemon `/tmp/erlang_rel.pipe` $ROOTDIR/log "exec $ROOTDIR/bin/start_erl $ROOTDIR $RELDIR $START_ERL_DATA `-heart -env HEART_COMMAND $ROOTDIR/bin/start`"
* Use `target/dir/bin/to_erl /tmp/erlang_rel.pipe` to attach the erlang emulator 

## Upgrade
* Update `src/erlang_rel.app.src`, `src/erlang_rel.appup`, `release.rel`
* `make`
* Generate upgrade tar by `./rel.sh upgrade from/app/root/dir to/app/root/dir env`
* Do the upgrade on Release Web Console `https://<domain.name>:<port>/release` or manually with command line:
    1. Copy the generated tar file to `target/dir/releases/`
    2. Attach to the erlang emulator by `target/dir/bin/to_erl /tmp/erlang_rel.pipe` 
    3. Unpack by `release_handler:unpack_release("Tar_file_without_ext").`
    4. List releases by `release_handler:which_releases().`
    5. Install release by `release_handler:install_release("Vsn").`
    6. Make permanent by `release_handler:make_permanent("Vsn").`
