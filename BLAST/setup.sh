#!/usr/bin/bash
ln -s /bigdata/gen220/shared/data/*.fasta .

module load ncbi-blast

makeblastdb -dbtype nucl -in C_glabrata_CBS138_current_orf_coding.fasta  -parse_seqids
