# this script will print out some histograms and plots of SNP counts across genes

genesnpcount = read.table("gene_snp_count.txt")
head(genesnpcount)
summary(genesnpcount)

pdf("histograms.pdf")
hist(genesnpcount$V1)
hist(genesnpcount$V1,100)
boxplot(genesnpcount$V1)
