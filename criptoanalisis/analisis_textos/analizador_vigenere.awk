ic_maximo=50
posible_periodo=0
texto_cifrado="IDBFSBUGBQUFBVIENGIPNEOBN"

for(( posible_periodo = 1; posible_periodo < ic_maximo; posible_periodo++)); do
    n_secuencias=$posible_periodo
    n_grupos=$((${len(texto_cifrado)}/$n_secuencias))
    len_grupos = $((${len(texto_cifrado)}/$n_grupos))

    declare -a secuencias
    for(( i_cada_secuencia = 1; i_cada_secuencia < $n_secuencias; i_cada_secuencia++)); do 
        
    done

done