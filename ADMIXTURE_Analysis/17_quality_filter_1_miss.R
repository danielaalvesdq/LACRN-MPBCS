lmiss_SNP_proyect <- read.table( "data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered-missing.lmiss", header = T  )
png( paste("results/17_quality_filter_variants_imputed/Hist_missing_data_SNPs_imputed.png" , sep = ""), height=500, width=600)
hist(lmiss_SNP_proyect$F_MISS, main =  "Histogram of rate of missing data per Variants imputed", xlab = "Missing data rate per Variant")
dev.off()
print("results/17_quality_filter_variants_imputed/Hist_missing_data_SNPs_imputed.png" )

#bim <- read.table("results/6_quality_filters_variants/LACRN_filter2.bim", sep="\t")
#print("1=bialelicos, 2=trialelicos, 3=tetra-alelicos")
#print( table(  table(bim$V2)))
