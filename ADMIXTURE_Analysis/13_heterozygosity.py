#!/usr/bin/python


# Open a file
fo = open("data_processing/13_Dendogram_and_otherQC/LACRN_filter4_0_MAF_recodeA.raw", "r")


print ("Sample\tName\tPercent_Heterozigosity")
for line in fo:
	line=line.rstrip("\n")
	if line.startswith( 'FID' ) == False:
		aux = line.split(" ")
		ID_raw = aux[0]
		sampleID = aux[1]
		Genos = aux[6:]
		N_Genos = len(Genos)
		countHeterozigosity = Genos.count('1')
		NA = Genos.count('NA')
		N_Genos = N_Genos-NA
		percentHetero = (float(countHeterozigosity)*100) / float(N_Genos)
		print (ID_raw+"\t"+sampleID+"\t"+str(percentHetero))
fo.close()


#1304150
