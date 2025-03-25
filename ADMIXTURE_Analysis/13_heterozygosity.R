args <- commandArgs(TRUE)

hetero <- read.table("data_processing/13_Dendogram_and_otherQC/Heterozygosity_samples.tsv", header = T)
sampleSheet <- read.csv("inputs/1_verify_information_and_data/samples_US-LACRN.csv")
GT_samples <- read.table(   "data_processing/7_quality_filters_samples/LACRN_samples-missing.imiss", header = T)
##escribimos información de todas las muestras, sample sheet + datos perdidos por muestra
info_samples_all <- merge(GT_samples, sampleSheet, by.x = "FID", by.y = "Sample_ID")
write.table(info_samples_all, file = "results/13_Dendogram_and_otherQC/Info_all_samples_QC.tsv", quote = F, sep="\t", row.names=F)

GT_samples <- GT_samples[GT_samples$F_MISS <= 0.1,]
info_samples <- merge(GT_samples, hetero, by.x = "FID", by.y = "Sample")
info_samples <- merge(info_samples, sampleSheet, by.x = "FID", by.y = "Sample_ID")
info_samples$Country_Source <- paste(info_samples$Country, info_samples$Source,sep="_")
info_samples$GT_P <-   100- (info_samples$F_MISS*100)
info_samples <- subset(info_samples, select = c("FID","IID","MISS_PHENO","N_MISS","N_GENO","F_MISS","Percent_Heterozigosity","Gender","Plate","Well_Original",
                                                "Well","CHIP","Date","Country","Source","DNA.concentration..ng.ul.","Discard","SentrixBarcode_A","SentrixPosition_A",
                                                "Path","Country_Source","GT_P")  )

##leer archivo de parentesco
##Leer archivo de sexo
sex_file <- read.table(args[1], header = T)
#sex_file <- read.table("data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_checksex.sexcheck", header = T)
info_samples <- merge(info_samples, sex_file, by.x = "FID", by.y ="FID")

maf_LD <- args[2]
#maf_LD <- "1_NO_LD"

###Grafico %GT vs %Heterocigocidad coloreados por pais
png(filename = paste("results/13_Dendogram_and_otherQC/Het_vs_GT.png" ,sep = "") ,width = 700, height = 500)
par(mar=c(5,5,4,6), xpd=TRUE)
plot(info_samples$GT_P, info_samples$Percent_Heterozigosity, 
     col =info_samples$Country, 
     pch=20, 
     main = "%Genotyping by %Heterozigosity", 
     xlab = "%Genotyping",
     ylab = "%Heterozigosity",
     cex = 2,
     cex.axis = 1.5,
     cex.lab = 1.5, 
     cex.main = 2)
legend("bottomright", inset=c(-0.163,0), legend = c( levels(info_samples$Country)) , fill = unique(info_samples$Country), xpd=T)
dev.off()


###Grafico boxplot de %heterocigocidad por pais
png(filename = paste("results/13_Dendogram_and_otherQC/Boxplor_Het.png" ,sep = "") ,width = 700, height = 500)
boxplot(info_samples$Percent_Heterozigosity~info_samples$Country, 
        main="%Heterozigosity by Country", 
        ylab="%Heterozigosity", 
        xlab="Country", 
        col=c("cyan", "red","white", "blue","green"),     
        cex = 2,
        cex.axis = 1.5,
        cex.lab = 1.5, 
        cex.main = 2)
dev.off()

#sampleSheet2 <- read.csv("inputs/1_verify_information_and_data/samples_US-LACRN complete_formated.csv")
N_relation <- read.delim(args[3])
#N_relation <- read.delim("results/10_quality_filters_sex_relationship/UniqRelation_MAF_1.tsv")
info_samples2 <- merge(N_relation, sampleSheet, by.x = "IID", by.y = "Name")
info_samples2$DNA.concentration..ng.ul. <- as.vector(info_samples2$DNA.concentration..ng.ul.)
info_samples2$DNA.concentration..ng.ul. <- gsub(",",".", info_samples2$DNA.concentration..ng.ul.)
info_samples2$DNA.concentration..ng.ul. <-as.numeric(   as.vector(info_samples2$DNA.concentration..ng.ul.))

###unimos info de N_related al total de muestras filtradas
info_samples <- merge(info_samples, N_relation, by.x="FID", by.y = "FID1", all.x = T)
info_samples <- subset(info_samples, select = c("FID","IID.x","MISS_PHENO","N_MISS","N_GENO","F_MISS","Percent_Heterozigosity",
                                                "Gender","Plate","Well_Original","Well","CHIP.x","Date.x","Country.x","Source.x","DNA.concentration..ng.ul.",
                                                "SentrixBarcode_A","SentrixPosition_A","Path","Country_Source.x","GT_P",
                                                "PEDSEX","SNPSEX","STATUS","F","N_relations")  )
colnames(info_samples) <-  c("FID","IID","MISS_PHENO","N_MISS","N_GENO","F_MISS","Percent_Heterozigosity",
                             "Gender","Plate","Well_Original","Well","CHIP","Date","Country","Source","DNA.concentration..ng.ul.",
                             "SentrixBarcode_A","SentrixPosition_A","Path","Country_Source","GT_P",
                             "PEDSEX","SNPSEX","STATUS","F","N_relations")

write.table(info_samples, file = paste("results/13_Dendogram_and_otherQC/Info_samples_filter_QC_",maf_LD, ".tsv" ,sep=""), quote = F, sep="\t", row.names=F)



###Grafico x:concentración, y:número de muestras con parentesco mayor a 0.125
png(filename = paste("results/13_Dendogram_and_otherQC/Concentration_vs_N_relations_",maf_LD,".png" ,sep = "") ,width = 700, height = 500)
par(mar=c(5,5,4,2))
plot(info_samples2$DNA.concentration..ng.ul., info_samples2$N_relations,
     pch = 21, bg = "cornflowerblue", col = "black",
     main = "Concentration vs N° Relations by sample",
     xlab = "Concentration (ng/ul)",
     ylab = "N° Relations by sample (PHI_HAT > 0.125)",
     cex = 3,
     cex.axis = 1.5,
     cex.lab = 1.5, 
     cex.main = 2)
dev.off()


### Gráfico de barras para la variable "número de muestras con PI_HAT>0.125" (Nrelated)
info_samples2 <- info_samples2[order(info_samples2$N_relations),]
info_samples2$IID_MOD <- NA
info_samples2$IID_MOD[info_samples2$Country.x == "Mexico"] <- paste(info_samples2$IID[info_samples2$Country.x == "Mexico"], "M", sep = "_")
info_samples2$IID_MOD[info_samples2$Country.x == "Argentina"] <- paste(info_samples2$IID[info_samples2$Country.x == "Argentina"], "A", sep = "_")
info_samples2$IID_MOD[info_samples2$Country.x == "Brazil"] <- paste(info_samples2$IID[info_samples2$Country.x == "Brazil"], "B", sep = "_")
info_samples2$IID_MOD[info_samples2$Country.x == "Chile "] <- paste(info_samples2$IID[info_samples2$Country.x == "Chile "], "C", sep = "_")
info_samples2$IID_MOD[info_samples2$Country.x == "Uruguay"] <- paste(info_samples2$IID[info_samples2$Country.x == "Uruguay"], "U", sep = "_")

png(filename = paste("results/13_Dendogram_and_otherQC/N_relations_by_sample_",maf_LD,".png" ,sep = "") ,width = 700, height = 500)
par(mar=c(7,5,4,2))
barplot(info_samples2$N_relations, 
        #names.arg = c(1:length(info_samples2$N_relations)),
        names.arg = info_samples2$IID_MOD, 
        #col.axis = "red",
        #col = "#69b3a2",
        #xlab = "Sample", 
        ylab = "N° Relations (PHI_HAT > 0.125)", 
        border = "blue",
        main = "N° Relations by Sample",
        cex.axis = 1.5,
        cex.names = 0.8,
        cex.lab = 1.5,
        cex.main = 2,
        width = 0.84, 
        las= 2)
text(x = c(1:length(info_samples2$N_relations)), y = info_samples2$N_relations, label = info_samples2$N_relations, pos = 3, cex = 0.9, col = "red", offset = 0.3,srt=60)
mtext("Samples", side = 1, xpd = T, line= +4.5, cex = 2)

dev.off()


###Gráfico de dispersión con x: Call rate, y: promedio PI_HAT con muestras con PHI_HAT > 0.125
samples_related <-  info_samples2$IID
PAIRS_relation <- read.delim(args[4]) 
#PAIRS_relation <- read.delim("results/10_quality_filters_sex_relationship/PairsRelation_MAF_1.tsv")
PAIRS_relation$PI_HAT <- as.vector(PAIRS_relation$PI_HAT)
PAIRS_relation$PI_HAT <- gsub(",",".",PAIRS_relation$PI_HAT)
PAIRS_relation$PI_HAT <- as.numeric(PAIRS_relation$PI_HAT)
info_samples2$Mean_PhiHat <- NA
info_samples2$GT_P <- NA

for (sample in samples_related) {
  print(sample)
  data_temp <- PAIRS_relation[PAIRS_relation$IID1 == sample | PAIRS_relation$IID2 == sample, ]
  MEAN_PHIHAT <- mean(data_temp$PI_HAT)
  info_samples2$Mean_PhiHat[info_samples2$IID == sample] <- MEAN_PHIHAT
  info_samples2$GT_P[info_samples2$IID == sample] <- info_samples$GT_P[info_samples$IID == sample] 
}

png(filename = paste("results/13_Dendogram_and_otherQC/GT_vs_Mean_PhiHat_",maf_LD,".png" ,sep = "") ,width = 700, height = 500)
par(mar=c(5,5,4,2))
plot(info_samples2$GT_P, info_samples2$Mean_PhiHat,
     pch = 21, bg = "cornflowerblue", col = "black",
     main = "%Genotyping vs Mean of PHI_HAT",
     xlab = "%Genotyping (Call rate)",
     ylab = "Mean PHI_HAT (in samples PHI_HAT > 0.125)",
     cex = 3,
     cex.axis = 1.5,
     cex.lab = 1.5, 
     cex.main = 2)

dev.off()


###Graficar N relaciones vs proedio PHI_HAT
png(filename = paste("results/13_Dendogram_and_otherQC/Mean_PhiHat_vs_N_relations_",maf_LD,".png" ,sep = "") ,width = 700, height = 500)
par(mar=c(5,5,4,2))
plot(info_samples2$N_relations, info_samples2$Mean_PhiHat,
     pch = 21, bg = "cornflowerblue", col = "black",
     main = "Mean of PHI_HAT vs  N° Relations by sample",
     xlab = "N° Relations (PHI_HAT > 0.125)",
     ylab = "Mean PHI_HAT (in samples PHI_HAT > 0.125)",
     cex = 2.5,
     cex.axis = 1.5,
     cex.lab = 1.5, 
     cex.main = 2)
dev.off()

