# Short Read Example

This demonstrates how to make links to existing files on system (from folder `/bigdata/gen220/shared/data/S_enterica/`)

See this recording of the run as well
https://asciinema.org/a/diFwogEQ0yEIAAmPDuGwbzyl1

The script `00_make_index.sh` is used to create links and index the genome.

The genome is called S_enterica_CT18.fasta -- there are 3 SRA datasets downloaded for this species which represent re-sequencing of isolates.

The strains sequenced are:
* [SRR10574912](https://www.ncbi.nlm.nih.gov/sra/SRR10574912) -- strain name FSIS11926304 [BioSample](https://www.ncbi.nlm.nih.gov/biosample/SAMN13447773)
* [SRR10574913](https://www.ncbi.nlm.nih.gov/sra/SRR10574913) -- strain name FSIS11926298 [BioSample](https://www.ncbi.nlm.nih.gov/biosample/SAMN13447767)
* [SRR10574914](https://www.ncbi.nlm.nih.gov/sra/SRR10574914) -- strain name FSIS11926205 [BioSample](https://www.ncbi.nlm.nih.gov/biosample/SAMN13447765)

you can run this by typing

* `sbatch 00_make_links.sh` - wait till finished, monitor with `squeue -u $USER`.
    * if you are running on a non UCR HPCC system see [download.sh](https://github.com/biodataprog/GEN220_2020_examples/blob/main/Short_read/download.sh) which will download the datasets for you.

* `sbatch 01_align.sh`  - this will run each library one at a time, will take a while since it runs each one individually

* `sbatch -a 1-3 01_align_arrayjobs.sh` - this will run the 3 array jobs - will take 1/3 as long as the step above, it is preferred way of using cluster to split jobs but you do need to understand how to code up job commands


