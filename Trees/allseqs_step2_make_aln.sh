#!/usr/bin/bash
#SBATCH --nodes 1 --ntasks 2 --mem 2G

module load cdbfasta
module load muscle
module load trimal
module load fasttree

# run indexing if database is not indexed
if [ ! -f all_db.fasta.cidx ]; then 
	cdbfasta all_db.fasta
fi

for file in $(ls gene_groups/*.txt)
do
 name=$(basename $file .txt)
 echo "name $name"
 cat $file | cdbyank all_db.fasta.cidx > gene_groups/$name.fasta
 muscle -in gene_groups/$name.fasta -out gene_groups/$name.fasaln
 trimal -in gene_groups/$name.fasaln -out gene_groups/$name.trim -automated1
 FastTree -gamma < gene_groups/$name.trim > gene_groups/$name.tre
done
