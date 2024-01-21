#!/bin/bash

# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.

# STAR --runThreadN 4 --runMode genomeGenerate --genomeDir <outdir> \
# --genomeFastaFiles <genomefile> --genomeSAindexNbases 9

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <archivo_genoma> <directorio_salida>"
    exit 1
fi

# Asigna argumentos a variables
archivo_genoma=$1
directorio_salida=$2

# Verifica si el archivo de genoma existe
if [ ! -f "$archivo_genoma" ]; then
    echo "Error: El archivo de genoma '$archivo_genoma' no existe."
    exit 1
fi

# Verifica si directorio_salida tiene un valor válido
if [ -z "$directorio_salida" ]; then
    echo "Error: La variable directorio_salida está vacía."
    exit 1
fi

# Crear el directorio de salida si no existe
mkdir -p "$directorio_salida"

# Comando STAR para generar el índice del genoma
STAR --runThreadN 4 --runMode genomeGenerate --genomeDir "$directorio_salida" \
--genomeFastaFiles "$archivo_genoma" --genomeSAindexNbases 9



