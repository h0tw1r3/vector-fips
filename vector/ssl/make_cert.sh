#!/bin/sh

if [ ! -s ca.key ] || [ ! -s ca.crt ] ; then
    openssl genrsa -aes256 -passout pass:password123 -out ca.key 4096
    openssl req -x509 \
        -passin pass:password123 \
        -new \
        -addext basicConstraints=critical,CA:TRUE,pathlen:1 \
        -outform pem \
        -key ca.key -out ca.crt \
        -sha256 \
        -days 365 \
        -subj "/CN=rootca" \
        -set_serial '0x1001'
fi

for cert in server; do
    openssl genrsa -aes256 -passout pass:password123 -out ${cert}.key 4096
    openssl req -new -key ${cert}.key -out ${cert}.csr -subj "/CN=${cert}" -passin pass:password123
    openssl x509 -req -in ${cert}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ${cert}.crt -days 3650 -sha256 -passin pass:password123
done
