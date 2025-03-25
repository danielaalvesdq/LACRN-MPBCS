sex_sample_proyect <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_checksex_LD.sexcheck", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_0_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample")
dev.off()

png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_zoom_0_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample", xlim = c(0.2,0.4), ylim = c(0,8) , breaks = 50 )
dev.off()

sex_sample_proyect <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_02_MAF_checksex_LD.sexcheck", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_02_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample")
dev.off()

png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_zoom_02_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample", xlim = c(0.2,0.4), ylim = c(0,8) , breaks = 50 )
dev.off()



sex_sample_proyect <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_checksex_LD.sexcheck", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_1_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample")
dev.off()

png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_zoom_1_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample", xlim = c(0.2,0.4), ylim = c(0,8) , breaks = 50 )
dev.off()


sex_sample_proyect <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_3_MAF_checksex_LD.sexcheck", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_3_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample")
dev.off()

png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_zoom_3_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample", xlim = c(0.2,0.4), ylim = c(0,8) , breaks = 50 )
dev.off()


sex_sample_proyect <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_checksex_LD.sexcheck", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_5_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample")
dev.off()

png( paste("results/10_quality_filters_sex_relationship/Hist_F_sex_data_sample_zoom_5_LD.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample", xlim = c(0.2,0.4), ylim = c(0,8) , breaks = 50 )
dev.off()


