#!/bin/bash






# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).


if [ "$#" -ne 3]; then
    echo "Uso: $0 <directorio_muestras> <directorio_salida_muestras> <id_muestras>"
    exit 1
fi

# Asigna argumentos a variables
directorio_muestras=$1
directorio_salida_muestras=$2
id_muestras=$3

# Verificar si el directorio de muestras existe
if [ ! -d "$directorio_muestras" ]; then
    echo "Error: El directorio de muestras '$directorio_muestras' no existe."
    exit 1
fi


# Crea el directorio de salida si no existe
mkdir -p "$directorio_salida_muestras"
echo "creando dir"


#Fusionar todos los archivos del mismo sample en un solo archivo

zcat "$directorio_muestras"/"$id_muestras"*.fastq.gz > "$directorio_salida_muestras"/"$id_muestras".fastq

gzip "$directorio_salida_muestras"/"$id_muestras".fastq




