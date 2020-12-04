#!/usr/bin/bash
#SBATCH --ntasks 16 --mem 8G -p short
module load ncbi-blast/2.9.0+
module load orthofinder/2.4.0
CPU=8

mkdir -p cyanobacteria
cd cyanobacteria
curl -L -O ftp://ftp.ensemblgenomes.org/pub/bacteria/release-45/fasta/bacteria_10_collection/oscillatoriales_cyanobacterium_jsc_12/pep/Oscillatoriales_cyanobacterium_jsc_12.ASM30994v1.pep.all.fa.gz
curl -L -O ftp://ftp.ensemblgenomes.org/pub/bacteria/release-45/fasta/bacteria_0_collection/nostoc_punctiforme_pcc_73102/pep/Nostoc_punctiforme_pcc_73102.ASM2002v1.pep.all.fa.gz
curl -L -O ftp://ftp.ensemblgenomes.org/pub/bacteria/release-45/fasta/bacteria_4_collection/cyanobacterium_aponinum_pcc_10605/pep/Cyanobacterium_aponinum_pcc_10605.ASM31767v1.pep.all.fa.gz

# uncompress files and name them all *.fasta
for file in *.fa.gz
do
 m=$(basename $file .pep.all.fa.gz)
 pigz -dc $file > $m.fasta
done

