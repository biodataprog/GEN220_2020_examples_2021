#!/usr/bin/env python

import csv, sys

tabfile=""

if len (sys.argv) > 1:
    tabfile=sys.argv[1]
else:
    print("Need an input bcf table file")
    sys.exit(0)

gapcount = {}
snp_total = 0
with open(tabfile,"r") as snptable:
    snpparse = csv.reader(snptable,delimiter="\t")
    header=[]
    isheader = True
    for row in snpparse:
        if isheader:
            header = row

        i = 0        
        for col in row:
            if i > 6:
                if isheader:
                    gapcount[header[i]] = 0
                elif col == ".":
                    gapcount[header[i]] += 1
            i += 1        
        if isheader: # done with header as it is the first line
            isheader = False
        else:
            snp_total += 1
        if (snp_total % 1000) == 0:
            print(snp_total, "snps processed")

with open("strain_gaps_report.txt","w") as report:
    for strain in gapcount:
        report.write("%s\n" % ( "\t".join([strain,gapcount[strain],
                                "%.2f%%" %(100 * gapcount[strain]/ snp_total)])))
