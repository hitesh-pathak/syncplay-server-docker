#!/bin/sh
set -e

# defaults
: "${SYNCPLAY_PORT:=8999}"

ARGS="--port ${SYNCPLAY_PORT}"

[ -n "$SYNCPLAY_PASSWORD" ] && ARGS="$ARGS --password $SYNCPLAY_PASSWORD"
[ -n "$SYNCPLAY_SALT" ]     && ARGS="$ARGS --salt $SYNCPLAY_SALT"
[ -n "$SYNCPLAY_MOTD" ]     && ARGS="$ARGS --motd $SYNCPLAY_MOTD"

exec syncplay-server $ARGS