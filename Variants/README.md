# PopGenomics template
See https://github.com/stajichlab/PopGenomics_template/

Template for Population Genomics variant calling in simple BASH + Slurm environment. Best use is to fork this as a template.

Alternative pipelines will be to bring in the snakemake implementation.

This pipeline uses slurm arrayjobs to split up work across the cluster.
There are 2 dimensions to think about, one is splitting across each strain/sample, the other is a separate job per chromosome (or chunks of chromosome)A

A `logs` file is already created as part of this template to support storing of log files run and to keep files organized

Files that need to be updated
 - samples.csv - this is a list of samples, the first line is a header and will be skipped by the job.
 - config.txt  - there are several customization of the species run and data formats (we use CRAM as alignment storage default instead of BAM)
    * There is a PREFIX variable in config.txt which can be used to set the prefix of all output names, change this as you update your datasets so you can generate new results without overwriting old when generating combined VCF files.  Generally the scripts try to not re-run an analysis by checking if an output file already exists. So if you need to re-do an analysis remove files in the vcf, gvcf, or cram/aln folders.


# Steps
These are analysis pipeline steps intended to be run on slurm queueing system. The software is configured on the UCR HPCC system with UNIX modules. However any setup with existing conda install.

## Initialization
This step only needs to be run once.

* 00_index.sh - this build index files for alignment. It also will download (example of how to download automatically from FungiDB for those sources). In order for snpEff to work in later step you need to have downloaded the genome annotation in GFF3 format as well

## Alignment and ile creation (one per strain)
* 01_align.sh - this is bwa alignment step - this is intended to run one job per strain. so if there are 10 strains in the strains.

If there are 11 lines in the file (eg 10 strains + header) you run the job with ```sbatch --array=1-10 pipeline/01_align.sh```
* 02_call_gvcf.sh - this is done after alignments are finished - for now I have separated this into a new step since it can be quite time consuming but it isn't multithreaded so this is a different job from 01_align.sh.

It is also run with one job per strain so ```sbatch --array=1-10 pipeline/02_call_gvcf.sh```

## Genotyping GVCFs
* 03_jointGVCF_call_slice.sh - this can be parallelized by running one per chrom / scaffold or for very large / fragmentend genome

Change the `GVCF_INTERVAL` to be a larger number to for example, run 5 intervals at a time. In simple terms each interval is a chromsome, so if you have a genome with 8 chromosomes you would run this as ```sbatch --array=1-8 pipeline/03_joint_GVCF_call_slices.sh```.
If the genome is in 1000 contigs, and you set `GVCF_INTERVAL=5` then, 1000/5 = 200, so run  ```sbatch --array=1-200 pipeline/03_joint_GVCF_call_slices.sh```. To determine the number of intervals you can count the number of lines in the `GENOME.fai` file in genome ```wc -l genome/*.fai``` for example.

This step will run the GATK GenotypeGVCFs step followed by splitting variants into SNP and INDELs, followed by filtering steps to do HardFiltering based on cutoffs coded in the scripts (if you find you are losing variants you think you need, I would edit this script parameters). This if followed by creating a Selected file which has only variants which pass the quality filtering.

* 04_combine_vcf.sh - this is a fast running script to gather the results from per-chrom/contig GVCF run into a single VCF file of filtered variants - the output files will be named by the PREFIX variable in the config.txt file.
* 06_make_SNP_tree.sh - this script will generate a FASTA format alignment of variants - using a parallelized approach (which requires the [GNU parallel tool](https://www.gnu.org/software/parallel/)). So a multithreaded slurm job is useful here - it will also launch a FastTree run to generate a phylogenetic tree from the alignment.
* 07_iqtree.sh - This script will generate a IQ-TREE run using the `GTR+ASC` model which is appropriate for SNP-based phylogenetic trees.
* 08_snpEff.sh - This script will generate a custom snpEff database using the GFF3 file in genome - this could be a little fragile so you may need to check that data files are download properly. This script right now has a lot A.fumigatus specific information.
The se
* 11_mosdepth.sh - Mosdepth depth-of-coverage comparison (TO FINISH WRITING DESCRIPTION)
