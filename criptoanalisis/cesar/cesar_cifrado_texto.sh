#!/bin/bash
# $1: archivo de entrada
# $2: archivo de salida
# $3: clave

#-------------ALGUNAS TRADUCCIONES DE TEXTOS-------------
#printf "Áá" | sed -e 'y/áÁ/aA'
#printf "Algo secreto. " sed  -e 's[^A-Z]//g'
#-printf "Algo secreto. " | tr '[:lower:]' '[:upper:]' | sed -e 's/[^A-Z]//g'
#print "ALgo secreto "

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
texto_cifrar=$(tr -d '[:space:]' < "$archivo_entrada" | tr '[:lower:]' '[:upper:]')

#------------------------PROCESO DE CIFRADO CESAR------------------------
# Se asume que es un texto en ingles (no contiene la letra 'enie')
# La longitud del alfabeto sera de 26 caracteres
N=26

cifrado_cesar(){
    texto_entrada=$1
    clave=$2
    texto_cifrado=""

    for ((i = 0; i < ${#texto_entrada}; i++)); do

        # Extraigo el numero ascii del caracter del texto
        caracter_ascii=$(printf "%d\n" "'${texto_entrada:$i:1}")
        # Aplicacion formula de cifrado cesar
        caracter_cifrado_ascii=$((($caracter_ascii - 65 + $clave) % "$N" + 65)) 
        
        # Guardo el caracter cifrado (lo paso primero a octal)
        caracter_cifrado=$(printf "\\$(printf '%03o' $caracter_cifrado_ascii)")

        # Añado al texto cifrado
        texto_cifrado+=$caracter_cifrado
    done

    echo $texto_cifrado > $archivo_salida
}

cifrado_cesar $texto_cifrar $clave

#Imprimir los resultados
printf "El texto preprocesado es:\t%s\n" "$texto_entrada"
printf "Con clave:\t%s\n" "$clave"