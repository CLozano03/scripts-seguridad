#!/bin/bash

# Ruta al filtro de Bloom
filtro="$1"
# Clave a registrar en el filtro de Bloom
clave="$2"

# Cálculo de hashes y registros en el filtro de Bloom
numero_hashes=5  # Número de funciones de hash 
funciones_hash=("md5" "sha1" "sha256" "sha512" "ripemd160")  # Funciones de hash random

modulos=()
for ((iter=1; iter<=numero_hashes; iter++)); do
  resumen=$(echo "$clave" | openssl dgst -"${funciones_hash[$iter-1]}" -binary | xxd -p | tr -d " \t\n\r")
  resumen_decimal=$(echo "ibase=16; $resumen" | bc)
  modulo_resumen=$(echo "$resumen_decimal%$capacidad" | bc)
  modulos+=" $modulo_resumen"
done

# Registrar en el archivo del filtro de Bloom
for cada_modulo in ${modulos[@]}; do
  # Aquí se supone que hay que escribir el valor de cada_modulo en el archivo del filtro -> ni puta idea 
  echo "$cada_modulo" >> "$filtro"  
done

echo "Clave registrada: $clave"