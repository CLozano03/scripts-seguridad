# # Texto inicial
# printf "sillas 2\nmesas 3\nsillas 5\n"

# # Imprimir el campo 2 de cada una de las lineas (numero de objetos)
# printf "sillas 2\nmesas 3\nsillas 5\n" | awk 'BEGIN{ } { print$2} END {}

# # Imprimir el campo 1 de cada una de las lineas (objeto en el inventario)
# printf "sillas 2\nmesas 3\nsillas 5\n" | awk 'BEGIN{ } { print $1} END {}

# printf "sillas 2\nmesas 3\nsillas 5\n" | awk 'BEGIN{ } { inventario[$1] = +$2} END {for cada...}

#para cada linea, va a coger la frecuencia de las letras que aparecen en la variable $0
BEGIN{
    total_letras=0
} 
{
    split(toupper($0), caracteres, "")
    for(cada_letra in caracteres){
        cuenta[caracteres[cada_letra]] += 1 
        total_letras += 1
    }


} 
END{
    for (cada_caracter in cuenta) {
        printf("%s\t%d\t%.2f\n", cada_caracter, cuenta[cada_caracter], cuenta[cada_caracter]/total_letras)
    }
}