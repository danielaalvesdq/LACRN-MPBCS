samplesheet <- read.csv("inputs/1_verify_information_and_data/samples_US-LACRN.csv")
samplesheet$Country_Source <- ifelse(as.vector(samplesheet$Country) == as.vector(samplesheet$Source), as.vector(samplesheet$Country), paste(as.vector(samplesheet$Country), as.vector(samplesheet$Source),sep ="_") )
samplesheet <- subset(samplesheet, select = c("Sample_ID","SentrixBarcode_A" ,"Date", "Country","Source", "Country_Source", "Discard"))
colnames(samplesheet) <- c("Sample_ID","CHIP" ,"Date", "Country","Source", "Country_Source", "Discard")
samplesheet2 <- subset(samplesheet, select = c("Sample_ID","CHIP","Country_Source", "Discard"))

getRelationsInfo <- function(relation,MAF){
  relation2 <- relation[relation$PI_HAT >= 0.125,]
  relation2 <- subset(relation2, select = c("FID1","IID1","FID2","IID2","PI_HAT" ))
  relation3 <- as.data.frame(  table(as.vector( relation2$FID1)))
  relation4 <- as.data.frame(  table(as.vector( relation2$FID2)))
  uniqRelationFID1 <- relation3[!relation3$Var1 %in% relation4$Var1,]
  uniqRelationFID2 <- relation4[!relation4$Var1 %in% relation3$Var1,]
  commonRelation <- relation3[relation3$Var1 %in% relation4$Var1,]
  commonRelation2 <- relation4[relation4$Var1 %in% relation3$Var1,]
  commonRelation3 <- commonRelation
  commonRelation3$Freq <- commonRelation$Freq + commonRelation2$Freq
  finaluniqrelation <- uniqRelationFID1
  finaluniqrelation <- rbind(finaluniqrelation, uniqRelationFID2)
  finaluniqrelation <- rbind(finaluniqrelation,commonRelation3 )
  colnames(finaluniqrelation) <- c("FID1","N_relations")
  F_I_ID1 <- subset(relation2, select = c("FID1","IID1"))
  colnames(F_I_ID1) <- c("FID","IID")
  F_I_ID2 <- subset(relation2, select = c("FID2","IID2"))
  colnames(F_I_ID2) <- c("FID","IID")
  F_I_ID_rbind <- rbind(F_I_ID1, F_I_ID2)
  uniqueID <- unique(F_I_ID_rbind)
  finaluniqrelation <- merge(finaluniqrelation,uniqueID, by.x = "FID1", by.y = "FID" )
  finaluniqrelation <- subset(finaluniqrelation, select = c("FID1", "IID", "N_relations"))
  finaluniqrelation <- merge(finaluniqrelation,samplesheet, by.x = "FID1", by.y = "Sample_ID", all.x = T )
  finaluniqrelation <- finaluniqrelation[order(-finaluniqrelation$N_relations),] 
  write.table(finaluniqrelation, file = paste( "results/10_quality_filters_sex_relationship/UniqRelation_LD_MAF_",MAF,".tsv" ,sep = ""), sep = "\t", quote = F, row.names = F   )
  
  PAIRS_related <- relation2
  PAIRS_related <- merge(PAIRS_related, samplesheet2, by.x = "FID1", by.y = "Sample_ID" , all.x = T)
  colnames(PAIRS_related) <- c("FID1","IID1","FID2","IID2","PI_HAT","CHIP_ID1","Country_Source_ID1","Discard_ID1")
  PAIRS_related <- merge(PAIRS_related, samplesheet2, by.x = "FID2", by.y = "Sample_ID" , all.x = T)
  PAIRS_related <- subset(PAIRS_related, select = c("FID1","IID1","FID2","IID2","PI_HAT","CHIP_ID1","Country_Source_ID1","Discard_ID1","CHIP","Country_Source","Discard"  ))
  colnames(PAIRS_related) <- c("FID1","IID1","FID2","IID2","PI_HAT","CHIP_ID1","Country_Source_ID1","Discard_ID1", "CHIP_ID2", "Country_Source_ID2", "Discard_ID2")
  PAIRS_related <- PAIRS_related[order(-PAIRS_related$PI_HAT),] 
  write.table(PAIRS_related, file = paste( "results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_",MAF,".tsv" ,sep = ""), sep = "\t", quote = F, row.names = F   )
}

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome_LD.genome", header = T  )
getRelationsInfo(relation,"0")
relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_02_genome_LD.genome", header = T  )
getRelationsInfo(relation,"02")
relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD.genome", header = T  )
getRelationsInfo(relation,"1")
relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome", header = T  )
getRelationsInfo(relation,"5")
