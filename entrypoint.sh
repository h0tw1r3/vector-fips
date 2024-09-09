#!/bin/sh

export OPENSSL_CONF=/etc/ssl/openssl.cnf
export OPENSSL_MODULES=/usr/lib/ossl-modules

echo 'OPENSSL PROVIDERS'
openssl list -providers

echo 'OPENSSL ALL ALGORITHMS'
openssl list -all-algorithms

cd /etc/vector/ssl && ./make_cert.sh
RUST_BACKTRACE=full timeout 10s /usr/local/bin/vector -vvv $*
