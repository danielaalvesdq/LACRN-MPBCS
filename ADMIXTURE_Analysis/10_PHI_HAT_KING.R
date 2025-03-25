PHI_HAT <- read.table("data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome", header = T)
KIN <- read.table("data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_king_filter.kin0",header = F)
PHI_HAT$PAIR1 <- paste(PHI_HAT$FID1, PHI_HAT$FID2, sep = "_")
PHI_HAT$PAIR2 <- paste(PHI_HAT$FID2, PHI_HAT$FID1, sep = "_")

KIN$PAIR1 <- paste(KIN$V1, KIN$V3, sep = "_")
KIN$PAIR2 <- paste(KIN$V3, KIN$V1, sep = "_")

ID1 <- as.vector(KIN$PAIR1)
ID2 <- as.vector(KIN$PAIR2)


PHI_HAT2 <-  PHI_HAT[PHI_HAT$PAIR1 %in% ID1 | PHI_HAT$PAIR2 %in% ID1  | PHI_HAT$PAIR1 %in% ID2 | PHI_HAT$PAIR2 %in% ID2       ,]
colnames(PHI_HAT2) <- c("FID1","IID1","FID2","IID2","RT","EZ","Z0","Z1","Z2","PI_HAT","PHE","DST","PPC","RATIO","PAIR1_P","PAIR2_P" )

SET <- merge(PHI_HAT2, KIN, by.x ="PAIR1_P", by.y = "PAIR2")
png("results/10_quality_filters_sex_relationship/KINSHIP_VS_PHI_HAT_MAF5.png")
plot(SET$V8~SET$PI_HAT, xlab="PHI_HAT", ylab = "KINSHIP", cex=2)
dev.off()





PHI_HAT <- read.table("data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD.genome", header = T)
KIN <- read.table("data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_king_filter.kin0",header = F)
PHI_HAT$PAIR1 <- paste(PHI_HAT$FID1, PHI_HAT$FID2, sep = "_")
PHI_HAT$PAIR2 <- paste(PHI_HAT$FID2, PHI_HAT$FID1, sep = "_")

KIN$PAIR1 <- paste(KIN$V1, KIN$V3, sep = "_")
KIN$PAIR2 <- paste(KIN$V3, KIN$V1, sep = "_")

ID1 <- as.vector(KIN$PAIR1)
ID2 <- as.vector(KIN$PAIR2)


PHI_HAT2 <-  PHI_HAT[PHI_HAT$PAIR1 %in% ID1 | PHI_HAT$PAIR2 %in% ID1  | PHI_HAT$PAIR1 %in% ID2 | PHI_HAT$PAIR2 %in% ID2       ,]
colnames(PHI_HAT2) <- c("FID1","IID1","FID2","IID2","RT","EZ","Z0","Z1","Z2","PI_HAT","PHE","DST","PPC","RATIO","PAIR1_P","PAIR2_P" )

SET <- merge(PHI_HAT2, KIN, by.x ="PAIR1_P", by.y = "PAIR2")
png("results/10_quality_filters_sex_relationship/KINSHIP_VS_PHI_HAT_MAF1.png")
plot(SET$V8~SET$PI_HAT, xlab="PHI_HAT", ylab = "KINSHIP", cex=2)
dev.off()

png("results/10_quality_filters_sex_relationship/KINSHIP_hist.png")
hist(KIN$V8, xlab = "KINSHIP", main = "Frequency of KINSHIP in pairs of samples")
dev.off()





