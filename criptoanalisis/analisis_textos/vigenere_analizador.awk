BEGIN {
	¡cuenta_relativa_esp["A"]=0.1253
	cuenta_relativa_esp["B"]=0.0142
	cuenta_relativa_esp["C"]=0.0468
	cuenta_relativa_esp["D"]=0.0586
	cuenta_relativa_esp["E"]=0.1368
	cuenta_relativa_esp["F"]=0.0069
	cuenta_relativa_esp["G"]=0.0101
	cuenta_relativa_esp["H"]=0.0070
	cuenta_relativa_esp["I"]=0.0625
	cuenta_relativa_esp["J"]=0.0044
	cuenta_relativa_esp["K"]=0.0002
	cuenta_relativa_esp["L"]=0.0497
	cuenta_relativa_esp["M"]=0.0315
	cuenta_relativa_esp["N"]=0.0671
	cuenta_relativa_esp["?"]=0.0031
	cuenta_relativa_esp["O"]=0.0868
	cuenta_relativa_esp["P"]=0.0251
	cuenta_relativa_esp["Q"]=0.0088
	cuenta_relativa_esp["R"]=0.0687
	cuenta_relativa_esp["S"]=0.0798
	cuenta_relativa_esp["T"]=0.0463
	cuenta_relativa_esp["U"]=0.0393
	cuenta_relativa_esp["V"]=0.0090
	cuenta_relativa_esp["W"]=0.0001
	cuenta_relativa_esp["X"]=0.0022
	cuenta_relativa_esp["Y"]=0.0090
	cuenta_relativa_esp["Z"]=0.0052

	for (n=0;n<256;n++) {
		tabla_ascii[sprintf("%c",n)]=n
		tabla_ascii_caracteres[n]=sprintf("%c",n)
	}

	distancia=0
	total_letras=0
	periodo_max=20
	periodo_clave=0
	

}
{
	# Texto en español (incluye la Ñ)
	N=27
	# Se asume que el texto está en mayúsculas y no contiene espacios,
	# Se asume que la clave es de longitud menor o igual a 20

	# Función para calcular el índice de coincidencia
	function calcIC(texto) {
		len = length(texto)
		sum = 0
		for (i = 1; i <= 26; i++) {
			count = gsub(sprintf("%c", i + 64), "", texto)
			sum += count * (count - 1)
		}
		return sum / (len * (len - 1))
	}

	
	# Primero contamos la frecuencia de las letras
	split(toupper($0),cifrado,"")
	# for (i=1; i <= length(cifrado); i++){
	# 	cuenta[letras[i]]+=1
	# 	total_letras+=1
	# }

	ic_maximo = -1
	# Calcular el IC promedio para cada posible longitud de clave
	# Nos quedamos con el mayor, que es el que tiene mayor probabilidad de ser el correcto
	for(t = 1; t <= longitud_max; t++) {
		ic_numerador = 0
		# Dividir el texto en t subtextos
		for(i=1; i <= len(cifrado); i++) {
			clases[i%t]+=letras[i]
		}

		# Calcular el IC de cada subtexto
		for (i = 1; i <= t; i++) {
			ic[i] = calcIC(clases[i])
			ic_numerador += ic[i]
		}

		# Calcular el IC promedio
		ic_promedio = ic_numerador / t

		if(ic_promedio > ic_maximo) {
			ic_maximo = ic_promedio
			periodo_clave = t
		}
	}

	### En este punto ya sabemos cual es el posible periodo de la clave
	# Hacemos la prueba xi cuadrado

	for(i = 0; i < periodo_clave; i++){
		# Dividir el texto en t subtextos
		for(j = 0; j < length(cifrado); j++) {
			clases[j%periodo_clave]+=letras[j]
		}
		
		# Calcular la frecuencia de cada letra en cada subtexto
		for(j = 0; j < periodo_clave; j++) {
			for(k = 0; k < length(clases[j]); k++) {
				cuenta[clases[j][k]]+=1
				total_letras+=1
			}
		}

		# Para cada posible cesar en cada clase, descifro el texto y calculo la distancia xi cuadrado
		for(i = 1; i <= N; i++){
			# Descifrar el texto
			for(j = 0; j < length(clases[i]); j++) {
				# Obtener el caracter en ascii
				ascii = tabla_ascii[clases[i][j]]
				# Obtener el caracter descifrado
				ascii_descifrado = (ascii - i) % N
				# Obtener el caracter descifrado en ascii
				caracter_descifrado = tabla_ascii_caracteres[ascii_descifrado]
				# Reemplazar el caracter cifrado por el descifrado
				descifrado_clases[i][j] = caracter_descifrado
			}
		}
	}
	
	for (caracter_esp in cuenta_relativa_esp) {
        if (caracter_esp in cuenta){
            cada_cuenta=cuenta[caracter_esp]
            cada_cuenta_esp=cuenta_relativa_esp[caracter_esp]*total_letras
            
			#Formula de distancia chi cuadrado
			distancia_parcial=((cada_cuenta - cada_cuenta_esp)(cada_cuenta - cada_cuenta_esp)/cada_cuenta_esp)
            distancia+=distancia_parcial
        }
    }
	
	
	# Calcular el índice de coincidencia para cada posible longitud de clave
	for (len = 1; len <= len_clave; len++) {
		sumIC = 0
		for (i = 1; i <= len; i++) {
			subtexto = ""
			for (j = i; j <= length(texto); j += len) {
				subtexto = sprintf("%s%c", subtexto, substr(texto, j, 1))
			}
			sumIC += calcIC(subtexto)
		}
		avgIC = sumIC / len
		printf("Longitud de clave: %d, IC promedio: %.4f\n", len, avgIC)
	}

}
END {}