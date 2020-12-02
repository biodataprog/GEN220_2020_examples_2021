#!/usr/bin/env python3
import sys, warnings
import vcf,re,gzip,os
from Bio import SeqIO
# this script will convert a VCF from snpEff into a useful table
FLANK_LENGTH=10
if len(sys.argv) < 2:
        warnings.warn("Usage snpEff_to_table.py snpeff.vcf genome")
        sys.exit()
vcf_file = sys.argv[1]
newfilename = ""
vcf_reader = None
# deal with compressed files, tried to open on the fly but
# have to decompress I guess
if vcf_file.endswith("vcf.gz"):
        vcf_file_new =  vcf_file.strip(".gz")
        if not os.path.exists(vcf_file_new):
                os.system("gzip -dc %s > %s"%(vcf_file,vcf_file_new))
        newfilename = vcf_file.strip('vcf.gz')
        vcf_reader = vcf.Reader(open(vcf_file_new,"rt"))
elif vcf_file.endswith("vcf"):
        newfilename = vcf_file.strip('vcf')
        vcf_reader = vcf.Reader(open(vcf_file,"rt"))
else:
        warnings.warn("expected a .vcf file or .vcf.gz for input (%s)"%(vcf_file))
        sys.exit()

genome = "/bigdata/stajichlab/shared/projects/Afum_popgenome/variantcall/genome/FungiDB-39_AfumigatusAf293_Genome.fasta"

if len(sys.argv) > 2:
        genome = sys.argv[2]
count=0


chrs={}
for seq in SeqIO.parse(genome, "fasta"):
	chrs[seq.id] = seq.seq

for record in vcf_reader:
        if count == 0:
                sampname = []
                title = ["CHROM","POS","FLANKING","TYPE","IMPACT","GENE",
                         "CHANGEDNA","CHANGEPEP","REF","ALT"]
                for sample in record.samples:
                        title.append(str(sample.sample))
                title.append("ANN")
                print("\t".join(title))
                count = 1
        if 'ANN' not in record.INFO:
           sys.stderr.write("Cannot find ANN in %s\n"%(record))
           continue
        anns = record.INFO['ANN']
        arrayout = [record.CHROM,record.POS]
        flanking_seq = chrs[record.CHROM][record.POS-FLANK_LENGTH:record.POS+FLANK_LENGTH+1]
        arrayout.append(flanking_seq)
        annarr = anns[0].split('|')
        dnachg = re.sub("^c\.","",annarr[9])

        if ( annarr[1] == 'upstream_gene_variant' or
             annarr[1] == 'downstream_gene_variant' or
             annarr[1] == 'intergenic_region'):
                arrayout.extend(('intergenic',annarr[2],annarr[3],
                         dnachg,""))
        else:
                pepchg = re.sub('^p\.','',annarr[10])
                arrayout.extend((annarr[1],annarr[2],annarr[3],
                                 dnachg,pepchg))

        arrayout.extend((record.REF,record.ALT))
	#print arrayout
        for sample in record.samples:
                if sample.gt_bases:
                        arrayout.append(sample.gt_bases+"/")
                else:
                        arrayout.append('./')
        annarrayfinal = []
        for ann in anns:
                annarr=ann.split('|')
                readableann= "(%s,%s,%s)" % (annarr[3],annarr[0],annarr[1])
                annarrayfinal.append(readableann)
        arrayout.append(";".join(annarrayfinal))
        print('\t'.join(map(str,arrayout)))
