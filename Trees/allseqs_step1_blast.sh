#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 16 --mem 4G -p short

module load ncbi-blast

# run indexing if database is not indexed
if [ ! -f all_db.fasta.psq ]; then 
	makeblastdb -in all_db.fasta -dbtype prot
fi

QUERY=databases/S_cere_proteins.aa.fasta
OUTPUT=S_cere_all_blast.BLASTP

blastp -query $QUERY -db all_db.fasta -evalue 1e-20 -out $OUTPUT -outfmt 6 -num_threads 16
