#!/bin bash/

# Genera clave aleatoria de 32 bits (deberia ser en realidad pasada por un archivo pasado como argumento)
clave=$(cat "$1")

# Configurar
directorio=$(pwd)
archivo_salida_objetos="auditor_objetos.txt"
archivo_salida_nombres="auditor_nombres.txt"

archivo_salida_validaciones="auditor_validaciones.txt"
if [ -f "$archivo_salida_validaciones" ]; then
    echo "Atencion: Se borra un archivo que existia: $archivo_salida_validaciones"
    rm $archivo_salida_validaciones
fi
touch "$archivo_salida_validaciones"

iterador=1
# Estoy abriendo $archivo_salida_objetos 
# IFS es para que lea el archivo tal cual, sin detectar los saltos de linea
while IFS= read -r linea; do #en linea se guardara /home/archivo y el archivo q se puede leer

    cada_objeto=$linea
    cada_mac_nombre=$(sed -n "${iterador}{p;q;}" "$archivo_salida_nombres")
    cada_mac=$(cat $cada_mac_nombre)
    
    cada_mac_calculado=$(openssl dgst -sha256 -mac hmac -macopt hexkey:$(echo $clave | xxd -p | tr '[:lower:]' '[:upper:]' | tr -d '\n') $cada_objeto | awk '{print $2}')
    if [[ "$cada_mac" == "$cada_mac_calculado" ]]; then
        printf "VALIDADO\t%s\n" $linea >> $archivo_salida_validaciones
    else
        printf "ALTERADO\t%s\n" $linea >> $archivo_salida_validaciones
    fi
    
    iterador=$((iterador+1))

done < $archivo_salida_objetos #va a volcar todo el archivo en la variable linea

##