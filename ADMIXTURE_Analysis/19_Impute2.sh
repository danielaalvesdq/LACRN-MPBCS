#!/bin/bash
CHR=$1
CHUNK_START=`printf "%.0f" $2`
CHUNK_END=`printf "%.0f" $3`

# directorios
ROOT_DIR="data_processing/19_phase_impute_SGDP/"
DATA_DIR="resources/1000G/1000GP_Phase3/"
RESULTS_DIR="results/19_phase_impute_SGDP/" 
# ejecutable (IMPUTE version 2.2.0 o superior)
IMPUTE2_EXEC=impute2
# parameters
NE=20000
# archivos de referencia de 1000 genomas.
GENMAP_FILE="resources/1000G/1000GP_Phase3/genetic_map_chr${CHR}_combined_b37.txt"
HAPS_FILE="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.hap.gz"
LEGEND_FILE="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.legend.gz"
# haplotipos generados con SHAPEIT 
GWAS_HAPS_FILE="results/19_phase_impute_SGDP/SGDP-chr${CHR}.haps"
# salida archivos imputados.
OUTPUT_FILE="${RESULTS_DIR}SGDP.chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.impute2"
## linea de comando
$IMPUTE2_EXEC \
   -m $GENMAP_FILE \
   -known_haps_g $GWAS_HAPS_FILE \
   -h $HAPS_FILE \
   -l $LEGEND_FILE \
   -Ne $NE \
   -int $CHUNK_START $CHUNK_END \
   -o $OUTPUT_FILE \
   -allow_large_regions \
   -seed 367946 &
