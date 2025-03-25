missing <- read.table("data_processing/6_quality_filters_variants/LACRN-missing.imiss", header = T)
missing$GT <- 100-(missing$F_MISS*100)
print("Promedio GT en set:")
mean(missing$GT)

samplesheet <- read.delim("inputs/2_quality_control/SampleSheet.csv")
info <- merge(samplesheet, missing, by.x ="Sample_ID", by.y = "FID")

countrys <- levels(info$Country)
for (c in countrys){
	print("########")
	print(c)
	data_temp <- info[info$Country == c,]
	print("N samples country:")
	print(length(data_temp[,1]))
	print("GT country")
	print(mean(data_temp$GT))
}

print("#############################")
missing2 <- read.table("data_processing/7_quality_filters_samples/LACRN_samples-missing.imiss", header = T)
missing2$GT <- 100-(missing2$F_MISS*100)
print("Promedio GT en set filtrado:")
mean(missing2$GT)
info <- merge(missing2 , samplesheet, by.y ="Sample_ID", by.x = "FID")
info <- info[info$GT >= 90,]


for (c in countrys){
        print("########")
        print(c)
        data_temp <- info[info$Country == c,]
        print("N samples filter country:")
        print(length(data_temp[,1]))
        print("GT filter country")
        print(mean(data_temp$GT))
}






