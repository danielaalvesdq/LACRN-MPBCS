relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_0_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample")
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_02_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_02_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample")
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_1_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample")
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_3_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_3_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample")
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_5_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample")
dev.off()



relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_0_zoom_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample", xlim=c(0.1,0.2), ylim=c(0,400), breaks = 50)
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_02_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_02_zoom_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample", xlim=c(0.1,0.2), ylim=c(0,400), breaks = 50)
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_1_zoom_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample", xlim = c(0.1,0.2) , ylim=c(0,400), breaks = 50)
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_3_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_3_zoom_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample", xlim=c(0.1,0.2), ylim=c(0,400), breaks = 50)
dev.off()

relation <- read.table( "data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome", header = T  )
png( paste("results/10_quality_filters_sex_relationship/Hist_relation_data_sample_5_zoom_LD.png" , sep = ""), height=500, width=600)
hist(relation$PI_HAT, main =  "PI_HAT score histogram of relationships in pairs of samples", xlab = "PI_HAT score in pairs of sample", xlim=c(0.1,0.2), ylim=c(0,400), breaks = 50)
dev.off()

