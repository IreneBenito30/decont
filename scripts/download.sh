#!/bin/bash

# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output

#Vericación de que se proporcionan cuatro argumentos

if [ "$#" -ne 4 ]; then
    echo "ERROR ponle 4 argumentos"
    exit 1
fi

# Asigna los argumentos a variables
url=$1
directorio=$2
descomprimir=$3
filtro=$4



#Crea un directorio con el nombre recibido por el argumento , sino existe 
mkdir -p $directorio

#Descarga del url indicado por el argumento 
wget -P $directorio $url


#con esto estas guardando en la variable archivo el nombre del archivo que se ha descargado
archivo=$(basename $url)


#Se comprueba si se quiere descomprimir o no

if [ "$descomprimir" = "yes" ]; then
    # En el caso que se diga "yes"


gunzip $directorio/$archivo 



else
    # En el caso que se diga "no"

echo "no se descomprime"

fi


#filtro 

if [ "$filtro" = "another" ]; then

    # lo que pasa si recibe "another"
echo "filtrando"

else
# Aquí puedes colocar el código para la acción correspondiente a "no"

echo "no se filtra"

fi





