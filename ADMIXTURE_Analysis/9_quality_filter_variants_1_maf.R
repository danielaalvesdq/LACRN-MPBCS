frq_LACRN <- read.table( "data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq", header = T  )
png( paste("results/9_quality_filters_part2/LACRN_filter3_MAF_data_SNPs.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$MAF, main =  "Histogram of MAF data per Variants", xlab = "MAF data rate per Variant")
dev.off()

print("results/9_quality_filters_part2/LACRN_filter3_MAF_data_SNPs.png")

png( paste("results/9_quality_filters_part2/LACRN_filter3_MAF_data_SNPs_zoom.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$MAF, main =  "Histogram of MAF data per Variants", xlab = "MAF data rate per Variant", xlim = c(0,0.1), breaks = 80)
dev.off()

print("results/9_quality_filters_part2/LACRN_filter3_MAF_data_SNPs_zoom.png")
