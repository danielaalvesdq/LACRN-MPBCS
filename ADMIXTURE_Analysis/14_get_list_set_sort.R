popinfo <- read.delim("data_processing/14_Admixture/popinfo_1000G_AYMARA_MAPUCHE_LACRN.csv")
list_sample_popinfo <- popinfo$IndID
fam <- read.table("data_processing/14_Admixture/1000G_AYM_MAP_LACRN_LD.fam")
fam2 <- fam[match(list_sample_popinfo, fam$V1),]
write.table(fam2[,1:2], file="data_processing/14_Admixture/LIST_SAMPLES_ORDENADAS.csv", sep="\t", quote=F,row.names = F, col.names = F)
