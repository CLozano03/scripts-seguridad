#!/bin/bash

# Generar clave privada y clave publica
openssl genpkey -algorithm RSA -out clave_privada_unica.pem
openssl genpkey pkey -pubout -in clave_privada_unica.pem -out clave_publica_unica.pem

# Generar certificado digital
openssl req -new -key clave_privada_unica.pem -out certificado_unico.csr

# Para ver lo que hay dentro
openssl req -in certificado_unico.csr -text