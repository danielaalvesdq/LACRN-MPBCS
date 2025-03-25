#MAP <- read.delim("LACRN_filter4_1_MAF.map")
GENOS <- read.table("data_processing/13_Dendogram_and_otherQC/LACRN_filter4_1_MAF_chr21-22_recode_A.raw", sep = " ", header = T)
GENOS2 <- GENOS[,c(1,7:length(GENOS))]
rownames(GENOS2)<-GENOS2[,1]
GENOS2<-GENOS2[,-1]
GENOS.dist <- dist(GENOS2, method="manhattan")
#mclust <- hclust(GENOS.dist, method="average")
mclust <- hclust(GENOS.dist)



sampleSheet <- read.csv("inputs/1_verify_information_and_data/samples_US-LACRN.csv")
infoClust <- data.frame(labels =labels(as.dendrogram(mclust, hang=-1)))
infoClust$Country <- NA
sampleSheet$Country <- as.vector(sampleSheet$Country)
sampleSheet$Sample_ID <- as.vector(sampleSheet$Sample_ID)
sampleSheet <-sampleSheet[ as.vector(sampleSheet$Sample_ID) %in% as.vector(infoClust$labels),] 
sampleSheet2 <- sampleSheet[match( infoClust$labels,  sampleSheet$Sample_ID),]
infoClust$Country <- sampleSheet2$Country
infoClust$Name <- sampleSheet2$Name
infoClust$Color <- NA

infoClust$Color[infoClust$Country == "Chile "] <- "red"
infoClust$Color[infoClust$Country == "Brazil"] <- "gold"
infoClust$Color[infoClust$Country == "Argentina"] <- "cadetblue3"
infoClust$Color[infoClust$Country == "Uruguay"] <- "blue"
infoClust$Color[infoClust$Country == "Mexico"] <- "forestgreen"

infoClust$labels_final <- paste(infoClust$Name, infoClust$labels, sep="_")

pdf("results/13_Dendogram_and_otherQC/Dendogram_LACRN_CHR21-22.pdf", width=7, height=80)
par(mar=c(6,1,1,10), cex=.6)
plot(as.dendrogram(mclust, hang=-1), horiz=T, xlab="Manhattan genotype distance", main="LACRN samples", leaflab = "none")
mtext(infoClust$labels_final, side=4, at=1:length(mclust$labels), las=2, cex=0.5, line=-1, col = infoClust$Color)
legend("bottomright",  fill=c("red","gold", "cadetblue3", "blue","forestgreen" ) ,legend = c("Chile","Brazil","Argentina", "Uruguay","Mexico" ), cex = 2)
dev.off()

pdf("Dendogram_LACRN_CHR21-22_prueba.pdf", width=7, height=80)
par(mar=c(6,1,1,8), cex=.6)
plot(as.dendrogram(mclust, hang=-1), horiz=T, xlab="Manhattan genotype distance", main="LACRN samples")
dev.off()



