#!/bin/bash
#$ -cwd
CHR=$1
# directorios
ROOT_DIR="data_processing/19_phase_impute_SGDP/"
DATA_DIR="resources/1000G/1000GP_Phase3/"
RESULTS_DIR="results/19_phase_impute_SGDP/"
# ejecutable de SHAPEIT
SHAPEIT_EXEC=shapeit
# parametros
THREAT=95
EFFECTIVESIZE=20000
# archivo de referencias
GENMAP_FILE="resources/1000G/1000GP_Phase3/genetic_map_chr${CHR}_combined_b37.txt"
# input en formato PLINK binario
GWASDATA_BED="data_processing/19_phase_impute_SGDP/SGDP-chr${CHR}.bed"
GWASDATA_BIM="data_processing/19_phase_impute_SGDP/SGDP-chr${CHR}.bim"
GWASDATA_FAM="data_processing/19_phase_impute_SGDP/SGDP-chr${CHR}.fam"
# output
OUTPUT_HAPS="results/19_phase_impute_SGDP/SGDP-chr${CHR}.haps"
OUTPUT_SAMPLE="results/19_phase_impute_SGDP/SGDP-chr${CHR}.sample"
OUTPUT_LOG="results/19_phase_impute_SGDP/SGDP-chr${CHR}.log"
# panel de referencias de 1000G, necesario cuando se van a imputar menos de 20 individuos, ignorar en caso contrario.
REF_HAP="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.hap.gz"
REF_LEGEND="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.legend.gz"
REF_SAMPLE="resources/1000G/1000GP_Phase3/1000GP_Phase3.sample"
## ejecucion
$SHAPEIT_EXEC \
--input-bed $GWASDATA_BED $GWASDATA_BIM $GWASDATA_FAM \
--input-map $GENMAP_FILE \
--thread $THREAT \
--input-ref $REF_HAP $REF_LEGEND $REF_SAMPLE \
--effective-size $EFFECTIVESIZE \
--output-max $OUTPUT_HAPS $OUTPUT_SAMPLE \
--output-log $OUTPUT_LOG
