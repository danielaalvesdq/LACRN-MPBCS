frq_LACRN <- read.table( "data_processing/6_quality_filters_variants/FRQ_LACRN.frq", header = T  )
png( paste("results/6_quality_filters_variants/MAF_data_SNPs.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$MAF, main =  "Histogram of MAF data per SNP", xlab = "MAF data rate per SNP")
dev.off()

png( paste("results/6_quality_filters_variants/MAF_data_SNPs_zoom.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$MAF, main =  "Histogram of MAF data per SNP", xlab = "MAF data rate per SNP", xlim = c(0,0.1), breaks = 80)
dev.off()

frq_LACRN$NCHRA1MAF <-   frq_LACRN$NCHROBS * frq_LACRN$MAF
frq_LACRN$NSAMPLEA1MAF <- as.integer(frq_LACRN$NCHRA1MAF/2)

png( paste("results/6_quality_filters_variants/N_chrom_MAF_allele.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$NCHRA1MAF, main =  "Histogram of the number of chromosomes where \nthe MAF allele is present", xlab = "N° Chromosomes per MAF Allele")
dev.off()

png( paste("results/6_quality_filters_variants/N_chrom_MAF_allele_zoom.png" , sep = ""), height=500, width=600)
hist(frq_LACRN$NCHRA1MAF, main =  "Histogram of the number of chromosomes where \nthe MAF allele is present", xlab = "N° Chromosomes were ",xlim = c(0,100), breaks = 150)
dev.off()



N_SAMPLE_SNP <- as.data.frame(  table(frq_LACRN$NSAMPLEA1MAF))

colnames(N_SAMPLE_SNP) <- c("N_SAMPLE_MAF_ALLELE", "N_SNP")
N_SAMPLE_SNP$N_SAMPLE_MAF_ALLELE <- as.vector(N_SAMPLE_SNP$N_SAMPLE_MAF_ALLELE)

png( paste("results/6_quality_filters_variants/N_SNP_per_N_SAMPLE_allele1_MAF.png" , sep = ""), height=500, width=600)
barplot(N_SAMPLE_SNP$N_SNP , names.arg =  c(0:(length(N_SAMPLE_SNP$N_SNP)-1)), border="blue3", main="N° of MaF allele per Samples",xlab="Count of samples whit MAF allele", ylab = "Frequency of MAF allele", xlim= c(1,50))
dev.off()

png( paste("results/6_quality_filters_variants/N_SNP_per_N_SAMPLE_allele1_MAF_2.png" , sep = ""), height=500, width=600)
barplot(N_SAMPLE_SNP$N_SNP , names.arg =  c(0:(length(N_SAMPLE_SNP$N_SNP)-1)), border="blue3", main="N° of MaF allele per Samples",xlab="Count of samples whit MAF allele", ylab = "Frequency of MAF allele", xlim= c(1,50))
dev.off()


