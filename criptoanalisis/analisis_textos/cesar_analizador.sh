#!bin/bash
#$1

# distancia=0
#     for (cada_caracter_esp in cuenta_relativa_esp) {
#         if (cada_caracter_esp in cuenta){
#             cada_cuenta=cuenta[cada_caracter_esp]
#             cada_cuenta_esp=cuenta_relativa_esp[cada_caracter_esp]*total_letras
#             distancia_parcial=(((cada_cuenta - cada_cuenta_esp)^2)/cada_cuenta_esp)
#             distancia+=distancia_parcial
#         }
#     }

N=26
texto_descifrar=$(cat $1)
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