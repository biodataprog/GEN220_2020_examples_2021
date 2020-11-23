#!/usr/bin/bash
#SBATCH -p short -N 1 -n 8 --mem 8gb --out align.%a.log

module load bwa
module load samtools
CPU=8
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
N=${SLURM_ARRAY_TASK_ID}
if [ -z $N ]; then
  N=$1
fi

# make a link
GENOME=S_enterica_CT18.fasta
ACCFILE=acc.txt
sed -n ${N}p $ACCFILE | while read acc;
do
	if [ ! -f ${acc}.arrayjobs.fixmate.bam ]; then
		bwa mem -t $CPU $GENOME ${acc}_[12].fastq.gz  > ${acc}.arrayjobs.sam
		samtools fixmate --threads $CPU -O bam ${acc}.arrayjobs.sam ${acc}.arrayjobs.fixmate.bam
	fi
	if [ ! -f ${acc}.arrayjobs.bam ]; then
		samtools sort -O bam --threads $CPU -o ${acc}.arrayjobs.bam ${acc}.arrayjobs.fixmate.bam
	fi
	if [ ! -f ${acc}.arrayjobs.stats.txt ]; then
		samtools flagstat ${acc}.arrayjobs.bam > ${acc}.arrayjobs.stats.txt
	fi	
done
