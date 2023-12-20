#!/bin/bash

# Ruta al filtro de Bloom
filtro="$1"
# Clave a evaluar en el filtro de Bloom
clave="$2"

# Defimos la capacidad 
capacidad=100

# Cálculo de hashes y verificación en el filtro de Bloom
numero_hashes=5  # n funciones hash = registrar.sh 
funciones_hash=("md5" "sha1" "sha256" "sha512" "ripemd160")  # Funciones de hash 

modulos=()
for ((iter=1; iter<=numero_hashes; iter++)); do
  resumen=$(echo -n "$clave" | openssl dgst -"${funciones_hash[$iter-1]}" -binary | xxd -p | tr -d " \t\n\r")
  resumen_decimal=$(echo "ibase=16; $resumen" | bc)
  modulo_resumen=$(echo "$resumen_decimal%$capacidad" | bc)
  modulos+=" $modulo_resumen"
done

# Determinar si la clave puede estar almacenada o no en el filtro de Bloom
encontrada=true
for cada_modulo in ${modulos[@]}; do
  #verificamos  si cada_modulo está en el filtro
  # Si alguno de los módulos no está -> encontrada=false y salir del bucle
  if ! grep -q "$cada_modulo" "$filtro"; then
    encontrada=false
    break
  fi
done

if [ "$encontrada" = true ]; then
  echo "La clave puede estar almacenada."
else
  echo "La clave no está almacenada."
fi