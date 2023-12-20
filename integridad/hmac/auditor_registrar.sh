#!/bin/bash

# Genera clave aleatoria de 32 bits (deberia ser en realidad pasada por un archivo)
clave=$(cat "$1")

# Configurar
directorio=$(pwd)

archivo_salida_objetos="auditor_objetos.txt"
if [ -f "$archivo_salida_objetos" ]; then
    echo "Atencion: Se borra un archivo que existia."
    rm $archivo_salida_objetos
fi
touch $archivo_salida_objetos

archivo_salida_nombres="auditor_nombres.txt"

if [ -f "$archivo_salida_nombres" ]; then
    echo "Atencion: Se borra un archivo que existia."
    rm $archivo_salida_nombres
fi
touch $archivo_salida_nombres

find $directorio -maxdepth 1 -type f > $archivo_salida_objetos

while IFS= read -r linea; do #en linea se guardara /home/archivo y el archivo q se puede leer
# el ifs es sobre el comando read q significa q el archivo no termine en coma, espacio..

#damos nombre unico al archivo cifrado (que esta en linea) -> me generara un numero
    archivo_mac=$(openssl dgst -sha1 "$linea" | awk '{print $2}')
    echo "$archivo_mac" >> "$archivo_salida_nombres"

    if [ -f "$archivo_mac" ]; then   #verificamos q el archivo exista
        echo "Atencion: Se borra un arhcivo que exisitía."
        rm "$archivo_mac"
    fi
    #archivo_mac=$(cat "$directorio" "$archivo_mac") ASI NO
    touch "$archivo_mac"
    
    (openssl dgst -sha256 -mac hmac -macopt hexkey:$(echo $clave | xxd -p | tr '[:lower:]' '[:upper:]' | tr -d '\n') $linea | awk '{print $2}') >> "$archivo_mac"
done < "$archivo_salida_objetos" #va a volcar todo el archivo en la variable linea
   
