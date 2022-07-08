#!/bin/bash

openssl genrsa -des3 -passout pass:password -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key -out ca.cert.pem -passin pass:password