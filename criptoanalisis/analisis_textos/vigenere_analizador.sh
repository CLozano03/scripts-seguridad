#!/bin/bash

periodo_maximo=10
texto_cifrado=$(cat "$1")
ic_espanol=0.0744
ic_buff=0
ic_medio=0
ic_minimo=1000
clave=0

for (( posible_periodo = 1; posible_periodo <= $periodo_maximo; posible_periodo++ )); do
    ic_medio=0
    n_secuencias="$posible_periodo"
    #n_grupos=$(( ${#texto_cifrado} / $n_secuencias ))
    #len_grupos=$(( ${#texto_cifrado} / $n_grupos ))
    # echo "grupos $n_grupos"
    # echo "grupos $len_grupos"

    declare -a secuencias
    for (( i_cada_secuencia = 0 ; i_cada_secuencia < $n_secuencias; i_cada_secuencia++ )); do 
        secuencia=""
        for (( j = 0; j < ${#texto_cifrado}; j += n_secuencias )); do
            secuencia="${secuencia}${texto_cifrado:$j:1}"
        done
        ic_buff=$(echo "$secuencia" | awk -f ic.awk)
        ic_buff=$(echo "$ic_buff" | tr ',' '.' | bc -l) # Cambio la coma por punto
        ic_medio=$(echo "$ic_medio + $ic_buff" | bc -l)
    
        secuencias[$i_cada_secuencia]="$secuencia"
    done

    ic_medio=$(echo "$ic_medio / $n_secuencias" | bc -l)
    ic_medio=$(echo "$ic_medio" | tr ',' '.') # Cambio la coma por punto

    ic_medio=$(echo "if ($ic_espanol > $ic_medio) $ic_espanol - $ic_medio else $ic_medio - $ic_espanol" | bc -l)

    # if (( $(echo "$numero < 0" | bc -l) )); then
    #     continue
    # fi
    
    if (( $(echo "$ic_medio < $ic_minimo" | bc -l) )); then
        ic_minimo="$ic_medio"
        periodo="$posible_periodo"
    fi

done

echo "El posible periodo es: $periodo"

exit 1;

N=26
distancia=1000
clave=0
texto_descifrado_def=""

#------------------------PROCESO DE DESCIFRADO CESAR------------------------
#$1 texto a descifrar
#$2 posible clave
descifrado_cesar(){
    texto_entrada=$1
    clave=$2
    texto_descifrado=""

    for ((i = 0; i < ${#texto_entrada}; i++)); do

        # Extraigo el numero ascii del caracter del texto
        caracter_ascii=$(printf "%d\n" "'${texto_entrada:$i:1}")
        # Aplicacion formula de cifrado cesar
        caracter_descifrado_ascii=$((($caracter_ascii - 65 +"$N" - $clave) % "$N" + 65)) 
        
        # Guardo el caracter cifrado (lo paso primero a octal)
        caracter_descifrado=$(printf "\\$(printf '%03o' $caracter_descifrado_ascii)")

        # Añado al texto cifrado
        texto_descifrado+=$caracter_descifrado
    done

    echo $texto_descifrado
}


for ((posible_clave=0; posible_clave<"$N"; posible_clave++)); do
    
    texto_descifrado=$(descifrado_cesar $texto_descifrar $posible_clave)

    #------------------------PROCESO DE ANALISIS------------------------
    distancia_buff=$(echo $texto_descifrado | awk -f xi_cuadrado.awk)
    distancia_buff=$(echo "$distancia_buff" | tr ',' '.') # Cambio la coma por punto

    if [ "$(echo "$distancia_buff < $distancia" | bc -l)" -eq 1 ]; then
        distancia=$distancia_buff
        clave=$posible_clave
        texto_descifrado_def=$texto_descifrado
    fi
done

echo "El texto descifrado es: $texto_descifrado_def"
echo "La clave es: $clave"