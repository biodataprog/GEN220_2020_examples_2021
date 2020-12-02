library(ggplot2)
library(RColorBrewer)
library(tidyverse)
library(stringr)
colors1 <- colorRampPalette(brewer.pal(8, "RdYlBu"))
manualColors = c("dodgerblue2", "red1", "grey20")

alternating_colors = rep( c("red", "black"), times= 15)
Prefix = "BdenJEL423_SC0?" # fixme
mosdepthdir = "coverage/mosdepth"
chrlist = 1:9
windows = c(5000, 10000)

#scale_colour_brewer(palette = "Set3") +

plot_strain <- function(strain, data) {
	l = subset(data, data$Strain == strain)
	Title = sprintf("Chr coverage plot for %s", strain)
	p <- ggplot(l, aes(x = pos, y = Depth, color = CHR)) +
		scale_colour_manual(values = alternating_colors) +
		geom_point(alpha = 0.9, size = 0.8, shape = 16) +
		labs(title = Title,xlab = "Position", y = "Normalized Read Depth") +
		scale_x_continuous(name = "Chromosome",	expand = c(0, 0), breaks = ticks, labels = unique(l$CHR) ) +
		scale_y_continuous(name = "Normalized Read Depth",expand = c(0, 0), limits = c(0, 3)) +
		theme_classic()
		#+ guides(fill = guide_legend(keywidth = 3,keyheight = 1))
}

plot_chrs <- function(chrom, data) {
	Title = sprintf("Chr%s depth of coverage", chrom)
	l <- subset(data, data$CHR == chrom)
	l$bp <- l$Start
	p <- ggplot(l, aes(x = bp, y = Depth, color = Strain)) +
	geom_point(alpha = 0.7,	size = 0.8, shape = 16) + # scale_color_brewer(palette='RdYlBu',type='seq') +
	labs(title = Title, xlab = "Position", y = "Normalized Read Depth") +
	scale_x_continuous(expand = c(0,	0), name = "Position") +
	scale_y_continuous(name = "Normalized Read Depth", expand = c(0, 0), limits = c(0, 3)) +
	theme_classic()
	#guides(fill = guide_legend(keywidth = 3,keyheight = 1))
}

for (window in windows) {
  inpattern = sprintf(".%sbp.regions.bed.gz$", window)
  file_list <- list.files(path = mosdepthdir, pattern = inpattern)
  bedwindows <- data.frame()
  for (i in 1:length(file_list)) {
    infile = sprintf("%s/%s", mosdepthdir, file_list[i])
    strain = str_replace(file_list[i], inpattern, "")
    # fix me here?
    t = read.table(infile, header = F)
    #replace(t$Chr,t$Chr == "BdenJEL423_mito","BdenJEL423_SC70")
    t$Strain = c(strain)
		colnames(t) = c("Chr", "Start", "End", "Depth", "Strain")
		t$Depth = t$Depth / median(t$Depth)
    bedwindows <- bind_rows(bedwindows, t)
  }
  length(bedwindows)
  length(bedwindows$STRAIN)
  unique(bedwindows$STRAIN)
  colnames(bedwindows) = c("Chr", "Start", "End", "Depth", "Strain")

  bedwindows$CHR <- sub(Prefix, "", bedwindows$Chr, perl = TRUE)
	unique(bedwindows$CHR)
	#subset(bedwindows,bedwindows)
	bedwindows$CHR <- bedwindows$CHR
  d = bedwindows[bedwindows$CHR %in% chrlist, ]

  d <- d[order(as.numeric(d$CHR), d$Start), ]
  d$index = rep.int(seq_along(unique(d$CHR)), times = tapply(d$Start, d$CHR, length))

  d$pos = NA

  nchr = length(unique(chrlist))
  lastbase = 0
  ticks = NULL
  minor = vector(, 8)

  for (i in 1:nchr) {
    if (i == 1) {
      d[d$index == i, ]$pos = d[d$index == i, ]$Start
    } else {
      ## chromosome position maybe not start at 1, eg. 9999. So gaps may be produced.
      lastbase = lastbase + max(d[d$index == (i - 1), "Start"])
      minor[i] = lastbase
      d[d$index == i, "Start"] = d[d$index == i, "Start"] - min(d[d$index ==
        i, "Start"]) + 1
      d[d$index == i, "End"] = lastbase
      d[d$index == i, "pos"] = d[d$index == i, "Start"] + lastbase
    }
  }
  ticks <- tapply(d$pos, d$index, quantile, probs = 0.5)
  # ticks
  minorB <- tapply(d$End, d$index, max, probs = 0.5)
  # minorB minor
  xmax = ceiling(max(d$pos) * 1.03)
  xmin = floor(max(d$pos) * -0.03)

  #pdf(pdffile, width = 16, height = 4)
  Title = "Depth of sequence coverage"

  # scale_color_brewer(palette='RdYlBu',type='seq') +
  p <- ggplot(d, aes(x = pos, y = Depth, color = Strain)) + geom_vline(mapping = NULL,
    xintercept = minorB, alpha = 0.5, size = 0.1, colour = "grey15") +
		geom_point(alpha = 0.8, size = 0.4, shape = 16) +
  	labs(title = Title, xlab = "Position", y = "Normalized Read Depth") +
		scale_x_continuous(name = "Chromosome",  expand = c(0, 0), breaks = ticks, labels = unique(d$CHR)) +
			scale_y_continuous(name = "Normalized Read Depth",expand = c(0, 0), limits = c(0, 3)) +
			theme_classic()
#			guides(fill = guide_legend(keywidth = 3,keyheight = 1))

	pdffile = sprintf("plots/genomewide_coverage_%dkb.pdf", window/1000)
  ggsave(p,file=pdffile,width=16,height=4)

  plts <- lapply(unique(d$Strain), plot_strain, data = d)

	#ggsave(pdffile, device = "pdf",width=12)
	strains = unique(d$Strain)
	for(i in 1:length(unique(d$Strain) ) ) {
		pdffile=sprintf("plots/StrainPlot_%dkb.%s.pdf", window/1000,strains[[i]])
  	ggsave(plot = plts[[i]], file = pdffile)
	}

	#print(plts)
	#ggsave(plts,file=pdffile,width=12)

#  pdf(sprintf("plots/ChrPlot_%dkb.pdf", window/1000))
	#pdffile=sprintf("plots/ChrPlot_%dkb.pdf", window/1000)
#  plts <- lapply(1:nchr, plot_chrs, data = d)
#	for(i in 1:nchr ) {
#		pdffile=sprintf("plots/ChrPlot_%dkb.Chr%s.pdf", window/1000,i)
#		ggsave(plot = plts[[i]], file = pdffile)
#	}

#	ggsave(pdffile, device = "pdf",width=12)
#	print(plts)
	#ggsave(plts,file=pdffile,width=12)
}
