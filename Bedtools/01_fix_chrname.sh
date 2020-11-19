#!/usr/bin/bash

sed 's/^Chr6/6/' rice_chr6.gff > rice_chr6.fixed_Chr.gff

sed 's/^6/Chr6/' rice_chr6_3kSNPs_filt.bed > rice_chr6_3kSNPs_filt.added_Chr.bed
