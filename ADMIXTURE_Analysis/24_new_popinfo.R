popinfo <- read.delim("inputs/24_new_popinfo/popinfo_1000G_SGDP_PATAGONIA_LACRN.csv")
info_AMR <- read.delim("inputs/24_new_popinfo/info_AMR_beta.tsv")
ANCESTRY_LACRN <- read.delim("inputs/24_new_popinfo/ANCESTRY_LACRN.tsv")


SGDP_popinfo_anterior <- popinfo[popinfo$Source == "SGDP",]
AMR_AUSENTES <- info_AMR[! info_AMR$Illumina_ID  %in% SGDP_popinfo_anterior$IndID,]

 
popinfo$IndID <- as.vector(popinfo$IndID)
info_AMR$Illumina_ID <- as.vector(info_AMR$Illumina_ID)
info_AMR$Sample_ID <- as.vector(info_AMR$Sample_ID)

for (i in 1:length(popinfo$IndID)) {
  if( length(info_AMR$Sample_ID[info_AMR$Illumina_ID == popinfo[i,]$IndID]) > 0  ){
    popinfo[i,]$IndID <- info_AMR$Sample_ID[info_AMR$Illumina_ID == popinfo[i,]$IndID]
  }
}




#write.table(popinfo, file = "results/24_new_popinfo/popinfo_1000G_SGDP_PATAGONIA_LACRN_v2.csv", sep = "\t", quote = F, row.names = F)
#manualmente agrego las 3 muestras faltantes de AMR SGDP en el dataframe AMR_AUSENTES 

popinfo2 <- read.delim("results/24_new_popinfo/popinfo_1000G_SGDP_PATAGONIA_LACRN_v2.csv")
popinfo2$IndID <- as.vector(popinfo2$IndID)
ANCESTRY_LACRN$IndID <- as.vector(ANCESTRY_LACRN$IndID)
ANCESTRY_LACRN$SentrixID <- as.vector(ANCESTRY_LACRN$SentrixID)

for (i in 1:length(popinfo2$IndID)) {
  if( length(ANCESTRY_LACRN$IndID[ANCESTRY_LACRN$SentrixID == popinfo2[i,]$IndID]) > 0  ){
    popinfo2[i,]$IndID <- ANCESTRY_LACRN$IndID[ANCESTRY_LACRN$SentrixID == popinfo2[i,]$IndID]
  }
}

write.table(popinfo2, file = "results/24_new_popinfo/popinfo_1000G_SGDP_PATAGONIA_LACRN_v3.csv", sep = "\t", quote = F, row.names = F)
