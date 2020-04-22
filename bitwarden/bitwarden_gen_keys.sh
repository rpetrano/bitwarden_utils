#!/bin/bash

# By default bitwarden creates 2048 bit keys. This bumbs up to 4096 bits.
# This obviously overwrites the old keys. Don't do it.

cd /var/lib/bitwarden_rs/data
rm rsa_key.*

openssl genrsa -out rsa_key.pem 4096
openssl rsa -in rsa_key.pem -outform DER -out rsa_key.der
openssl rsa -in rsa_key.der -inform DER -RSAPublicKey_out -outform DER -out rsa_key.pub.der

chown bitwarden_rs. rsa_key.*
chmod 400 rsa_key.*
chmod 440 rsa_key.pub.der

# After you made admin changes, contains admin key and SMTP settings
chmod 400 config.json

# Contains all the passwords :)
chmod 600 db.sqlite3
