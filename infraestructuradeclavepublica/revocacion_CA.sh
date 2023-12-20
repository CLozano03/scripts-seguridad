#!/bin/bash

# Revocación de certificado de CA intermedia
openssl ca -config ac_intermedia/openssl.cnf -revoke ac_intermedia/certs/02.pem

openssl crl -in ac_intermedia/crl/ac_intermedia.crl -text

#ssl es el antiguo nombre de tls