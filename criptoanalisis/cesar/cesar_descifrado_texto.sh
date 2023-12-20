#!/bin/bash
# $1: archivo de entrada
# $2: archivo de salida
# $3: clave

archivo_entrada="$1"
if [ ! -f "$archivo_entrada" ]; then
    echo "Error, no existe el archivo $archivo_entrada"
    exit 1;
fi

# Se crea el archivo de salida, en caso de que exista se elimina
archivo_salida="$2"
if [ -f "$archivo_salida" ]; then
    echo "Atencion: Se borra un archivo que existia: $archivo_salida"
    rm $archivo_salida
fi
touch $archivo_salida

# Validar existencia de clave
if [ -z "$3" ]; then 
    echo "Error: Clave sin indicar."
    exit 1;
fi
# Preprocesado de clave
clave=$3

# Leer el archivo y eliminar espacios y convertir a mayúsculas
texto_descifrar=$(tr -d '[:space:]' < "$archivo_entrada" | tr '[:lower:]' '[:upper:]')

#------------------------PROCESO DE DESCIFRADO CESAR------------------------
# Se asume que es un texto en ingles (no contiene la letra 'enie')
# La longitud del alfabeto sera de 26 caracteres
N=26

descifrado_cesar(){
    texto_entrada=$1
    clave=$2
    texto_descifrado=""

    for ((i = 0; i < ${#texto_entrada}; i++)); do

        # Extraigo el numero ascii del caracter del texto
        caracter_ascii=$(printf "%d\n" "'${texto_entrada:$i:1}")
        # Aplicacion formula de cifrado cesar
        caracter_descifrado_ascii=$((($caracter_ascii - 65 + "$N" - $clave) % "$N" + 65)) 
        
        # Guardo el caracter cifrado (lo paso primero a octal)
        caracter_descifrado=$(printf "\\$(printf '%03o' $caracter_descifrado_ascii)")

        # Añado al texto cifrado
        texto_descifrado+=$caracter_descifrado
    done

    echo $texto_descifrado > $archivo_salida
}

descifrado_cesar $texto_descifrar $clave

#Imprimir los resultados
printf "El texto    cifrado (entrada) es:\t%s\n" "$texto_entrada"
printf "Con clave:\t%s\n" "$clave"