#!/bin/bash

openssl genrsa -des3 -passout pass:password -out client.key 4096
openssl req -new -key client.key -out client.csr -passin pass:password

openssl rsa -in client.key -out client.key.insecure -passin pass:password

openssl x509 -req -in client.csr -passin pass:password -CA ./ca.cert.pem -CAkey ./ca.key -out client.cert.pem -CAcreateserial -days 9999 -sha256 -extfile rje_cert_ext.cnf