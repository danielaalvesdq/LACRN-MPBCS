args <- commandArgs(TRUE)
path_impute <- args[1]
#path_impute <- "results/22_IMPUTAR_LACRN_1000G_AMR/"
name_set <- args[2]
#name_set <- "LACRN_REF_1000G_AMR"

print("Numero de ventanas procesadas:")
system(paste("find",path_impute, "| grep info_by_sample | wc -l" , sep=" ")   , intern = TRUE)
info_samples <- system(paste("find",path_impute, "| grep info_by_sample" , sep=" ")   , intern = TRUE)
info_sample_windows <-read.table(  info_samples[1], header = T)
merge_info_sample_windows <- info_sample_windows
for (i in 2:length(info_samples)) {
  info_sample_windows <-read.table(  info_samples[i], header = T)
  merge_info_sample_windows <- rbind(merge_info_sample_windows,info_sample_windows)
}
get_SE <- function(x,y){
  value <- x/sqrt(y)
  return(value)
}


concord_avg <- mean(merge_info_sample_windows$concord_type0)
concord_sd <- sd(merge_info_sample_windows$concord_type0)
concord_se <- get_SE(concord_sd, length(merge_info_sample_windows$concord_type0))
r2_avg <- mean(merge_info_sample_windows$r2_type0)
r2_sd <- sd(merge_info_sample_windows$r2_type0)
r2_se <- get_SE(r2_sd, length(merge_info_sample_windows$r2_type0))


concord_avg_1 <- mean(merge_info_sample_windows$concord_type1)
concord_sd_1 <- sd(merge_info_sample_windows$concord_type1)
concord_se_1 <- get_SE(concord_sd, length(merge_info_sample_windows$concord_type1))
r2_avg_1 <- mean(merge_info_sample_windows$r2_type1)
r2_sd_1 <- sd(merge_info_sample_windows$r2_type1)
r2_se_1 <- get_SE(r2_sd, length(merge_info_sample_windows$r2_type1))



print("Tabla resumen de concordancia y R2 por muestra********")
print("Metrics_Impute;Average_type0;SD_type0;SE_type0;Average_type1;SD_type1;SE_type1")
print(paste("Concordance",round(concord_avg, 4),round(concord_sd,4),round(concord_se,4), round(concord_avg_1, 4),round(concord_sd_1,4),round(concord_se_1,4) ,sep=";"))
print(paste("R2",round(r2_avg, 4),round(r2_sd,4),round(r2_se,4)  ,round(r2_avg_1, 4),round(r2_sd_1,4),round(r2_se_1,4) ,sep=";"))
listPrint <- "Metrics_Impute;Average_type0;SD_type0;SE_type0;Average_type1;SD_type1;SE_type1"
listPrint <- append(listPrint,  paste("Concordance",round(concord_avg, 4),round(concord_sd,4),round(concord_se,4), round(concord_avg_1, 4),round(concord_sd_1,4),round(concord_se_1,4) ,sep=";")  )
listPrint <- append(listPrint,  paste("R2",round(r2_avg, 4),round(r2_sd,4),round(r2_se,4)  ,round(r2_avg_1, 4),round(r2_sd_1,4),round(r2_se_1,4) ,sep=";")    )
write.table(listPrint, file = paste("results/23_metrics_IMPUTED/", "Summary_concord_r2_by_SAMPLE_",name_set,".csv" ,sep = ""), quote = F, row.names = F , col.names = F)

png( paste("results/23_metrics_IMPUTED/", "Histogram_concordance_by_Sample_",name_set,"_type0.png" ,sep = ""))
hist(merge_info_sample_windows$concord_type0, main=paste("Histogram of Concordance by Sample ", name_set, sep=""), xlab="Concordance_type0")
dev.off()
png( paste("results/23_metrics_IMPUTED/", "Histogram_R2_by_Sample_",name_set,"_type0.png" ,sep = ""))
hist(merge_info_sample_windows$r2_type0, main=paste("Histogram of R2 by Sample ", name_set, sep=""), xlab="R2_type0")
dev.off()


png( paste("results/23_metrics_IMPUTED/", "Histogram_concordance_by_Sample_",name_set,"_type1.png" ,sep = ""))
hist(merge_info_sample_windows$concord_type1, main=paste("Histogram of Concordance by Sample ", name_set, sep=""), xlab="Concordance_type1")
dev.off()
png( paste("results/23_metrics_IMPUTED/", "Histogram_R2_by_Sample_",name_set,"_type1.png" ,sep = ""))
hist(merge_info_sample_windows$r2_type1, main=paste("Histogram of R2 by Sample ", name_set, sep=""), xlab="R2_type1")
dev.off()


###SUMMARY
list_summ <- ""
list_summ_file <- ""
info_summary <- system(paste("find",path_impute, "| grep summary" , sep=" ")   , intern = TRUE)

for (file in info_summary){
  summary <- readLines(file)
  summary2 <- summary[    grepl("\\[ >. 0\\.9\\]", summary)]
  if( length(summary2) != 0 ){
    list_summ_file <- append(list_summ_file, file)
    list_summ <- append(list_summ, summary2)
  }
}
##unirlos


lista_unida <- data.frame(list_summ_file, list_summ)
lista_unida <- lista_unida[ ! grepl("-nan", lista_unida$list_summ)    ,]

#list_summ2 <- list_summ
#list_summ2 <- list_summ2[! grepl("-nan", list_summ2)]
lista_unida$list_summ <- gsub( ".+\\[ >. 0\\.9\\]", ""  ,lista_unida$list_summ,perl=T)
data <- read.table(text=lista_unida$list_summ)
colnames(data) <- c("Perc_Called","Perc_Concordance")
lista_unida <- lista_unida[-1,]
data$File <- lista_unida$list_summ_file
write.table(data, file= paste("results/23_metrics_IMPUTED/", "Summary_",name_set,"_by_file_Concordance.csv" ,sep = ""), quote = F, row.names = F, sep="\t" )

called_avg <- mean(data$Perc_Called)
called_sd <- sd(data$Perc_Called)
called_se <- get_SE(called_sd, length(data$Perc_Called))
concordance_avg <- mean(data$Perc_Concordance)
concordance_sd <- sd(data$Perc_Concordance)
concordance_se <- get_SE(concordance_sd, length(data$Perc_Concordance))

print("Tabla resumen de %Called y %Concordance genotipos >= 0.9********")
print("Metrics_Impute;Average;SD;SE")
print(paste("%Called >= 0.9",round(called_avg, 4),round(called_sd,4),round(called_se,4) ,sep=";"))
print(paste("%Concordance >= 0.9",round(concordance_avg, 4),round(concordance_sd,4),round(concordance_se,4) ,sep=";"))
listPrint <- "Metrics_Impute;Average;SD;SE"
listPrint <- append(listPrint,  paste("%Called",round(called_avg, 4),round(called_sd,4),round(called_se,4) ,sep=";")  )
listPrint <- append(listPrint,  paste("%Concordance",round(concordance_avg, 4),round(concordance_sd,4),round(concordance_se,4) ,sep=";")    )
write.table(listPrint, file = paste("results/23_metrics_IMPUTED/", "Summary_",name_set,".csv" ,sep = ""), quote = F, row.names = F , col.names = F)

png( paste("results/23_metrics_IMPUTED/", "Histogram_Perc_Called_",name_set,".png" ,sep = ""))
hist(data$Perc_Called, main=paste("Histogram %Called by windows imputed ", name_set, sep=""), xlab="%Called")
dev.off()
png( paste("results/23_metrics_IMPUTED/", "Histogram_Perc_Concordance_",name_set,".png" ,sep = ""))
hist(data$Perc_Concordance, main=paste("Histogram %Concordance by windows imputed ", name_set, sep=""), xlab="%Concordance")
dev.off()


