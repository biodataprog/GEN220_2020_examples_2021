#!/usr/bin/env python3

import sys
import os

blastfile = sys.argv[1]
outfolder = "gene_groups"

seq_dictionary = {}
with open(blastfile,"r") as fh:
    count = 0
    for line in fh:
        line = line.strip()
        hits = line.split("\t")
        query = hits[0]
        subject = hits[1]
        if query not in seq_dictionary:
            seq_dictionary[query] = {}

        seq_dictionary[query][subject] = 1        
#        print(seq_dictionary)
#        if count > 10:
#            break
#        count = count + 1

    for gene in seq_dictionary.keys():
        hitnames = seq_dictionary[gene].keys()
        if len(hitnames) > 2:            
            fileout = os.path.join(outfolder,"%s.txt"%(gene))
            with open(fileout,"w") as output:
                for hitgenes in seq_dictionary[gene].keys():
                    output.write(hitgenes+"\n")

# done parsing file



