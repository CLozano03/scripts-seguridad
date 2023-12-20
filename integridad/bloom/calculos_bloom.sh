#!/bin/bash

capacidad="$1"
p_error="$2"

# $0 coge toda la linea de la entrada de awk
longitud=$(echo "-(($capacidad*l($p_error))/(l(2)^2))" | bc -l | awk 'function ceil(x, y){y=int(x); return(x>y?y+1:y)} {print ceil($0)}')
numero_resumenes=$(echo "($longitud/$capacidad)*l(2)" | bc -l | awk 'function ceil(x, y){y=int(x); return(x>y?y+1:y)} {print ceil($0)}')

echo "Longitud de los resumenes: $longitud"
echo "Numero de resumenes: $numero_resumenes"