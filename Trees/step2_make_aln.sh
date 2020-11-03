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

QUERY=MET12.fa
BASE=$(basename $QUERY .fa)
BLASTOUTPUT=${BASE}_vs_db.BLASTP

cut -f2 $BLASTOUTPUT | uniq | cdbyank all_db.fasta.cidx > $BASE.hit_seqs.fasta

muscle -in $BASE.hit_seqs.fasta -out $BASE.hit_seqs.fasaln
muscle -in $BASE.hit_seqs.fasta -out $BASE.hit_seqs.aln -clw

trimal -in $BASE.hit_seqs.fasaln -out $BASE.hit_seqs.trim -automated1
trimal -in $BASE.hit_seqs.fasaln -out $BASE.hit_seqs.trim_aln -automated1 -clustal

FastTree -gamma < $BASE.hit_seqs.trim > $BASE.hit_seqs.tre

