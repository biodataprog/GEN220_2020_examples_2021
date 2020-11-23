#!/usr/bin/bash

# if you are running this NOT on UCR HPCC you can download the data with these commands
module load bwa
curl -O https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/195/995/GCF_000195995.1_ASM19599v1/GCF_000195995.1_ASM19599v1_genomic.fna.gz
gunzip GCF_000195995.1_ASM19599v1_genomic.fna.gz
ln -s GCF_000195995.1_ASM19599v1_genomic.fna S_enterica_CT18.fasta
bwa index S_enterica_CT18.fasta

# or however else you load tools on your system
module load parallel
module load sratoolkit
parallel -j 3 fastq-dump --gzip --split-e {} ::: $(cat acc.txt)

# if the above doesn't  work
for acc in $(cat acc.txt)
do
 fastq-dump --gzip --split-e $acc
done
