#!/usr/bin/bash
#SBATCH -p batch -N 1 -n 8 --mem 24gb --out logs/assemble_unmapped.%a.log

module load SPAdes/3.14.1
MEM=24
$UNMAPPEDASM=unmapped_asm
$UNMAPPED=unmapped
if [ -f config.txt ]; then
  source config.txt
fi

CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
N=${SLURM_ARRAY_TASK_ID}
if [ -z $N ]; then
  N=$1
fi
if [ -z $N ]; then
  echo "cannot run without a number provided either cmdline or --array in sbatch"
  exit
fi


MAX=$(wc -l $SAMPFILE | awk '{print $1}')
if [ $N -gt $MAX ]; then
  echo "$N is too big, only $MAX lines in $SAMPFILE"
  exit
fi

IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read FILEBASE STRAIN BioSample Center Experiment Project Organism
do
  UMAP=$UNMAPPED/${STRAIN}.$FASTQEXT
  UMAPSINGLE=$UNMAPPED/${STRAIN}_single.$FASTQEXT
  if [[ ! -s $UMAP && ! -s $UMAPSINGLE ]]; then
    echo "Need unmapped FASTQ file, skipping $STRAIN ($FILEBASE)"
  else
    spades.py --pe-12 1 $UMAP --pe-s 1 $UMAPSINGLE -o $UNMAPPEDASM/$STRAIN -t $CPU -m $MEM --careful
  fi
done
