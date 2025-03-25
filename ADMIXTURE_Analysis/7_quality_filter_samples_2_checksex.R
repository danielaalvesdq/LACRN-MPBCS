sex_sample_proyect <- read.table( "data_processing/7_quality_filters_samples/LACRN_filter3_checksex.sexcheck", header = T  )
png( paste("results/7_quality_filters_samples/Hist_F_sex_data_sample.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample")
dev.off()

png( paste("results/7_quality_filters_samples/Hist_F_sex_data_sample_zoom.png" , sep = ""), height=500, width=600)
hist(sex_sample_proyect$F, main =  "Histogram of F score of check-sex data per sample", xlab = "F score data per sample", xlim = c(0.2,0.4), ylim = c(0,8) , breaks = 50 )
dev.off()
