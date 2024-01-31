#!/bin/bash
# Comprobación de que se proporcionan los argumentos necesarios

if [ "$#" -ne 2 ]; then
    echo "Usage : $0 <list_of_urls> <contaminants_url>"
    exit 1
fi

echo "comprobacion de argumentos correcta" >> ~/decont/log/pipeline.log


# ./scripts/pipeline.sh /home/vant/decont/data/urls  https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz




# Este script recibe 2 argumentos que los guardamos en las siguientes variables
list_of_urls=$(cat $1)
contaminants_url=$2




# Descargar todos los archivos especificados en list_of_urls
for url in $list_of_urls; do
    bash scripts/download.sh $url ~/decont/data no another
done

echo "descarga de urls" >> ~/decont/log/pipeline.log

# Descargar el archivo fasta de contaminantes, descomprimirlo y filtrar pequeñas RNA nucleares
echo "Descargando la base de datos de contaminantes y filtrando pequeñas RNA nucleares..." >> ~/decont/log/pipeline.log

bash scripts/download.sh $contaminants_url ~/decont/res yes another
bash scripts/download.sh $contaminants_url ~/decont/res no another


echo "Descarga de base de datos de contaminantes" >> ~/decont/log/pipeline.log


bash scripts/index.sh ~/decont/res/contaminants.fasta ~/decont/res/contaminants_idx

echo "indexacion completada" >> ~/decont/log/pipeline.log



# Fusionar las muestras en un solo archivo
list_of_sample_ids=$(ls data/*-12.5dpp*.gz | awk -F '-12' '{print $1}' | sed 's|data/||')



mkdir -p ~/decont/out/merged

for sid in $list_of_sample_ids; do
    echo "Fusionando archivos de la muestra $sid..."
    bash scripts/merge_fastqs.sh ~/decont/data ~/decont/out/merged $sid
done

echo "Fusion de archivos completada" >> ~/decont/log/pipeline.log




# Ejecutar cutadapt y STAR para todos los archivos fusionados y recopilar información de logs
mkdir -p ~/decont/out/trimmed
mkdir -p ~/decont/log/cutadapt
mkdir -p ~/decont/out/star






# TODO: run cutadapt for all merged files

for sid in $list_of_sample_ids; do
    cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
        -o ~/decont/out/trimmed/"$sid".trimmed.fastq.gz \
        ~/decont/out/merged/"$sid".fastq.gz \
        > ~/decont/log/cutadapt/"$sid".log
done

echo "cutadapt completado" >> ~/decont/log/pipeline.log


# TODO: run STAR for all trimmed files


for fname in out/trimmed/*.fastq.gz
do
    # you will need to obtain the sample ID from the filename

    base=$(basename  "$fname" )

    sid=${base%%.*}



    echo "el sid es $sid y el fname $fname"


     mkdir -p out/star/$sid



    STAR --runThreadN 4 --genomeDir res/contaminants_idx \
       --outReadsUnmapped Fastx --readFilesIn ~/decont/out/trimmed/"$sid".trimmed.fastq.gz \
        --readFilesCommand gunzip -c --outFileNamePrefix "out/star/$sid/"
done 


echo "ejecucion de STAR completada" >> ~/decont/log/pipeline.log



echo "Pipeline completado exitosamente." >> ~/decont/log/pipeline.log





# Crear un archivo de log con información de cutadapt y STAR
echo "Creando archivo de log general..."
cutadapt_logs=$(cat ~/decont/log/cutadapt/*.log | grep "Reads with adapters" | grep "Total basepairs")
star_logs=$(cat ~/decont/out/star/*/Log.final.out | grep -E "Uniquely mapped reads %|Number of reads mapped to multiple loci %|Number of reads mapped to too many loci %")

echo -e "Cutadapt Logs:\n$cutadapt_logs\n\nSTAR Logs:\n$star_logs" > ~/decont/log/pipeline.log

echo "Pipeline completado exitosamente."

