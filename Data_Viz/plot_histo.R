
pdf("plotting_length_histogram.pdf")
# setwd("/bigdata/stajichlab/jstajich/teaching/GEN220/GEN220_2020_examples/Data_Viz/folder2")
gsnap_exon = read.table("gsnap_exon_frags.tab.gz",sep="\t",header=T)
head(gsnap_exon)
summary(gsnap_exon)
summary(gsnap_exon$Length)
mean(gsnap_exon$Length)
# draw a histogram
hist(gsnap_exon$Length,100)

# how many exons are there
length(gsnap_exon$Geneid)
# lets removed exons > 5kb
smallest_5k <- subset(gsnap_exon, gsnap_exon$Length < 5000 )
summary(smallest_5k)
length(smallest_5k$Geneid)
# plot histogram
hist(smallest_5k$Length,100)

# plot histogram of log transformed
hist(log( smallest_5k$Length)/log(10),100,main="Log transformed")
