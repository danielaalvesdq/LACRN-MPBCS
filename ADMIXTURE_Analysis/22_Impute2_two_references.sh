#!/bin/bash
CHR=$1
CHUNK_START=`printf "%.0f" $2`
CHUNK_END=`printf "%.0f" $3`

# directorios
RESULTS_DIR="results/22_IMPUTAR_LACRN_1000G_AMR/" 
# ejecutable (IMPUTE version 2.2.0 o superior)
IMPUTE2_EXEC=impute2
# parameters
NE=20000
# archivos de referencia de 1000 genomas.
GENMAP_FILE="resources/1000G/1000GP_Phase3/genetic_map_chr${CHR}_combined_b37.txt"
HAPS_FILE="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.hap.gz"
LEGEND_FILE="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.legend.gz"

#archivos de referencia AMR imputada y faseada
HAPS_FILE_AMR="results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${CHR}-format-impute2.haps"
LEGEND_FILE_AMR="results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${CHR}-format-impute2.legend" 

# haplotipos generados con SHAPEIT 
GWAS_HAPS_FILE="results/16_phase_and_imputation/LACRN-chr${CHR}.haps"
# salida archivos imputados.
OUTPUT_FILE="${RESULTS_DIR}LACRN_REF_1000G-AMR.chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.impute2"
## linea de comando
$IMPUTE2_EXEC \
   -merge_ref_panels \
   -use_prephased_g \
   -m $GENMAP_FILE \
   -known_haps_g $GWAS_HAPS_FILE \
   -h $HAPS_FILE $HAPS_FILE_AMR\
   -l $LEGEND_FILE $LEGEND_FILE_AMR\
   -Ne $NE \
   -int $CHUNK_START $CHUNK_END \
   -o $OUTPUT_FILE \
   -allow_large_regions \
   -seed 367946 &
