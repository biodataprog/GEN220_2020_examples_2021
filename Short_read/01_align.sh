#!/usr/bin/bash
#SBATCH -p batch -N 1 -n 16 --mem 8gb --out align.log

module load bwa
module load samtools
CPU=16

# make a link
GENOME=S_enterica_CT18.fasta

ACC="SRR10574912 SRR10574913 SRR10574914"
for acc in $ACC;
do
	if [ ! -s ${acc}.fixmate.bam ]; then
		bwa mem -t $CPU $GENOME ${acc}_[12].fastq.gz > $acc.sam
		samtools fixmate --threads $CPU -O bam $acc.sam ${acc}.fixmate.bam
	fi
	if [ ! -s ${acc}.bam ]; then
		samtools sort -O bam --threads $CPU -o ${acc}.bam ${acc}.fixmate.bam
	fi
	if [ -f ${acc}.bam ]; then
		samtools flagstat ${acc}.bam > ${acc}.stats.txt
	fi
done
