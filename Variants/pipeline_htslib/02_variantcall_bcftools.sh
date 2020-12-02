#!/usr/bin/bash
#SBATCH -p batch -N 1 -n 8 --mem 16gb --out logs/variant_call.log
if [ -f config.txt ]; then
  source config.txt
fi
if [ -z $REFGENOME ]; then
  echo "NEED A REFGENOME - set in config.txt and make sure 00_index.sh is run"
  exit
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

IFS=,
tail -n +2 $SAMPFILE | while read STRAIN SRA
do
	  m="$ALNFOLDER/$STRAIN.$HTCEXT "
done
VCF=$FINALVCF/$PREFIX.htslib.vcf.gz
VCFFILTER=$FINALVCF/$PREFIX.htslib.filter.vcf.gz
VCFPREF=$FINALVCF/$PREFIX.htslib
bcftools mpileup -Ou -f $REFGENOME $m | bcftools call -vmO z -o $VCF
tabix -p vcf $VCF
bcftools stats -F $GENOME -s - $VCF > $FINALVCF/$PREFIX.htslib.stats
mkdir -p plots
plot-vcfstats -p plots/ $FINALVCF/$PREFIX.htslib.stats
bcftools filter -O z -o $VCFFILTER -s LOWQUAL -i'%QUAL>10' $VCF
