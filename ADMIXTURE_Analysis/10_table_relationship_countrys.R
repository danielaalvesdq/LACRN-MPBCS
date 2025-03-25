#Sript creado por Ricardo Verdugo, modificado por Cristian Yáñez
#Ejecutar como Rscript code/10_table_relationship_countrys.R results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5.tsv 5_YES_LD
args <- commandArgs(TRUE)
#pares_arg <- args[1]
pares_arg <- "results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5.tsv"
#maf_LD <- args[2]
maf_LD <- "5_YES_LD"

sampleSheet <- read.csv("inputs/1_verify_information_and_data/samples_US-LACRN.csv")

fam_filter <- read.table("results/7_quality_filters_samples/LACRN_filter3.fam")
listFAM <- as.vector(fam_filter$V1)
sampleSheet <- sampleSheet[sampleSheet$SentrixPosition %in% listFAM,]


pares <- read.delim(pares_arg)
#pares <- read.delim("results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5_BETA.tsv")
#maf_LD <- "5_YES_LD"
#relaciones <- read.delim2("results/10_quality_filters_sex_relationship/UniqRelation_MAF_1.tsv")

pares$Plate1 <- NA
pares$Plate2 <- NA
listID1 <- pares$FID1
listID1 <- levels(listID1)
listID2 <- pares$FID2
listID2 <- levels(listID2)

for(ID in listID1){
  pares$Plate1[pares$FID1 == ID] <- sampleSheet[sampleSheet$SentrixPosition == ID,]$Plate
}

for(ID in listID2){
  pares$Plate2[pares$FID2 == ID] <- sampleSheet[sampleSheet$SentrixPosition == ID,]$Plate
}

write.table(pares2, file=paste("results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5_Beta.tsv",sep = ""), sep="\t", quote = F)

pares$Pais1 <- sub("_.*$", "", pares$Country_Source_ID1)
pares$Pais2 <- sub("_.*$", "", pares$Country_Source_ID2)
pares$Same <- factor(ifelse(pares$Pais1==pares$Pais2, "Same", "Different"))
pares_por_pais <- table(pares$Pais2, pares$Pais1)



png(filename = paste("results/10_quality_filters_sex_relationship/related_pairs_by_coutry_",maf_LD,".png",sep = ""),width = 400, height = 400)
boxplot(pares$PI_HAT~pares$Same, xlab="Country", ylab="PHI_HAT")
dev.off()
print(paste("results/10_quality_filters_sex_relationship/related_pairs_by_coutry_",maf_LD,".png",sep = ""))

###N<-scan()
# 198 190 156 313  61 # Usado inicialmnete, pero incorrecto
# 198, 191, 156, 313, 58 # Argentina, Brazil, Chile, Mexico, Uruguay , correcto, entregado por Cristian.

#Argentina    Brazil    Chile     Mexico   Uruguay (16/04/20)
#      210       208       159       325        78 

N <- c(210,208,159,325,78) #Actualizado

pares2<- pares_por_pais + t(pares_por_pais)

##Intra <- diag(pares2)
Intra <- diag(pares2)/2
#Intra[2] <- 0
diag(pares2) <- Intra
Total <- apply(pares2, 1, sum)
#Total[2] <- 7 para MAF 5 LD, donde incluimos un extra falso para que no caiga el script, manual por que da error

pares2[lower.tri(pares2)]<- NA
pares_posibles <- N*sum(N)/2-N
pares2 <- cbind(pares2, Total=Total)
pares2 <- cbind(pares2, Intra=Intra/Total*100)
pares2 <- cbind(pares2, Representation=Intra/pares_posibles*100)

#pares$PI_HAT <- gsub(",",".",pares$PI_HAT)
#pares$PI_HAT <- as.numeric(pares$PI_HAT)

write.table(pares2, file=paste("results/10_quality_filters_sex_relationship/related_pairs_by_coutry_",maf_LD,".tsv",sep = ""), sep="\t", quote = F)
print(paste("results/10_quality_filters_sex_relationship/related_pairs_by_coutry_",maf_LD,".csv",sep = ""))


#############
N <- as.vector(  table(sampleSheet$Plate))
N <- N[-1]
pares_por_placa <- table(pares$Plate1, pares$Plate2)
pares2<- pares_por_placa + t(pares_por_placa)
Intra <- diag(pares2)/2
#Intra[2] <- 0
diag(pares2) <- Intra
Total <- apply(pares2, 1, sum)
pares2[lower.tri(pares2)]<- NA
pares_posibles <- N*sum(N)/2-N
pares2 <- cbind(pares2, Total=Total)
pares2 <- cbind(pares2, Intra=Intra/Total*100)
pares2 <- cbind(pares2, Representation=Intra/pares_posibles*100)



write.table(pares2, file=paste("results/10_quality_filters_sex_relationship/related_pairs_by_PLATE_",maf_LD,".tsv",sep = ""), sep="\t", quote = F)
print(paste("results/10_quality_filters_sex_relationship/related_pairs_by_PLATE_",maf_LD,".tsv",sep = ""))




