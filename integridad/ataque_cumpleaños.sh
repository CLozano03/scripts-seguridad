#!/bin/bash

: '
El ataque del cumpleaños es un concepto en criptografía que explora 
la probabilidad de que, en un conjunto de elementos, dos de ellos compartan 
el mismo valor. Este ataque destaca cómo la probabilidad de encontrar colisiones
aumenta más rápido de lo esperado a medida que se generan más elementos en
un conjunto, lo que tiene implicaciones en la seguridad de algoritmos 
criptográficos y funciones hash.
'

mensaje_1="AFIRMATIVO"
mensaje_2="NEGATIVO"
truncamiento=2

iter_max=100000000

identificador_1=$(openssl rand -hex 6)
texto_1="{\"mensaje\": $mensaje_1 ; \"id\": $identificador_1}"
resumen_1=$(echo "$texto_1" | openssl dgst -sha1 -binary | xxd -p)
resumen_1_truncado=${resumen_1:0:$truncamiento}

for (( i=0 ; i<=iter_max ; i++ )); do
    identificador_2=$(openssl rand -hex 6)

    texto_2="{\"mensaje\": $mensaje_2 ; \"id\": $identificador_2}"

    resumen_2=$(echo "$texto_2" | openssl dgst -sha512 -binary | xxd -p)

    resumen_2_truncado=${resumen_2:0:$truncamiento}

    if [ $resumen_1_truncado == $resumen_2_truncado ]; then 
        printf "Encontrado:\n"
        printf "Texto 1: $texto_1\tResumen: $resumen_1\n"
        printf "Texto 2: $texto_2\tResumen: $resumen_2\n"

        printf "Iteraciones: $i\n" 
        break;
    fi
done