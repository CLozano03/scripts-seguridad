openssl genrsa -out private.pem 1024
openssl rsa -in private.pem -text -noout

#Generacion clave public y privada

openssl rsa -in private.pem -out public.pem
openssl rsautl -encrypt -pubin -inkey public.pem -in secreto.txt -out secreto_cifrado.txt


openssl rand 128 > secreto.bin
#openssl rand 128 > secreto.bin
openssl rsautl -encrypt -pubin -inkey public.pem -in secreto.bin -out secreto_cifrado.bin 
# No se puede cifrar porque tiene muchos bytes (con 117 si se puede)
