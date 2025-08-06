#!/bin/sh

SECTION_NAME="$NATMAP_SECTION_NAME"

PUBLIC_IPV4="$1"
PUBLIC_PORT="$2"

if [ -z "$SECTION_NAME" ] || [ -z "$PUBLIC_IPV4" ] || [ -z "$PUBLIC_PORT" ]; then
    exit 1
fi

STATUS_DIR="/tmp/natmap_status"
echo "${PUBLIC_IPV4}:${PUBLIC_PORT}" > "${STATUS_DIR}/${SECTION_NAME}"

USER_COMMAND=$(uci get natmap."$SECTION_NAME".notify_command || true)

if [ -n "$USER_COMMAND" ]; then
    eval "$USER_COMMAND" "$@"
fi