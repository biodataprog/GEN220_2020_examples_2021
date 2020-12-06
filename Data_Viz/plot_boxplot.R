
library(ggplot2)
library(tidyverse)
library(RColorBrewer)
library(viridis)
pdf("boxplot.pdf")
# setwd("/bigdata/stajichlab/jstajich/teaching/GEN220/GEN220_2020_examples/Data_Viz/folder2")
gsnap_exon = read.table("gsnap_exon_frags.tab.gz",sep="\t",header=T)
# draw a histogram
hist(gsnap_exon$Length,100)

ggplot(gsnap_exon, aes(x=Strand, y=Length, fill=Strand)) +
    geom_boxplot() +
    scale_fill_viridis(discrete = TRUE, alpha=0.6) +
    geom_jitter(color="black", size=0.4, alpha=0.9) +
    theme_bw() +
    theme(
      legend.position="none",
      plot.title = element_text(size=11)
    ) +
    ggtitle("A boxplot of exon lengths with jitter") 

smallest_5k <- subset(gsnap_exon, gsnap_exon$Length < 5000 )

ggplot(smallest_5k, aes(x=Strand, y=Length, fill=Strand)) +
    geom_boxplot() +
    scale_fill_viridis(discrete = TRUE, alpha=0.6) +
    geom_jitter(color="black", size=0.4, alpha=0.9) +
    theme_bw() +
    theme(
      legend.position="none",
      plot.title = element_text(size=11)
    ) +
    ggtitle("A boxplot of exon_length with jitter < 5kb")

# tidyverse to filter data

smallest_3k = gsnap_exon %>% filter(Length < 3000)
ggplot(smallest_3k, aes(x=Strand, y=Length, fill=Strand)) +
    geom_boxplot() +
    scale_fill_viridis(discrete = TRUE, alpha=0.6) +
    geom_jitter(color="black", size=0.4, alpha=0.9) +
    theme_bw() +
    theme(
      legend.position="none",
      plot.title = element_text(size=11)
    ) +
    ggtitle("A boxplot exon length with jitter < 3kb")


ggplot(smallest_5k, aes(x=Strand, y=log(Length)/log(10), fill=Strand)) +
    geom_boxplot() +
    scale_fill_viridis(discrete = TRUE, alpha=0.6) +
    geom_jitter(color="black", size=0.4, alpha=0.9) +
    theme_bw() +
    theme(
      legend.position="none",
      plot.title = element_text(size=11)
    ) +
    ggtitle("A boxplot exon length with jitter < 5kb (log_10 of length)")

# plot histogram of log transformed
hist(log( smallest_5k$Length)/log(10),100,main="Log transformed")
