#!/usr/bin/bash
module load samtools/1.9
module load bwa/0.7.17
module load picard
if [ -f config.txt ]; then
	source config.txt
fi
mkdir -p $FASTQFOLDER $GENOMEFOLDER
pushd $GENOMEFOLDER 
# THIS IS EXAMPLE CODE FOR HOW TO DOWNLOAD DIRECT FROM FUNGIDB
RELEASE=49
SPECIES=AfumigatusAf293
URL=https://fungidb.org/common/downloads/release-${RELEASE}/$SPECIES
PREF=FungiDB-${RELEASE}_${SPECIES}
FASTAFILE=${PREF}_Genome.fasta
DOMAINFILE=${PREF}_InterproDomains.txt
GFF=${PREF}.gff
## THIS IS FUNGIDB DOWNLOAD PART
echo "working off $FASTAFILE - check if these don't match may need to update config/init script"

if [ ! -f $DOMAINFILE ]; then
	curl -O $URL/txt/$DOMAINFILE
fi
if [ ! -f $FASTAFILE ] ; then
	curl -O $URL/fasta/data/$FASTAFILE
fi
if [ ! -f $GFF ]; then
	curl -O $URL/gff/data/$GFF
fi

if [[ ! -f $FASTAFILE.fai || $FASTAFILE -nt $FASTAFILE.fai ]]; then
	samtools faidx $FASTAFILE
fi
if [[ ! -f $FASTAFILE.bwt || $FASTAFILE -nt $FASTAFILE.bwt ]]; then
	bwa index $FASTAFILE
fi

DICT=$(basename $FASTAFILE .fasta)".dict"

if [[ ! -f $DICT || $FASTAFILE -nt $DICT ]]; then
	rm -f $DICT
	picard CreateSequenceDictionary R=$FASTAFILE O=$DICT
	ln -s $DICT $FASTAFILE.dict 
fi

popd
module load sratoolkit
IFS=,
tail -n +2 $SAMPFILE | while read STRAIN SRA
do
	echo $STRAIN $SRA
	if [ ! -f $FASTQFOLDER/${SRA}_1.$FASTQEXT ]; then
		fastq-dump -O $FASTQFOLDER --split-e --gzip $SRA 
	fi
done
