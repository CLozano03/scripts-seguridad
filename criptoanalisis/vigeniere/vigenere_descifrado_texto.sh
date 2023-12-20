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

texto_descifrar=$(cat $archivo_entrada)

#--------------------------DESCIFRADO--------------------------
N=26
# descrifrado Aplica el algoritmo inverso al de cifrado
# Returnea el texto descifrado
# 1: texto cifrado
# 2: clave de cifrado
descifrado(){
    texto_cifrado=$1
    clave=$2
    len_clave=${#clave}
    texto_descifrado=""

    # Itero a traves del texto dado
    for ((i = 0; i < ${#texto_cifrado}; i++)); do
        posicion_clave=$(($i % $len_clave))
        clave_ascii=$(printf "%d\n" "'${clave:$posicion_clave:1}")
        #Obtengo el desplazamiento correspondiente al caracter ASCII
        desp_ascii=$(($clave_ascii-65)) 

        # Extraigo el numero ascii del caracter del texto
        caracter_ascii=$(printf "%d\n" "'${texto_cifrado:$i:1}")

        # Aplicacion formula inversa de cifrado
        caracter_descifrado_ascii=$((($caracter_ascii + $N - 65 - $desp_ascii) % $N + 65 ))

        # Guardo el caracter descifrado (lo paso primero a octal)
        caracter_descifrado=$(printf "\\$(printf '%03o' $caracter_descifrado_ascii)")
        texto_descifrado+=$caracter_descifrado
    done
    
    echo $texto_descifrado > $archivo_salida
}

descifrado $texto_descifrar $clave