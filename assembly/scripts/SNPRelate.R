##For new systems, use the below lines to make sure packages are installed and loaded
if (!require("pacman")) install.packages("pacman")
pacman::p_load(data.table, ggplot2, ggpmisc)

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("SNPRelate")
BiocManager::install("VariantAnnotation")
BiocManager::install("gdsfmt")


#launch needed libraries
library(gdsfmt)
library(SNPRelate)
library(VariantAnnotation)
library(RColorBrewer)

#set working directory

#call VCF file
vcf.fn <- "Ugibba_filtered_SNPs_renamed.recode.vcf"

#convert to GDS format for SNPRelate analysis
snpgdsVCF2GDS(vcf.fn, "test.gds", method="biallelic.only",ignore.chr.prefix="Chr")

#summarize data
snpgdsSummary("test.gds")

genofile <- snpgdsOpen("test.gds", readonly=FALSE)
#LD prune
set.seed(1000)
snpset <- snpgdsLDpruning(genofile, ld.threshold=1, slide.max.n=5000,start.pos="random")

names(snpset)
snpset.id <- unlist(snpset)

#run PCA
pca <- snpgdsPCA(genofile, snp.id=snpset.id, num.thread=2)
pdf("PCA_plot_eigenvectors.pdf")
plot(pca)
dev.off()

# variance proportion (%)
pc.percent <- pca$varprop*100
head(round(pc.percent, 2))

# make a data.frame
tab <- data.frame(sample.id = pca$sample.id,
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)
head(tab)

pop_code <- add.gdsn(genofile, "popmap_PCA.txt")

plot(tab$EV2, tab$EV1, xlab="eigenvector 2", ylab="eigenvector 1")

# Get sample id
sample.id <- read.gdsn(index.gdsn(genofile, "sample.id"))
pop_code <- scan("pop_PCA.txt", what=character())
table(pop_code)
head(cbind(sample.id, pop_code))

tab <- data.frame(sample.id = pca$sample.id,
                  pop = factor(pop_code)[match(pca$sample.id, sample.id)],
                  EV1 = pca$eigenvect[,1],    # the first eigenvector
                  EV2 = pca$eigenvect[,2],    # the second eigenvector
                  stringsAsFactors = FALSE)
head(tab)

palette <-display.brewer.all(5,type="qual",select="Dark2",exact.n=TRUE)
palette <- brewer.pal(5,"Dark2")

pdf("PCA_by_population.pdf")
plot(tab$EV1,tab$EV2, col=as.integer(tab$pop), xlab="eigenvector 1", ylab="eigenvector 2")
par(xpd=TRUE)
legend("topright",ncol=2, cex=0.8, legend=levels(tab$pop), pch="o", col=1:nlevels(tab$pop))
dev.off()

pdf("PCA_unique_colors_PC1vsPC2.pdf",10,10)
col.list <- palette
plot(tab$EV1,tab$EV2, col=col.list[as.integer(tab$pop)], cex=3, pch=16, main="SNP PCA", xlab="eigenvector 1 (16.95%)", ylab="eigenvector 2 (14.8%)")
legend("topright", legend=levels(tab$pop), cex=1,pch=20, col=col.list[1:nlevels(tab$pop)])
dev.off()

pdf("PCA_unique_colors_PC2vsPC3.pdf",10,10)
col.list <- palette
plot(tab$EV2,tab$EV3, col=col.list[as.integer(tab$pop)], cex=3, pch=16, main="SNP PCA", xlab="eigenvector 2 (14.8%)", ylab="eigenvector 3 (9.3%)")
legend("topright", legend=levels(tab$pop), cex=1,pch=20, col=col.list[1:nlevels(tab$pop)])
dev.off()
