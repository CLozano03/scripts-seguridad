BEGIN {
	cuenta_relativa_esp["A"]=0.1253
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

	total_letras=0

}
{
	#Cuento la frecuencia absoluta de cada letra
	split(toupper($0),letras,"")
	for (i=1; i <= length(letras); i++){
		cuenta[letras[i]]+=1
		total_letras+=1
	}	
}
END{
	for (cada_caracter in cuenta){
		cada_cuenta=cuenta[cada_caracter]
		numerador_parcial=cada_cuenta*(cada_cuenta-1)
		ic_numerador+=numerador_parcial
	}
	ic=ic_numerador/(total_letras*(total_letras-1))
	print ic
}
