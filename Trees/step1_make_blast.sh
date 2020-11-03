#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 2 --mem 2G

module load ncbi-blast
# run indexing if database is not indexed
if [ ! -f all_db.fasta.psq ]; then 
	makeblastdb -in all_db.fasta -dbtype prot
fi

QUERY=MET12.fa
BASE=$(basename $QUERY .fa)
OUTPUT=${BASE}_vs_db.BLASTP

blastp -query $QUERY -db all_db.fasta -evalue 1e-20 -out $OUTPUT -outfmt 6
