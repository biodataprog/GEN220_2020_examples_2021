#!/usr/bin/bash
module load bedtools

bedtools intersect -a rice_chr6.fixed_Chr.gff -b rice_chr6_3kSNPs_filt.bed -wo > snp_gene_intersect.tab

# how many features have SNPS?
cut -f3 snp_gene_intersect.tab | sort | uniq -c

# how many SNPs does each gene have?

grep -E "\tgene\t"  snp_gene_intersect.tab > snp_gene_intersect.genes_only.tab
# this outputs gene SNP counts ordered by genename which is actually chromosome
# position nicely
cut -f9 snp_gene_intersect.genes_only.tab | sed 's/^ID=//; s/;Name=.*//' | sort | uniq -c > gene_snp_count.txt

# which genes have the most snps?
sort -nr gene_snp_count.txt > gene_snps_count.by_number.txt
