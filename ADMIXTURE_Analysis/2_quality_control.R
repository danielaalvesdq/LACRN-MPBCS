#Cristian Yáñez, Ingeniero Bioinformático Universidad de talca. Departamento de Genetica humana, laboratorio ChileGenomico, Facultad de Medicina, Universidad de Chile.
#06/01/2020
#Script para el control de calidad de muestras del proyecto LACRN genotipificadas por array infinium Illumina

library(Biobase)
library(crlmm)
library(ggplot2)
#library(ff)
#library(hapmap370k)
args <- commandArgs(TRUE)



data.dir = "inputs/RawData/"
samples_info = args[1]
####samples_info = "data_processing/2_quality_control/SampleSheet-Uruguay_26-9-2019-BATCH.tsv"
# Read in sample annotation info
samples = read.delim(samples_info, as.is=TRUE)
samples$DateCountry <- paste(samples$Country,samples$Date, sep = "_")
samples$DateCountry <-  gsub("/", "-", samples$DateCountry )
head(samples)
name_file <- samples$DateCountry[1]
name_file

# Read in .idats using sampleSheet information
RG = readIdatFiles(samples, path=".", arrayInfoColNames=list(barcode=NULL,position="Path_all"),saveDate=TRUE)
print(dim(RG))
print(slotNames(RG))
print(channelNames(RG))
  #exprs(channel(RG, "R"))[1:5,1:5] #intensidades de red
  #exprs(channel(RG, "G"))[1:5,1:5] #intensidades de green
  #pd = pData(RG)
  #pd[1:5,] 
  
# Obtenemos fechas de genotipado de muestras
scandatetime = strptime(protocolData(RG)[["ScanDate"]], "%m/%d/%Y %H:%M:%S %p")
datescanned = substr(scandatetime, 1, 10) #Obtenemos fecha de escaneo o genotipado en array
scanbatch = factor(datescanned)
#levels(scanbatch) = 1:16
  
png(  paste("results/2_quality_control/", name_file, "_Raw_intensities.png", sep=""), height=800, width=1000)
par(mfrow=c(2,1), mai=c(0.4,0.4,0.4,0.1), oma=c(1,1,0,0))
boxplot(log2(exprs(channel(RG, "R"))), xlab="Array", ylab="", names=1:dim(RG)[2], main="Red channel",outline=FALSE,las=2)
boxplot(log2(exprs(channel(RG, "G"))), xlab="Array", ylab="", names=1:dim(RG)[2], main="Green channel",outline=FALSE,las=2)
mtext(expression(log[2](intensity)), side=2, outer=TRUE)
mtext("Array", side=1, outer=TRUE)
dev.off()
  
#boxplot(log2(exprs(channel(RG, "R"))), outline=FALSE, space = 2, col='red')
#boxplot(log2(exprs(channel(RG, "G"))), outline=FALSE, space = c(3,2,2), col='green', add=T)
#boxplot(log2(exprs(channel(RG, "R"))) ~ log2(exprs(channel(RG, "G"))), col=c("red","green2"), outline=FALSE)
  
#Control de calidad
#Por el momento no se puede realizar por que la suma exece el tamaño logico de un valor numerico
#QC_raw_intensities_R <- apply( log2( exprs(channel(RG, "R")))   , 2, mean)
#QC_raw_intensities_G <- apply( log2( exprs(channel(RG, "G")))   , 2, mean)
#exprs(channel(RG, "R"))[1:2315574,1:2]
####write.table(exprs(channel(RG, "R")), file = paste("results/2_quality_control/QC_raw_intensities_R_",c,".tsv",sep = ""), sep = "\t", quote = F)
####write.table(exprs(channel(RG, "G")), file = paste("results/2_quality_control/QC_raw_intensities_G_",c,".tsv", sep = ""), sep = "\t", quote = F)
####write.table(colnames(exprs(channel(RG, "R"))), file = paste("results/2_quality_control/Samples_",c,".tsv", sep = ""), sep = "\t", quote = F, row.names = F, col.names = F)
  
####}







