#!/bin/bash

: ${TEST:=0}
: ${TEST_LINE:=test@testko.com}

log_error() {
    echo >> "$LOG" "=============="
    echo >> "$LOG" Failed: "$@"
    echo >> "$LOG" "=============="
}

json_escape() {
    echo -n "$@" | jq -Rr '@json'
}

push() {
    line="$1";
    username="${line%@*}"
    domain="${line##*@}"
    name="${domain%.*}"
    password="$(gpg -d "$line")"
    if [ $? -ne 0 ]; then
        log_error GPG "$line"
        return
    fi

    jq="$(cat <<EOF
    . + {
        name:$(json_escape $name),
        notes:$(json_escape $line),
        "login":{
            "username":$(json_escape $username),
            "password":$(json_escape $password),
            "uris":[
                {
                    "match":0,
                    "uri":$(json_escape https://$domain)
                }
            ]
        },
    }
EOF
    )"

    bw get template item | jq "$jq" | bw encode | bw create item 2> >(tee -a "$LOG" >&2)
    if [ $? -ne 0 ]; then
        log_error bitwarden "$line"
    fi
}


export GPG_TTY=$(tty)

if [ "$TEST" -eq 1 ]; then
    LOG=/dev/stderr
    set -x
    push "$TEST_LINE"
else
    LOG=/tmp/bitwarden.log
    rm -f "$LOG"
    ls -1 | while IFS=$'\n' read -r line; do
        push "$line"
    done
fi

