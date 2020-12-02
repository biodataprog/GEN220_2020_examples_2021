#!/usr/bin/bash
#SBATCH -p short -N 1 -n 8 --mem 32gb --out logs/unmapped_asm_classify.%a.log

module load diamond/2.0.4
module load minimap2
MEM=32
UNMAPPEDASM=unmapped_asm
OUTSEARCH=unmapped_asm_blast
DB=/bigdata/stajichlab/shared/lib/funannotate_db/uniprot.dmnd
VIRALDB=/bigdata/stajichlab/shared/lib/Viral/RefSeq/2020_11_07/viral.protein.dmnd
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
  if [ ! -f $OUTSEARCH/$STRAIN.uniprot.diamond.tsv ]; then
    diamond blastx --db $DB -q $UNMAPPEDASM/$STRAIN/scaffolds.fasta --out $OUTSEARCH/$STRAIN.uniprot.diamond.tsv \
  -f 6 -b12 -c1 --memory-limit $MEM --ultra-sensitive --long-reads
  fi
  if [ ! -f $OUTSEARCH/$STRAIN.RefGenome.paf ]; then
    minimap2 $REFGENOME $UNMAPPEDASM/$STRAIN/scaffolds.fasta --cs=long > $OUTSEARCH/$STRAIN.RefGenome.paf
  fi
  if [ ! -f $OUTSEARCH/$STRAIN.Viral.diamond.tsv ]; then
	  diamond blastx --db $VIRALDB -q $UNMAPPEDASM/$STRAIN/scaffolds.fasta --out $OUTSEARCH/$STRAIN.Viral.diamond.tsv -f 6 -b12 -c1 --memory-limit $MEM --ultra-sensitive --long-reads
  fi
done
