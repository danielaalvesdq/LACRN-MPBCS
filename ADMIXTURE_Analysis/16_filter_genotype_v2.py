#/usr/bin/python
import sys
import os

##Desarrollado por Cristian Yanez, 10-09-2018 para filtrar las probabilidades posteriores de los genotipos imputados obtenidos con IMPUTE2

#Ejecutar como: python filter_genotype_v2.py archivo.impute valor_pbb_minimo valor_pbb_maximo caracter_cambio > archivo_nuevo.impute
#Ejecutar como: python filter_genotype_v2.py head_15.imputed 0.4 0.6 . > archivo_nuevo.impute

ar = open(sys.argv[1], "r")
value_min = sys.argv[2]
value_max = sys.argv[3]
character_change = sys.argv[4]

for line in ar:
	line = line.rstrip("\n")
	aux = line.split(" ")
	aux2 = aux[5:]
	line2 = aux[0:5]
	line2_final = ""	##Linea que almancena informacion inicial de SNP [0-4]
	for i in range(0,len(line2)):
		line2_final = line2_final+line2[i]+" "
	list_change = []	##Lista que almacena las probabilidades	
	for i in range(0,len(aux2),3):
		e1 = aux2[i]
		e2 = aux2[i+1]
		e3 = aux2[i+2]
		if (float(e1) < float(value_max) and float(e1) > float(value_min) ) or (float(e2) < float(value_max) and float(e2) > float(value_min) ) or (float(e3) < float(value_max) and float(e3) > float(value_min)):
			e1 = character_change
			e2 = character_change
			e3 = character_change
			list_change.append(e1)
			list_change.append(e2)
			list_change.append(e3)
		else:
			list_change.append(aux2[i])
			list_change.append(aux2[i+1])
			list_change.append(aux2[i+2])
	for i in range(0, len(list_change)):
		line2_final = line2_final+list_change[i]+" "
	print line2_final[:-1]	

ar.close()
