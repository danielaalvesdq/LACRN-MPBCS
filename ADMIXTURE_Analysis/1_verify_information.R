#Cristian Yáñez, Ingeniero Bioinformático Universidad de talca. Departamento de Genetica humana, laboratorio ChileGenomico, Facultad de Medicina, Universidad de Chile.
#16/01/2020
#Script para el verificar que todas las muestras contenidas en el sampleSheet estén presentes en la carpeta inputs/RawData

args <- commandArgs(TRUE)
#samples_csv <- args[1]
samples_csv <- "inputs/1_verify_information_and_data/samples_US-LACRN.csv"
samples_all <- read.csv(samples_csv)
head(samples_all)

lista_print <- ""
folders_csv <- levels(as.factor(samples_all$SentrixBarcode_A))
folders_RawData <- system("ls inputs/RawData", intern = T)

lista_print <- append(lista_print, "*** Carpetas (CHIP) Presentes en CSV y en RaWData")
lista_print <- append(lista_print, folders_RawData[folders_RawData %in% folders_csv ])
lista_print <- append(lista_print, "*** Carpetas faltantes en CSV, que están presentes en RaWData")
lista_print <- append(lista_print, folders_RawData[!folders_RawData %in% folders_csv ])
lista_print <- append(lista_print, "*** Carpetas faltantes en RawData, que están presentes en CSV")
lista_print <- append(lista_print, folders_csv[!folders_csv %in% folders_RawData ] )

##Generamos listas de muestras en datos brutos (RawData) e información (CSV)
list_all_files_RawData <- system("find inputs/RawData", intern = T)
list_all_samples_RawData <- list_all_files_RawData[ grepl(paste(c("_Grn.idat","_Red.idat" ), collapse = "|"), list_all_files_RawData)]
list_all_samples_RawData <- gsub("_Grn.idat", "", list_all_samples_RawData)
list_all_samples_RawData <- gsub("_Red.idat", "", list_all_samples_RawData)
list_all_samples_RawData <-  levels(as.factor(list_all_samples_RawData))
list_all_samples_RawData <- gsub(".+/", "", list_all_samples_RawData, perl=T)
list_all_samples_CSV <- as.vector(samples_all$Sample_ID)

lista_print <- append(lista_print, "*** Número de muestras en CSV con datos brutos:")
list_match_samples <- list_all_samples_CSV[list_all_samples_CSV %in% list_all_samples_RawData]
lista_print <- append(lista_print, length(list_match_samples))

lista_print <- append(lista_print, "*** Lista de muestras con datos brutos RawData sin información en CSV:" )
list_unmatch_samples <- list_all_samples_RawData[!list_all_samples_RawData %in% list_all_samples_CSV]
lista_print <- append(lista_print, list_unmatch_samples)

lista_print <- append(lista_print, "*** Lista de muestras con información en CSV pero sin sin datos brutos RawData" )
list_unmatch_samples <- list_all_samples_CSV[!list_all_samples_CSV %in% list_all_samples_RawData]
lista_print <- append(lista_print, list_unmatch_samples)



##Genero subset CSV de muestras con datos brutos 
samples_all$Country_Source <- ifelse(as.vector(samples_all$Country) == as.vector(samples_all$Source), as.vector(samples_all$Country) , as.vector(paste(samples_all$Country, samples_all$Source,sep = "_")))
samples_used <- samples_all[samples_all$Sample_ID %in% list_match_samples,]

lista_print <- append(lista_print, "*** Lista de muestras repetidas/duplicadas en CSV con solo una carpeta en RawData (se excluirán):")
samples_duplicated <- as.vector( samples_used$Sample_ID[duplicated(samples_used$Sample_ID)])
lista_print <- append(lista_print, samples_duplicated)

lista_print <- append(lista_print, "*** ID de muestras repetidas/duplicadas en CSV")
samples_duplicated2 <- as.vector(samples_used$Name[duplicated(samples_used$Name)])
lista_print <- append(lista_print, samples_duplicated2)

##Eliminamos muestras con identificador duplicado
samples_used <- samples_used[!samples_used$Sample_ID %in% samples_duplicated,]
samples_used <- samples_used[!samples_used$Name %in% samples_duplicated2,]

##samplesheet incluido las muestras a descartar (DISCARD)
samples_used$Path_all <- paste( samples_used$Path,samples_used$Sample_ID ,sep="/")
write.table(samples_used, file="results/1_verify_information_and_data/samples_US-LACRN_available_WITH_DISCARD.csv", sep = "\t", row.names = F, quote = F)

lista_print <- append(lista_print, "*** N° de muestras con DISCARD")
n_discard <- table(samples_used$Discard)[2]
lista_print <- append(lista_print, n_discard)

lista_print <- append(lista_print, "*** N° de muestras con utilizables, sin DISCARD, sin duplicados y con datos brutos en RawData")
n_used <- table(samples_used$Discard)[1]
lista_print <- append(lista_print, n_used)

lista_print <- append(lista_print, "*** Lista de muestras a usar en análisis posteriores en archivo: results/1_verify_information_and_data/samples_US-LACRN_available.csv y results/1_verify_information_and_data/SampleSheet.csv" )
lista_print <- lista_print[-1]

##Eliminanos muestras con DISCARD x
samples_used <- samples_used[!samples_used$Discard == "x",]

##Escribimos nuevo SampleSheet
write.table(samples_used, file="results/1_verify_information_and_data/samples_US-LACRN_available.csv", sep = "\t", row.names = F, quote = F)
write.table( subset(samples_used, select = c("Sample_ID", "SentrixBarcode_A", "SentrixPosition_A", "Path", "Name","Gender", "Date","Country","Source", "Path_all","Country_Source")), file="results/1_verify_information_and_data/SampleSheet.csv", sep = "\t", row.names = F, quote = F)
write.table(lista_print, file= "results/1_verify_information_and_data/Log_samples.txt", quote= F, row.names = F, col.names = F)
write.table(table(samples_all$Country_Source), file= "results/1_verify_information_and_data/table_Country_Source_all.tsv", quote= F, row.names = F, col.names = F)
write.table(table(samples_used$Country_Source), file= "results/1_verify_information_and_data/table_Country_Source_used.tsv", quote= F, row.names = F, col.names = F)



