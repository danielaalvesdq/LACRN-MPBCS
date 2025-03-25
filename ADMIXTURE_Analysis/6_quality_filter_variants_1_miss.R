lmiss_SNP_proyect <- read.table( "data_processing/6_quality_filters_variants/LACRN-missing.lmiss", header = T  )
png( paste("results/6_quality_filters_variants/Hist_missing_data_SNPs.png" , sep = ""), height=500, width=600)
hist(lmiss_SNP_proyect$F_MISS, main =  "Histogram of rate of missing data per Variants", xlab = "Missing data rate per Variant")
dev.off()
print("results/6_quality_filters_variants/Hist_missing_data_SNPs.png" )

#bim <- read.table("results/6_quality_filters_variants/LACRN_filter2.bim", sep="\t")
#print("1=bialelicos, 2=trialelicos, 3=tetra-alelicos")
#print( table(  table(bim$V2)))
