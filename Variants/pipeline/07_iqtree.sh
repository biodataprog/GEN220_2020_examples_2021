#!/usr/bin/bash
#SBATCH -p intel -N 1 -n 6 --mem 16gb  --out logs/IQTREE2.log

module load IQ-TREE/2.1.1

source config.txt
cd strain_tree
iqtree2 -s $PREFIX.SNP.mfa -m GTR+ASC -nt AUTO -B 1000



