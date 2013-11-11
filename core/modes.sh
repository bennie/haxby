#!/bin/echo "Do not run this directly"
# vim: ts=4:sts=4:sw=4:expandtab

function haxby::core::modes::register {
    if [[ -n "$HAXBY_MODES" ]]
    then
        HAXBY_MODES="$HAXBY_MODES $*"
    else
        HAXBY_MODES="$*"
    fi
}

function haxby::core::modes::register_safemode {
    if [[ -n "$HAXBY_SAFE_MODES" ]]
    then
        HAXBY_SAFE_MODES="$HAXBY_SAFE_MODES $*"
    else
        HAXBY_SAFE_MODES="$*"
    fi
}

# Load the modes in the current mode directory
function haxby::core::modes::load-modes {
    for mode_file in $HAXBY_MODE_DIR/*.sh
    do
        . $mode_file
    done
}

# Use the root mode directory
function haxby::core::modes::use-root-mode-dir {
    HAXBY_MODE_DIR=$HAXBY_ROOT/modes
    HAXBY_MODE_DIR=$(readlink -f "$HAXBY_MODE_DIR")
    HAXBY_MODES=

    haxby::core::modes::load-modes
}

# Use a directory of submodes
# 1. The directory's name, relative to the current mode directory
function haxby::core::modes::use-mode-dir {
    mode_name=$1
    HAXBY_MODE_DIR=$HAXBY_MODE_DIR/$mode_name
    HAXBY_MODE_DIR=$(readlink -f "$HAXBY_MODE_DIR")
    HAXBY_MODES=

    haxby::core::modes::load-modes
}

# Run a mode
function haxby::core::modes::run {
    mode=$1
    namespace=$HAXBY_MODE_NAMESPACE
    shift 1 || true
    if [[ -n "$HAXBY_SAFEMODE" ]]
    then
        HAXBY_MODES="$HAXBY_SAFE_MODES"
    fi
    for haxby_mode in $HAXBY_MODES
    do
        if [[ "$haxby_mode" == "$mode" ]]
        then
            $namespace::$mode "$@"
            exit $?
        fi
    done

    echo "Unknown Mode"
    haxby::modes::help
    exit 1
}

# Generic mode-with-submodes implementation
function haxby::core::modes::run-with-submodes {
    mode=$1
    submode=$2
    shift 2 || true
    (
        HAXBY_MODE_NAMESPACE="haxby::modes::$mode"
        haxby::core::modes::use-mode-dir "$mode"
        haxby::core::modes::run "$submode" "$@"
    )
}

