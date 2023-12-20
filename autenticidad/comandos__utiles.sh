#!/bin/bash

#Genera con algoritmo rsa una clave publica 
openssl rsa -pubout -in clave_privada.pem -out clave_publica.pem

# -pubin: Esta opción le indica a openssl que la entrada es una clave pública en lugar de una clave privada. En este caso, se está procesando una clave pública que se encuentra en el archivo clave_publica.pem.
# -in clave_publica.pem: Con esta opción, estás especificando que el archivo de entrada es clave_publica.pem, que contiene la clave pública en formato PEM.
# -text: Esta opción indica a openssl que muestre información textual detallada sobre la clave pública. Esto incluirá detalles como el módulo (n), el exponente público (e), el formato de codificación y otros detalles relacionados con la clave.
# -noout: Esta opción le dice a openssl que no muestre la clave en sí, es decir, que no muestre la clave pública en formato PEM, sino solo la información detallada que se muestra con -text.
openssl rsa -pubin -in clave_publica.pem -text -noout

# rsautl: Este es el subcomando que se utiliza para realizar operaciones de cifrado RSA. En este caso, se está utilizando para cifrar un mensaje.
#-encrypt: Esta opción le indica a rsautl que se realice una operación de cifrado. En otras palabras, se utilizará la clave pública para cifrar el mensaje proporcionado.
openssl rsautl -encrypt -pubin -inkey clave_publica.pem

#genrsa genera una clave privada RSA de 1024 bits. Esta clave privada se almacena en el archivo clave_privada.pem.
openssl genrsa -out clave_privada.pem 1024

# rsautl: Este es el subcomando de OpenSSL utilizado para operaciones de cifrado y descifrado RSA.
# -encrypt: Esta opción indica que se realizará una operación de cifrado utilizando RSA.
openssl rsautl -encrypt -pubin -inkey clave_publica.pem -in tux.bin -out tux_cifrado.bin

#Generacion de claves ECC
openssl genpkey -paramfile ec_parametros.pem -out ec_clave_privada_B.pem
openssl pkey -pubout -in ec_clave_privada_B.pem -out ec_clave_publica_B.pem
openssl pkeyutl -derive -inkey ec_clave_privada.pem -peerkey ec_clave_publica_B.pem -out material_clave.bin

#
openssl req -new -x509 -newkey rsa -keyout cakey.pem -out cacert.pem -days 365
openssl ecparam -name prime256v1 -genkey -noout -out tsa.key
openssl req -new -key tsa.key -out tsa.crs -days 3650