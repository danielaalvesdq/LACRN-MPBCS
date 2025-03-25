relation <- read.table( "data_processing/7_quality_filters_samples/LACRN_filter3_genome.genome", header = T  )
png( paste("results/7_quality_filters_samples/Hist_relation_data_sample.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample")
dev.off()

