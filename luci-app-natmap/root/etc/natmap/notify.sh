#!/bin/sh

SECTION_NAME="$NATMAP_SECTION_NAME"
PUBLIC_IPV4="$1"
PUBLIC_PORT="$2"
NATMAP_ARGS="$@"

if [ -z "$SECTION_NAME" ] || [ -z "$PUBLIC_IPV4" ] || [ -z "$PUBLIC_PORT" ]; then
    exit 1
fi

STATUS_DIR="/tmp/natmap_status"
echo "${PUBLIC_IPV4}:${PUBLIC_PORT}" > "${STATUS_DIR}/${SECTION_NAME}"

USER_COMMAND=$(uci get natmap."$SECTION_NAME".notify_command || true)

if [ -z "$USER_COMMAND" ]; then
    exit 0
fi

USER_SCRIPT_PATH=$(echo "$USER_COMMAND" | awk '{print $1}')

execute_user_command() {
    eval "$USER_COMMAND" "$NATMAP_ARGS"
}

wait_and_execute_in_background() {
    (
        logger -t natmap-notify "Waiting for script ${USER_SCRIPT_PATH} to appear for instance ${SECTION_NAME}..."
        while [ ! -f "$USER_SCRIPT_PATH" ]; do
            sleep 5
        done

        logger -t natmap-notify "Script ${USER_SCRIPT_PATH} found. Executing for instance ${SECTION_NAME}."
        execute_user_command
    ) &
}

if echo "$USER_SCRIPT_PATH" | grep -q '/'; then
    if [ -f "$USER_SCRIPT_PATH" ]; then
        execute_user_command
    else
        wait_and_execute_in_background
    fi
else
    execute_user_command
fi

exit 0
