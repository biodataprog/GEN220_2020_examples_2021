#!/usr/bin/bash
#SBATCH -p short -N 1 -n 4 --mem 8gb --out make_links.log

module load bwa
module load samtools

# make a link
FOLDER=/bigdata/gen220/shared/data/S_enterica/
GENOME=S_enterica_CT18.fasta
if [ ! -s $GENOME ]; then
	# make a symlink
	ln -s $FOLDER/$GENOMEFILE .
fi

if [ ! -f $GENOME.pac ]; then
	bwa index $GENOME
fi
ACC="SRR10574912 SRR10574913 SRR10574914"
for acc in $ACC;
do
	echo "$acc"
	if [ ! -s ${acc}_1.fastq.gz ]; then
		ln -s $FOLDER/${acc}_[12].fastq.gz .
	fi
done
