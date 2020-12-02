#!/usr/bin/bash

#SBATCH --mem=24gb --ntasks 32 --nodes 1
#SBATCH --time=2:00:00 -p short
#SBATCH -J maketree --out logs/make_tree.log


CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

if [[ -f config.txt ]]; then
    source config.txt
else
    echo "Need a config.txt"
    exit
fi

if [[ -z $REFNAME ]]; then
    REFNAME=REF
fi
module load parallel
module load bcftools/1.11
module load samtools/1.11
module load IQ-TREE/2.1.1
module load fasttree

print_fas() {
    printf ">%s\n%s\n" $1 $(bcftools view -e 'AF=1' $2 | bcftools query -e 'INFO/AF < 0.1' -s $1 -f '[%TGT]')
}

export -f print_fas
mkdir -p $TREEDIR
for TYPE in SNP 
do
    root=$FINALVCF/$PREFIX.$TYPE.combined_selected
    FAS=$TREEDIR/$PREFIX.$TYPE.mfa

    if [ -f $root.vcf ]; then
	bgzip $root.vcf
	tabix $root.vcf.gz
    fi
    vcf=$root.vcf.gz
    printf ">%s\n%s\n" $REFNAME $(bcftools view -e 'AF=1' ${vcf} | bcftools query -e 'INFO/AF < 0.1' -f '%REF') > $FAS
    parallel -j $CPU print_fas ::: $(bcftools query -l ${vcf}) ::: $vcf >> $FAS

    perl -ip -e 'if(/^>/){s/[\(\)#]/_/g; s/_+/_/g } else {s/[\*.]/-/g }' $FAS

    FastTreeMP -gtr -gamma -nt < $FAS > $TREEDIR/$PREFIX.$TYPE.fasttree.tre
    #iqtree2 -m GTR+ASC -s $FAS -nt 2
done
