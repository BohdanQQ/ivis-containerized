#!/bin/bash

openssl genrsa -des3 -passout pass:password -out server.key 4096
openssl req -new -key server.key -out server.csr -passin pass:password

openssl rsa -in server.key -out server.key.insecure -passin pass:password

openssl x509 -req -in server.csr -passin pass:password -CA ./ca.cert.pem -CAkey ./ca.key -out server.cert.pem -CAcreateserial -days 9999 -sha256 -extfile server_cert_ext.cnf