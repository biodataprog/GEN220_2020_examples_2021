#!/usr/bin/bash
#SBATCH -p short -N 1 -n 1 --mem 2gb


Rscript plot_coverage.R
