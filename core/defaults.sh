#!/bin/echo "Do not run this directly"
# vim: ts=4:sts=4:sw=4:expandtab

function haxby::core::defaults {
    [[ -z "$HAXBY_TMP" ]] && HAXBY_TMP=/tmp/haxby

    [[ -z "$HAXBY_DATABASE_D" ]] && HAXBY_DATABASE_D=$HAXBY_CONF_DIR/databases
    [[ -z "$HAXBY_DATA" ]] && HAXBY_DATA=$HAXBY_CONF_DIR/pg

    if [[ -z "$HAXBY_SAFEMODE" ]]
    then
        [[ ! -d "$HAXBY_TMP" ]] && mkdir $HAXBY_TMP
        [[ ! -d "$HAXBY_DATA" ]] && mkdir $HAXBY_DATA
    fi

    INSTALL_DIR="$HAXBY_DATA/install"
    INSTALL_PROFILE_DIR="$INSTALL_DIR/profile.d"
    if [[ -e "$INSTALL_PROFILE_DIR" ]]; then
        files=$(ls $INSTALL_PROFILE_DIR)
        for profile in $files
        do
            source $INSTALL_PROFILE_DIR/$profile
        done
    fi

    if [[ -z "$HAXBY_SCHEMA_VERSION_QUERY" ]]; then
      HAXBY_SCHEMA_VERSION_QUERY="SELECT MAX(version) FROM app.schema_version;"
    fi

    [[ -z "$PG_CONTRIB" ]] && PG_CONTRIB=$(pg_config --sharedir)/contrib
    [[ -z "$PGDATA" ]] && PGDATA=$HAXBY_DATA/pgdata
    [[ -z "$PGLOG" ]] && PGLOG=$HAXBY_DATA/pglog

    [[ -z "$PG_LISTEN" ]] && PG_LISTEN="''"
    [[ -z "$PG_PORT" ]] && PG_PORT=5432
    [[ -z "$PG_SOCKET_DIR" ]] && PG_SOCKET_DIR=$HAXBY_DATA
    [[ -z "$PG_DEFAULT_DATABASE" ]] && PG_DEFAULT_DATABASE=

    # Set options for psql to use
    export PGDATABASE=$PG_DEFAULT_DATABASE
    export PGHOST=$PG_SOCKET_DIR
    export PGPORT=$PG_PORT

    # Export options for initdb/pg_ctl to use
    export PG_CONTRIB
    export PGDATA
    export PGLOG
}

