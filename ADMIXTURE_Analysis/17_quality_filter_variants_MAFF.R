frq_LACRN <- read.table( "data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-FRQ.frq", header = T  )
png( paste("results/17_quality_filter_variants_imputed/MAF_data_SNPs_imputed.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$MAF, main =  "Histogram of MAF data per SNP imputed", xlab = "MAF data rate per SNP")
dev.off()

png( paste("results/17_quality_filter_variants_imputed/MAF_data_SNPs_imputed_zoom.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$MAF, main =  "Histogram of MAF data per SNP imputed", xlab = "MAF data rate per SNP", xlim = c(0,0.1), breaks = 80)
dev.off()

