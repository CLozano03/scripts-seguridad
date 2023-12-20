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
clave=$(echo "$3" | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

# Leer el archivo y eliminar espacios y convertir a mayúsculas
texto_cifrar=$(tr -d '[:space:]' < "$archivo_entrada" | tr '[:lower:]' '[:upper:]')


#------------------------PROCESO DE CIFRADO VIGENIERE------------------------
# Se asume que es un texto en ingles (no contiene la letra 'enie')
# La longitud del alfabeto sera de 26 caracteres
N=26

# Cifrado_vigeniere Aplica el algoritmo de cifrado a un texto dado con clave dada
# Returnea la clave derivada
# $1: texto a cifrar
# $2: clave de cifrado
cifrado_vigeniere(){
    texto_entrada=$1
    clave=$2
    clave_derivada=""
    len_clave=${#clave}
    texto_cifrado=""

    # Itero a traves del texto dado
    for ((i = 0; i < ${#texto_entrada}; i++)); do
        posicion_clave=$(($i % $len_clave))
        clave_derivada+="${clave:$posicion_clave:1}"
        clave_ascii=$(printf "%d\n" "'${clave:$posicion_clave:1}")
        #Obtengo el desplazamiento correspondiente al caracter ASCII
        desp_ascii=$(($clave_ascii-65)) 

        # Extraigo el numero ascii del caracter del texto
        caracter_ascii=$(printf "%d\n" "'${texto_entrada:$i:1}")

        # Aplicacion formula de cifrado vigeniere
        caracter_cifrado_ascii=$((($caracter_ascii -65 + $desp_ascii) % $N + 65 ))

        # Guardo el caracter cifrado (lo paso primero a octal)
        caracter_cifrado=$(printf "\\$(printf '%03o' $caracter_cifrado_ascii)")
        texto_cifrado+=$caracter_cifrado
    done
    
    echo $texto_cifrado > $archivo_salida
    echo $clave_derivada #Returneo de la clave derivada
}

#Llamada a funcion
clave_derivada=$(cifrado_vigeniere $texto_cifrar $clave)

#Imprimir los resultados
printf "El texto preprocesado es:\t%s\n" "$texto_cifrar"
printf "La clave preprocesada es:\t%s\n" "$clave"
printf "La clave derivada es:\t\t%s\n" "$clave_derivada" 

exit 0;