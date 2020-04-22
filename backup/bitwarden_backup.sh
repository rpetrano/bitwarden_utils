#!/bin/bash

: ${BACKUP_DIR:=/root/bitwarden_backup}
: ${DATA_DIR:=/var/lib/bitwarden_rs/data}
: ${USER:=bitwarden_rs}
: ${GROUP:=bitwarden_rs}
: ${FORMAT:=%Y-%m-%d-%H-%M-%S.sqlite3}
: ${UMASK:=0277}
: ${ROTATE:=3}

set -eo pipefail

if [ ! -d "$BACKUP_DIR" ]; then
    install -d -o "$USER" -g "$GROUP" "$BACKUP_DIR"
fi

name="$(date +"$FORMAT")"
umask $UMASK
sudo -u "$USER" -g "$GROUP" sqlite3 "$DATA_DIR/db.sqlite3" ".backup '$BACKUP_DIR/$name'"


# rotate backups
find "$BACKUP_DIR/" -type f | sort -nr | tail +$(( $ROTATE+1 )) | while IFS=$'\n' read -r file; do
    rm "$file"
done
