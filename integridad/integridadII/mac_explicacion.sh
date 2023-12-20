#!/bin/bash

openssl rand 32 > clavesecreta.bin
echo "Algo secreto" > secreto.txt
openssl dgst  -sha256 -mac -hmac -macopt hexkey:"ABCD1234" secreto.txt