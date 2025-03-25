library(ggplot2)
LACRN <- read.delim("results/23_metrics_IMPUTED/Summary_LACRN_by_file_Concordance.csv")
LACRN_1000G_AMR <- read.delim("results/23_metrics_IMPUTED/Summary_LACRN_REF_1000G_AMR_by_file_Concordance.csv")
PATAGONIA <- read.delim("results/23_metrics_IMPUTED/Summary_PATAGONIA_by_file_Concordance.csv")
SGDP <- read.delim("results/23_metrics_IMPUTED/Summary_SGDP_by_file_Concordance.csv")

get_SE <- function(x,y){
  value <- x/sqrt(y)
  return(value)
}
LACRN_concord_avg <- mean(LACRN$Perc_Concordance)
LACRN_concord_sd <- sd(LACRN$Perc_Concordance)
LACRN_concord_se <- get_SE(LACRN_concord_sd, length(LACRN$Perc_Concordance))
LACRN_1000G_AMR_concord_avg <- mean(LACRN_1000G_AMR$Perc_Concordance)
LACRN_1000G_AMR_concord_sd <- sd(LACRN_1000G_AMR$Perc_Concordance)
LACRN_1000G_AMR_concord_se <- get_SE(LACRN_1000G_AMR_concord_sd, length(LACRN_1000G_AMR$Perc_Concordance))
PATAGONIA_concord_avg <- mean(PATAGONIA$Perc_Concordance)
PATAGONIA_concord_sd <- sd(PATAGONIA$Perc_Concordance)
PATAGONIA_concord_se <- get_SE(PATAGONIA_concord_sd, length(PATAGONIA$Perc_Concordance))
SGDP_concord_avg <- mean(SGDP$Perc_Concordance)
SGDP_concord_sd <- sd(SGDP$Perc_Concordance)
SGDP_concord_se <- get_SE(SGDP_concord_sd, length(SGDP$Perc_Concordance))

# GRAFICAR % CONCORDANCIA
data <- data.frame(
  SET=c("LACRN\n(1000G)","LACRN\n(1000G+PAT+SGDP)","PAT(1000G)","SGDP(1000G)"),
  value=c(LACRN_concord_avg, LACRN_1000G_AMR_concord_avg, PATAGONIA_concord_avg, SGDP_concord_avg),
  sd=c(LACRN_concord_se, LACRN_1000G_AMR_concord_se, PATAGONIA_concord_se, SGDP_concord_se)
)
# Most basic error bar
png("results/23_metrics_IMPUTED/CONCORANCE_SETs_09GEnos.png",height = 800, width = 800)
q <- ggplot(data) +
  geom_bar( aes(x=SET, y=value), stat="identity", fill="skyblue", alpha=0.7) +
  coord_cartesian( ylim = c(98.5, 99.75)) +
  geom_errorbar( aes(x=SET, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme(axis.text=element_text(size=30), axis.title=element_text(size=30,face="bold"))+
  theme(plot.title = element_text(size = 40, face = "bold"))+
  ylab("% Concordance") +
  ggtitle("% Concordance by Imputed sets")
q
dev.off()  

####PROCESAMIENTO DE CONCORDANCIA y R2 por muestra
##CONCORDANCIA
LACRN <- read.delim("results/23_metrics_IMPUTED/Summary_concord_r2_by_SAMPLE_LACRN.csv", sep = ";")
LACRN_1000G_AMR <- read.delim("results/23_metrics_IMPUTED/Summary_concord_r2_by_SAMPLE_LACRN_REF_1000G_AMR.csv", sep = ";")
PATAGONIA <- read.delim("results/23_metrics_IMPUTED/Summary_concord_r2_by_SAMPLE_PATAGONIA.csv", sep = ";")
SGDP <- read.delim("results/23_metrics_IMPUTED/Summary_concord_r2_by_SAMPLE_SGDP.csv", sep = ";")
LACRN_concord_avg <- LACRN$Average[1]
LACRN_concord_se <- LACRN$SE[1]
LACRN_1000G_AMR_concord_avg <- LACRN_1000G_AMR$Average_type0[1]
LACRN_1000G_AMR_concord_se <- LACRN_1000G_AMR$SE_type0[1]
PATAGONIA_concord_avg <- PATAGONIA$Average[1]
PATAGONIA_concord_se <- PATAGONIA$SE[1]
SGDP_concord_avg <- SGDP$Average[1]
SGDP_concord_se <- SGDP$SE[1]

# GRAFICAR % CONCORDANCIA por Muestra
data <- data.frame(
  SET=c("LACRN\n(1000G)","LACRN\n(1000G+PAT+SGDP)","PAT(1000G)","SGDP(1000G)"),
  value=c(LACRN_concord_avg, LACRN_1000G_AMR_concord_avg, PATAGONIA_concord_avg, SGDP_concord_avg),
  sd=c(LACRN_concord_se, LACRN_1000G_AMR_concord_se, PATAGONIA_concord_se, SGDP_concord_se)
)

# Most basic error bar
png("results/23_metrics_IMPUTED/CONCORANCE_SETs_by_sample.png",height = 800, width = 800)
q <- ggplot(data) +
  geom_bar( aes(x=SET, y=value), stat="identity", fill="skyblue", alpha=0.7) +
  coord_cartesian( ylim = c(0.98, 0.9975)) +
  geom_errorbar( aes(x=SET, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme(axis.text=element_text(size=30), axis.title=element_text(size=30,face="bold"))+
  theme(plot.title = element_text(size = 40, face = "bold"))+
  ylab("% Concordance") +
  ggtitle("% Concordance by Imputed sets")
q
dev.off() 

##R2
LACRN_concord_avg <- LACRN$Average[2] ##R2, no concordancia es el valor 2
LACRN_concord_se <- LACRN$SE[2]
LACRN_1000G_AMR_concord_avg <- LACRN_1000G_AMR$Average_type0[2]
LACRN_1000G_AMR_concord_se <- LACRN_1000G_AMR$SE_type0[2]
PATAGONIA_concord_avg <- PATAGONIA$Average[2]
PATAGONIA_concord_se <- PATAGONIA$SE[2]
SGDP_concord_avg <- SGDP$Average[2]
SGDP_concord_se <- SGDP$SE[2]

# GRAFICAR R2 por Muestra
data <- data.frame(
  SET=c("LACRN\n(1000G)","LACRN\n(1000G+PAT+SGDP)","PAT(1000G)","SGDP(1000G)"),
  value=c(LACRN_concord_avg, LACRN_1000G_AMR_concord_avg, PATAGONIA_concord_avg, SGDP_concord_avg),
  sd=c(LACRN_concord_se, LACRN_1000G_AMR_concord_se, PATAGONIA_concord_se, SGDP_concord_se)
)

  # Most basic error bar
png("results/23_metrics_IMPUTED/R2_SETs_by_sample.png",height = 800, width = 800)
q <- ggplot(data) +
  geom_bar( aes(x=SET, y=value), stat="identity", fill="skyblue", alpha=0.7) +
  coord_cartesian( ylim = c(0.95, 0.98)) +
  geom_errorbar( aes(x=SET, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme(axis.text=element_text(size=30), axis.title=element_text(size=30,face="bold"))+
  theme(plot.title = element_text(size = 40, face = "bold"))+
  ylab("R2") +
  ggtitle("R2 by Imputed sets")
q
dev.off() 


####leer datos por variante

LACRN_VARIANT <- read.table("results/16_phase_and_imputation/resume_used_variants_LACRN.resume", header = T)
LACRN_REF_VARIANT <- read.table("results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.resume", header = T)
PATAGONIA_VARIANT <- read.table("results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.resume", header = T)
SGDP_VARIANT <- read.table("results/19_phase_impute_SGDP/resume_used_variants_SGDP.resume", header = T)

###tipo 1 en LACRN_REF es el de tipo 0 en el normal
#por ende en LACRN_REF usar tipo 0 tambien

get_SE <- function(x,y){
  value <- x/sqrt(y)
  return(value)
}
LACRN_r2_avg <- mean(LACRN_VARIANT$r2_type0)
LACRN_r2_sd <- sd(LACRN_VARIANT$r2_type0)
LACRN_r2_se <- get_SE(LACRN_r2_sd, length(LACRN_VARIANT$r2_type0))
LACRN_1000G_AMR_r2_avg <- mean(LACRN_REF_VARIANT$r2_type1)
LACRN_1000G_AMR_r2_sd <- sd(LACRN_REF_VARIANT$r2_type1)
LACRN_1000G_AMR_r2_se <- get_SE(LACRN_1000G_AMR_r2_sd, length(LACRN_REF_VARIANT$r2_type1))
PATAGONIA_r2_avg <- mean(PATAGONIA_VARIANT$r2_type0)
PATAGONIA_r2_sd <- sd(PATAGONIA_VARIANT$r2_type0)
PATAGONIA_r2_se <- get_SE(PATAGONIA_r2_sd, length(PATAGONIA_VARIANT$r2_type0))
SGDP_r2_avg <- mean(SGDP_VARIANT$r2_type0)
SGDP_r2_sd <- sd(SGDP_VARIANT$r2_type0)
SGDP_r2_se <- get_SE(SGDP_r2_sd, length(SGDP_VARIANT$r2_type0))

print("Tabla resumen de R2 por variante********")
listPrint <- "Metrics_Impute;Average;SD;SE"
listPrint <- append(listPrint, paste("R2_LACRN(1000G)",round(LACRN_r2_avg, 4),round(LACRN_r2_sd,4),round(LACRN_r2_se,4),sep=";")     )
listPrint <- append(listPrint, paste("R2_LACRN(1000G+SGDP+PAT)",round(LACRN_1000G_AMR_r2_avg, 4),round(LACRN_1000G_AMR_r2_sd,4),round(LACRN_1000G_AMR_r2_se,4),sep=";")     )
listPrint <- append(listPrint, paste("R2_PATAGONIA(1000G)",round(PATAGONIA_r2_avg, 4),round(PATAGONIA_r2_sd,4),round(PATAGONIA_r2_se,4),sep=";")     )
listPrint <- append(listPrint, paste("R2_SGDP(1000G)",round(SGDP_r2_avg, 4),round(SGDP_r2_sd,4),round(SGDP_r2_se,4),sep=";")     )

# GRAFICAR R2 por VARIANTE
data <- data.frame(
  SET=c("LACRN\n(1000G)","LACRN\n(1000G+PAT+SGDP)","PAT(1000G)","SGDP(1000G)"),
  value=c(LACRN_r2_avg, LACRN_1000G_AMR_r2_avg, PATAGONIA_r2_avg, SGDP_r2_avg),
  sd=c(LACRN_r2_se, LACRN_1000G_AMR_r2_se, PATAGONIA_r2_se, SGDP_r2_se)
)

# Most basic error bar
png("results/23_metrics_IMPUTED/R2_SETs_by_VARIANTS.png",height = 800, width = 800)
q <- ggplot(data) +
  geom_bar( aes(x=SET, y=value), stat="identity", fill="skyblue", alpha=0.7) +
  coord_cartesian( ylim = c(0.76, 0.98)) +
  geom_errorbar( aes(x=SET, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme(axis.text=element_text(size=30), axis.title=element_text(size=30,face="bold"))+
  theme(plot.title = element_text(size = 40, face = "bold"))+
  ylab("R2") +
  ggtitle("R2 by Imputed sets in variants")
q
dev.off() 


###PROCESAMIENTO DE VARIANTES POR MAF

MAF_0_05 <- read.table("results/23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq_0_05.frq", header = F)
MAF_0_05$V2 <- as.vector(MAF_0_05$V2)
MAF_more_05 <- read.table("results/23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq_more_05.frq", header = F)
MAF_more_05$V2 <- as.vector(MAF_more_05$V2)

LACRN_VARIANT$rs_id <- as.vector(LACRN_VARIANT$rs_id)
LACRN_REF_VARIANT$rs_id <- as.vector(LACRN_REF_VARIANT$rs_id)

####SET LACRN(1000G) 
LACRN_VARIANT_0_05 <- LACRN_VARIANT[LACRN_VARIANT$rs_id %in% MAF_0_05$V2 ,]
LACRN_VARIANT_more_05 <- LACRN_VARIANT[LACRN_VARIANT$rs_id %in% MAF_more_05$V2 ,]
####SET LACRN(1000G+PAT+SGDP) 
LACRN_REF_VARIANT_0_05 <- LACRN_REF_VARIANT[LACRN_REF_VARIANT$rs_id %in% MAF_0_05$V2,]
LACRN_REF_VARIANT_more_05 <- LACRN_REF_VARIANT[LACRN_REF_VARIANT$rs_id %in% MAF_more_05$V2,]

LACRN_VARIANT_0_05_r2_avg <- mean(LACRN_VARIANT_0_05$r2_type0)
LACRN_VARIANT_0_05_r2_sd <- sd(LACRN_VARIANT_0_05$r2_type0)
LACRN_VARIANT_0_05_r2_se <- get_SE(LACRN_VARIANT_0_05_r2_sd, length(LACRN_VARIANT_0_05$r2_type0))
LACRN_VARIANT_more_05_r2_avg <- mean(LACRN_VARIANT_more_05$r2_type0)
LACRN_VARIANT_more_05_r2_sd <- sd(LACRN_VARIANT_more_05$r2_type0)
LACRN_VARIANT_more_05_r2_se <- get_SE(LACRN_VARIANT_more_05_r2_sd, length(LACRN_VARIANT_more_05$r2_type0))

LACRN_REF_VARIANT_0_05_r2_avg <- mean(LACRN_REF_VARIANT_0_05$r2_type1)
LACRN_REF_VARIANT_0_05_r2_sd <- sd(LACRN_REF_VARIANT_0_05$r2_type1)
LACRN_REF_VARIANT_0_05_r2_se <- get_SE(LACRN_REF_VARIANT_0_05_r2_sd, length(LACRN_REF_VARIANT_0_05$r2_type1))
LACRN_REF_VARIANT_more_05_r2_avg <- mean(LACRN_REF_VARIANT_more_05$r2_type1)
LACRN_REF_VARIANT_more_05_r2_sd <- sd(LACRN_REF_VARIANT_more_05$r2_type1)
LACRN_REF_VARIANT_more_05_r2_se <- get_SE(LACRN_REF_VARIANT_more_05_r2_sd, length(LACRN_REF_VARIANT_more_05$r2_type1))

listPrint <- append(listPrint, paste("R2_LACRN(1000G)_0_05",round(LACRN_VARIANT_0_05_r2_avg, 4),round(LACRN_VARIANT_0_05_r2_sd,4),round(LACRN_VARIANT_0_05_r2_se,4),sep=";")     )
listPrint <- append(listPrint, paste("R2_LACRN(1000G+SGDP+PAT)_0_05",round(LACRN_REF_VARIANT_0_05_r2_avg, 4),round(LACRN_REF_VARIANT_0_05_r2_sd,4),round(LACRN_REF_VARIANT_0_05_r2_se,4),sep=";")     )
listPrint <- append(listPrint, paste("R2_LACRN(1000G)_more_05",round(LACRN_VARIANT_more_05_r2_avg, 4),round(LACRN_VARIANT_more_05_r2_sd,4),round(LACRN_VARIANT_more_05_r2_se,4),sep=";")     )
listPrint <- append(listPrint, paste("R2_LACRN(1000G+SGDP+PAT)_more_05",round(LACRN_REF_VARIANT_more_05_r2_avg, 4),round(LACRN_REF_VARIANT_more_05_r2_sd,4),round(LACRN_REF_VARIANT_more_05_r2_se,4),sep=";")     )
write.table(listPrint, file = paste("results/23_metrics_IMPUTED/", "Summary_r2_by_VARIANT.csv" ,sep = ""), quote = F, row.names = F , col.names = F)






# GRAFICAR R2 por VARIANTE en los dos sets imputados y los dos set por filtro de MAF
data <- data.frame(
  SET=c("LACRN_0_05\n(1000G)","LACRN_0_05\n(1000G+PAT+SGDP)","LACRN_more_05\n(1000G)","LACRN_more_05\n(1000G+PAT+SGDP)"),
  value=c(LACRN_VARIANT_0_05_r2_avg, LACRN_REF_VARIANT_0_05_r2_avg, LACRN_VARIANT_more_05_r2_avg, LACRN_REF_VARIANT_more_05_r2_avg),
  sd=c(LACRN_VARIANT_0_05_r2_se, LACRN_REF_VARIANT_0_05_r2_se, LACRN_VARIANT_more_05_r2_se, LACRN_REF_VARIANT_more_05_r2_se)
)

png("results/23_metrics_IMPUTED/R2_SETs_by_VARIANTS_gruoped_by_MAF.png",height = 800, width = 800)
q <- ggplot(data) +
  geom_bar( aes(x=SET, y=value), stat="identity", fill="skyblue", alpha=0.7) +
  coord_cartesian( ylim = c(0.66, 0.93)) +
  geom_errorbar( aes(x=SET, ymin=value-sd, ymax=value+sd), width=0.4, colour="orange", alpha=0.9, size=1.3)+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))+
  theme(axis.text=element_text(size=30), axis.title=element_text(size=30,face="bold"))+
  theme(plot.title = element_text(size = 40))+
  ylab("R2") +
  ggtitle("R2 by Imputed sets in variants by MAF")
q
dev.off() 






