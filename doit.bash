#! /bin/bash

# ------------------------------------------------------------------------

# exit on error
set -e

if [ "$PVSE" ] ; then
    # In order to help test portability, I eliminate all of my
    # personalizations from the PATH.
    export PATH=/usr/local/bin:/usr/bin:/bin
fi

# ------------------------------------------------------------------------

# Process the config file

THIS_DIR=$(dirname $BASH_SOURCE)
CONFIG_SCRIPT=$THIS_DIR/config.bash
if [ ! -e "$CONFIG_SCRIPT" ] ; then
    echo 1>&2 Cannot find "$CONFIG_SCRIPT"
    exit 1
fi

INPUTS=""

function notice_sequence_file {
    INPUTS+=" $*"
}

. "$CONFIG_SCRIPT"

# ------------------------------------------------------------------------

# Set the variables that were not set in the config file

[ "$ROOT_DIR" ] || ROOT_DIR=$(./scripts/find-closest-ancester-dir $THIS_DIR $INPUTS)
if [ -z "$USE_NATIVE" ] ; then
    # use docker
    [ "$HOWTO" ] || HOWTO="./scripts/howto -f howto.yaml -m $ROOT_DIR"
    [ "$THREADS" ] || THREADS=$(./scripts/howto -q -c fastqc nproc)
else
    # go native
    HOWTO=
    THREADS=$(nproc)
fi

# ------------------------------------------------------------------------

# The actual computation starts here

(
    set -x
    cd $THIS_DIR
    rm -rf results
    mkdir results
)

for f in $INPUTS ; do
    (
	set -x
	$HOWTO fastqc -t $THREADS -o results $f
    )
done


