#!/usr/bin/env python3

PROGRAM_VERSION = 0.1

# include standard modules
import argparse, sys, warnings, gzip, vcf, re, csv
import pandas as pd

info="This script will help map SNPs to protein domains using snpEff output and InterproScan or other domain result tables (eg from EupathDB).\n"

usage="map_snpEff2domains.py --vcf snpEff.vcf --domains IPRdomains.txt"

parser = argparse.ArgumentParser(description = info, usage = usage)

parser.add_argument("-V", "--version", help="show program version",
                    action="store_true")

parser.add_argument("--output", "-o", help="Write output to this file")
parser.add_argument("--vcf", "-v", help="snpEff VCF file")
parser.add_argument("--domains", "-d", help="Domains tab delimited table")

args = parser.parse_args()

if args.version:
    print("Version %s"%(PROGRAM_VERSION))
    sys.exit(0)

if not args.domains or not args.vcf:
    print("Expected --vcf and --domains arguments")
    print(usage)
    sys.exit(2)


domains = None
domain_cols = ['Gene','Source','Domain_acc','Domain_name',
               'Start','End','Evalue']
if args.domains.endswith(".gz"):
    domains = pd.read_csv(args.domains,compression="gzip",
                          sep='\t', comment = '#',
                          low_memory = False,header=None, names=domain_cols)
else:
    domains = pd.read_csv(args.domains,
                          sep='\t', comment = '#',
                          low_memory = False,header=None,names=domain_cols)

vcf_reader = None
if args.vcf.endswith(".gz"):
    vcf_reader = vcf.Reader(gzip.open(args.vcf, 'rt'))
else:
    vcf_reader = vcf.Reader(open(args.vcf, 'r'))

title = ["CHROM","POS","TYPE","IMPACT","GENE",
         "CHANGEDNA","CHANGEPEP","REF","ALT","AA_CHANGE_POS",
         "DOMAIN","DOMAIN_ACC","DOMAIN_START",
         "DOMAIN_END","DOMAIN_MUT_START","DOMAIN_MUT_END"]
if args.output:
    outfh = open(args.output,"wt")
else:
    outfh = sys.stdout

writer = csv.writer(outfh,delimiter="\t")
writer.writerow(title)
for record in vcf_reader:
    if 'ANN' not in record.INFO:
           sys.stderr.write("Cannot find ANN in %s\n"%(record))
           continue
    anns = record.INFO['ANN']
    arrayout = [record.CHROM,record.POS]
    annarr = anns[0].split('|')
    dnachg = re.sub("^c\.","",annarr[9])
    muttype   = annarr[1]
    impact    = annarr[2]
    gene_name = annarr[3]

    if ( annarr[1] == 'upstream_gene_variant' or
         annarr[1] == 'downstream_gene_variant' or
         annarr[1] == 'intergenic_region' or
         'splice_acceptor_variant' in annarr[1]):
        continue

    pepchg = re.sub(r'^p\.','',annarr[10])
    if len(pepchg) == 0:
        continue
    arrayout.extend((muttype,impact,gene_name,
                     dnachg,pepchg))

    arrayout.extend((record.REF,record.ALT))
    pepn = re.match(r'^(\w{2,3}|\*)(\d+)(\w{2,3}|\*)',pepchg)
    mut_aa = None
    if pepn:
        mut_aa = pepn.group(2)
        arrayout.extend(mut_aa)
        mut_aa = int(mut_aa)
    else:
        warnings.warn("Cannot find AA position match for {} {} {}".format(arrayout[0],arrayout[1],pepchg))
        continue

    genedat = domains.loc[domains['Gene'] == gene_name]

#    print(genedat)
    for index,row in genedat.iterrows():
        if int(mut_aa) >= row.Start and int(mut_aa) <= row.End:
            # overlaps
            arrayout.extend((row.Domain_name,row.Domain_acc,
                             row.Start, row.End,
                             mut_aa - row.Start + 1,
                             mut_aa - row.Start + 2))

    writer.writerow(arrayout)
