1. Verify data information, present and missing samples
2. Data quality control
   Infinium II MEGA arrays in samples
3. Convert GTC to VCF, aligning the probes to obtain the variants
   polymorphic sequences ordered against the reference genome hg19
4. Convert VCF to plink
5. Quality filter in variants
6. Quality filter in samples
7. Quality control by origin/country
8. MAF filter
9. Sex and kinship filters
10. PCA only in LACRN samples
11. Create LACRN+REF set for PCA
12. Dendrogram , % Heterozygotes and extra quality controls
13. Admixture
14. Admixture on windows
15. Phase and imputation of set LACRN (1000G)
16. Quality control of imputed set variants
17. Create set for RFMIX
18. Phase and imputation of SGDP set
19. Phasing and imputation of set PATAGONIA
20. Join sets of imputed Amerindian references
21. Phasing and imputation of LACRN set (1000G + PAT + SGDP)
22. Imputation Metrics
23. Pop info samples

# Pipeline directory structure

The working directory path for the pipeline on AMAZON EC2 is:

`/home/ec2-user/1_US_LACRN/160120_Pipeline_US_LACRN`

The directory structure is as follows:

```
` Pipeline_US_LACRN /`
` ├ ── code `
`│ └── dump `
` ├ ── data_processing `
`│ ├ ── 10_quality_filters_sex_relationship`
`│ ├ ── 11_PCA_MAF_0_1`
`│ ├ ── 12_1000G_REF_LACRN_SET`
`│ ├ ── 13_Dendogram_and_otherQC`
`│ ├ ── 14_Admixture`
`│ ├ ── 15_Admixture_windows`
`│ ├ ── 16_phase_and_imputation`
`│ ├ ── 17_quality_filter_variants_imputed`
`│ ├ ── 18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN`
`│ ├ ── 19_phase_impute_SGDP`
`│ ├ ── 20_phase_impute_PATAGONIA`
`│ ├ ── 21_merge_PATAGONIA_SGDP_IMPUTED`
`│ ├ ── 22_IMPUTAR_LACRN_1000G_AMR`
`│ ├ ── 2_quality_control`
`│ ├ ── 3_genotyping`
`│ ├ ── 5_vcf2plink`
`│ ├ ── 6_quality_filters_variants`
`│ ├ ── 7_quality_filters_samples`
`│ ├ ── 8_filters_by_country`
`│ ├ ── 8_PCA`
`│ ├ ── 9_quality_filters_part2`
`│ └── dump `
` ├ ── data_temp `
` ├ ── inputs`
`│ ├ ── 12_1000G_REF_LACRN_SET`
`│ ├ ── 14_Admixture`
`│ ├ ── 15_Admixture_windows`
`│ ├ ── 16_phase_and_imputation`
`│ ├ ── 18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN`
`│ ├ ── 1_verify_information_and_data`
`│ ├ ── 24_new_popinfo`
`│ ├ ── 2_quality_control`
`│ ├ ── 3_genotyping`
`│ ├ ── 4_GTC2VCF_Alignment`
`│ ├ ── 6_quality_filters_variants`
`│ ├ ── 7_quality_filters_samples`
`│ ├ ── 8_filters_by_country`
`│ ├ ── 8_PCA`
`│ └── RawData `
` ├ ── resources `
`│ ├ ── 1000G`
`│ └── reference_sets `
`└── results `
` ├ ── 10_quality_filters_sex_relationship`
` ├ ── 11_PCA_MAF_0_1`
` ├ ── 12_1000G_REF_LACRN_SET`
` ├ ── 13_Dendogram_and_otherQC`
` ├ ── 14_Admixture`
` ├ ── 15_Admixture_windows`
` ├ ── 16_phase_and_imputation`
` ├ ── 17_quality_filter_variants_imputed`
` ├ ── 18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN`
` ├ ── 19_phase_impute_SGDP`
` ├ ── 1_verify_information_and_data`
` ├ ── 20_phase_impute_PATAGONIA`
` ├ ── 21_merge_PATAGONIA_SGDP_IMPUTED`
` ├ ── 22_IMPUTAR_LACRN_1000G_AMR`
` ├ ── 23_metrics_IMPUTED`
` ├ ── 24_new_popinfo`
` ├ ── 2_quality_control`
` ├ ── 3_genotyping`
` ├ ── 4_GTC2VCF_Alignment`
` ├ ── 5_vcf2plink`
` ├ ── 6_quality_filters_variants`
` ├ ── 6_snptracker`
` ├ ── 7_quality_filters_samples`
` ├ ── 8_filters_by_country`
` ├ ── 8_PCA`
` ├ ── 9_quality_filters_part2`
` ├ ── dump `
` ├ ── temporary`
` └── USLACRN_data_clean `
```

# US-LACRN Pipeline

## Step 1 - Verify data information, present and missing samples in SampleSheet and raw data

- We create SampleSheets of samples, with information obtained from
  array.xls

<!-- -->

- The following R script parses the created SampleSheet and the list of
  raw data genotyped and available in
  Pipeline_US_LACRN /inputs/ RawData /. Displays information about the
  arrays present in SampleSheet and raw data; present only in
  SampleSheet ; present only in raw data, duplicate samples,
  Missing samples in SampleSheet that are present in raw data
  and generates a new SampleSheet with only the sample information
  usable (which are common in the SampleSheet and in the data)
  raw). Run it as:

`Rscript code/1_verify_information_and_data/1_verify_information.R \ `
`inputs/1_verify_information_and_data/samples_US-LACRN.csv`

- Exit:

```
 results /1_verify_information_and_data/SampleSheet.csv
```

- Contains ordered information about the samples

`cp results/1_verify_information_and_data/SampleSheet.csv inputs/2_quality_control/`

## Stage 2 - Quality control of raw intensities from idats files

- I create a list with sample identifier in a file and a batch composed of
  Country_Date

`awk '{print $1"\t"$8"_"$7}' inputs/2_quality_control/SampleSheet.csv > \ `
` data_processing /2_quality_control/ ID_BATCH.tsv `
`cat data_processing/2_quality_control/ID_BATCH.tsv |  sed 's/\//-/g' > \ `
` data_processing /2_quality_control/ID_BATCH_2.tsv`
`head data_processing /2_quality_control/ID_BATCH_2.tsv`
` Sample_ID  Country_Date `
`203299640174_R02C01 Brazil_4-9-2019`
`203299640174_R03C01 Brazil_4-9-2019`
`203299640174_R04C01 Brazil_4-9-2019`
`203299640174_R05C01 Brazil_4-9-2019`
`203299640174_R06C01 Brazil_4-9-2019`
`203299640174_R07C01 Brazil_4-9-2019`
`203299640174_R08C01 Brazil_4-9-2019`
`203299640110_R01C01 Brazil_4-9-2019`
`203299640110_R02C01 Brazil_4-9-2019`

Create list of BATCHs`
`awk '{print $2}' data_processing/2_quality_control/ID_BATCH_2.tsv | tail -n +2| sort | uniq > \ `
` data_processing /2_quality_control/ BATCH.list `
`head data_processing /2_quality_control/ BATCH.list `
Argentina_10-10-2019
Argentina_11-11-2019
Argentina_10-15-2019
Argentina_2-10-2019
Argentina_21-10-2019
Argentina_23-10-2019
Argentina_30-10-2019
Argentina_November 4, 2019
Argentina_November 6, 2019
Argentina_10-7-2019

There are 38 different batches

- I go through batch and create a list of identifiers per batch , I create a sample
  sheet by BATCH and run Rscript to graph intensities of
  red and green channels for the respective BATCH samples

`Input=" data_processing /2_quality_control/ BATCH.list "`
` while read LINE`
` do`
` echo "#######################################"`
` echo $LINE`
` echo "Number of samples per batch :"`
` grep $LINE data_processing/2_quality_control/ID_BATCH_2.tsv | wc -l`
` echo "File with list of samples by BATCH CREATED:"`
` echo " data_processing /2_quality_control/$LINE- BATCH.tsv "`
` #grep $LINE data_processing/2_quality_control/ID_BATCH_2.tsv > \ `
` data_processing /2_quality_control/$LINE- BATCH.tsv `
` grep $LINE data_processing/2_quality_control/ID_BATCH_2.tsv | awk '{print $1}' > \ `
` data_processing /2_quality_control/$LINE- BATCH.tsv `
` echo " Sample Sheet by batch :"`
` echo "data_processing/2_quality_control/SampleSheet-$LINE-BATCH.tsv"`
` head -n 1 inputs/2_quality_control/SampleSheet.csv > \ `
` data_processing /2_quality_control/ SampleSheet -$LINE- BATCH.tsv `
` cat inputs/2_quality_control/SampleSheet.csv | grep -f \ `
` data_processing /2_quality_control/$LINE- BATCH.tsv >> \ `
` data_processing /2_quality_control/ SampleSheet -$LINE- BATCH.tsv `
` echo "We plot raw intensities by batch :"`
` echo " Rscript code /2_quality_control.R \ `
` data_processing /2_quality_control/ SampleSheet -$LINE- BATCH.tsv "`
` Rscript code /2_quality_control.R \ `
` data_processing /2_quality_control/ SampleSheet -$LINE- BATCH.tsv `
`done < $Input`

- Exit:

` results /2_quality_control/ QC_raw_intensities_R _*`
` results /2_quality_control/ QC_raw_intensities_G _*`
` results /2_quality_control/ Samples _*`
` results /2_quality_control/", name_file , "_Raw_intensities.png`

## Step 3 - Genotyping samples, generating GTC files

- We use Illumina Gencall to genotype MEGA LACRN samples

`$HOME/bin/iaap-cli/iaap-cli gencall inputs/3_genotyping/Multi-EthnicGlobal_D1.bpm \ `
`inputs/3_genotyping/Multi-EthnicGlobal_D1_ClusterFile.egt results/3_genotyping -f inputs/RawData \ `
`-g -t 8`

- Exit:

` results /3_genotyping/FOLDER_CHIP/*. gtc`

- We confirmed that all samples in inputs/ RawData were
  genotyped

`find inputs/RawData | grep idat | cut -d / -f 4 | awk '{ gsub(/_Red.idat/, "" ); print; }' |  \`
` awk '{ gsub (/_ Grn.idat /, "" ); print ; }' | sort | uniq > \ `
` data_processing /3_genotyping/ List_RawData_Sample.list `
`find results/3_genotyping/ | grep gtc | cut -d / -f 4 | awk '{ gsub(/.gtc/, "" ); print; }' |  \`
`sort | uniq > data_processing/3_genotyping/List_RawData_Sample_Genotyped.list`
`comm -23 data_processing/3_genotyping/List_RawData_Sample.list \ `
` data_processing /3_genotyping/ List_RawData_Sample_Genotyped.list `

Sample 203299640181_R01C01 was not genotyped , the output is error
delivered by the program is as follows:

`(base) -bash-4.2$ $HOME/bin/iaap-cli/iaap-cli gencall inputs/3_genotyping/Multi-EthnicGlobal_D1.bpm \ `
`inputs/3_genotyping/Multi-EthnicGlobal_D1_ClusterFile.egt results/ -f `
`inputs/temporary/ -g`
` info : ArrayAnalysis.NormToGenCall.CLI.App [0]`
` [06:00:23 1435]: Crawling inputs/temporal/ for samples ...`
` info : ArrayAnalysis.NormToGenCall.CLI.App [0]`
` [06:00:23 2619]: Number of samples to process : 1`
` info : ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc [0]`
` [06:00:23 2844]: `
` Starting processing ...`
`Manifest file: inputs/3_genotyping/Multi-EthnicGlobal_D1.bpm`
` Cluster file: inputs/3_genotyping/Multi-EthnicGlobal_D1_ClusterFile.egt`
` Include file: `
` Output directory : results /`
` GenCall score cutoff : 0.15`
` GenTrain ID: 3`
Gender Dear Settings : `
Version : 2
` MinAutosomalLoci : 100`
` MaxAutosomalLoci : 10000`
` MinXLoci : 20`
` MinYLoci : 20`
` AutosomalCallRateThreshold : 0.97`
` YIntensityThreshold : 0.3`
` XIntensityThreshold : 0.9`
` XHetRateThreshold : 0.1`
` Output Settings : `
`Output GTC: True`
`Output PED: False`
` PED tab delimited : False`
` PED use customer strand : False`
` Number of threads : 1`
` Buffer size : 131072`
` `
` info : ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc [0]`
` [06:00:23 2862]: Loading Manifest ...`
` info : ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc [0]`
` [06:01:16 6827]: Loading Cluster File...`
` info : ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc [0]`
` [06:01:34 5526]: Normalizing 203299640181_R01C01...`
`info: ArrayAnalysis.NormToGenCall.Services.SampleNormToGenCallSvc[0]`
` [06:01:34 5610]: Loading inputs/temporal/203299640181_R01C01_Red.idat...`
`info: ArrayAnalysis.NormToGenCall.Services.SampleNormToGenCallSvc[0]`
` [06:01:37 2806]: Loading inputs/temporal/203299640181_R01C01_Grn.idat...`
` fail : ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc [0]`
` [06:01:43 7882]: Failed to normalize or gencall - 203299640181_R01C01: Normalization failed \ `
`for sample: 203299640181_R01C01! This is likely a BPM and IDAT mismatch. `
`ERROR: Index was outside the bounds of the array.`
` at ArrayAnalysis.NormToGenCall.Services.SampleNormToGenCallSvc.Normalize(NormalizationBase \ `
`normAlg, Manifest manifest, Byte[] transformLookups, Boolean needGreen, `
`Boolean needRed, SampleData sample, String[] includeLociNames) in \ `
`/src/ArrayAnalysis.NormToGenCall.Services/Services/SampleNormToGenCallSvc.cs:line 132`
` at ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc.<>c__DisplayClass7_0.`<Run>`b__2 \`
`( SampleData sample ) in `
`/src/ArrayAnalysis.NormToGenCall.Services/Services/NormToGenCallSvc.cs:line 113`
` info : ArrayAnalysis.NormToGenCall.Services.NormToGenCallSvc [0]`
` [06:01:44 0122]: Elapsed minutes: 1.34551666666667`

The error is as follows: <b> Failed to normalize or gencall -
203299640181_R01C01: Normalization failed for sample :
203299640181_R01C01! This es likely a BPM and IDAT mismatch . </b>. It
which means that the array data for this sample (IDAT), does not
correspond to the BPM file, binary manifest with the information of
the SNPs in the array. The sample <b>203299640181_R01C01</b> must be
repeated genotyping.

### Missing samples

- We copied the missing sample files, corresponding to 55
  Samples contained in Chile's S3, copied on 04/04/2020

`aws s3 cp s3://ancestry.chile/RawData/PendingRawData ./PendingRawData --recursive`

- Create genotyping output folder

` mkdir results /3_genotyping/ PendingRawData `

- We use Illumina Gencall to genotype the new MEGA samples
  LACRN <b>Attach link and official documentation</b>

`$HOME/bin/iaap-cli/iaap-cli gencall inputs/3_genotyping/Multi-EthnicGlobal_D1.bpm \ `
`inputs/3_genotyping/Multi-EthnicGlobal_D1_ClusterFile.egt results/3_genotyping/PendingRawData \ `
`-f $HOME/ PendingRawData -g -t 8`

- Exit:

` results /3_genotyping/FOLDER_CHIP/*. gtc`

## Step 4 - Convert GTC files to VCF

We use bcftools +gtc2vcf, bcftools <b>add documentation
bcftools </b> which is a tool for manipulating files
bcftools plugin called <b>gt2vcf</b>
which is used together with this one to convert the GTC files that
contain the genotyped variants per sample in VCF format. For
This uses the sequence information of the probes contained in
egt file of the array and aligns these sequences and information
of the genotype obtained against the reference genome hg19 using the
bwa algorithm mem . As a result we have a VCF file (in binary,
bcf ) where the genotypes are located on the forward strand of the
reference of the human genome. In this way we avoid possible errors in
Illumina manifesto , where the orientation of
the probes used for genotyping It is given by the supplier, not
being guided by some reference genome or databases
as dbSNP .

- The command to convert GTC files to VCF is as follows:

`find results/3_genotyping/ | grep gtc > inputs/4_GTC2VCF_Alignment/listGTC.list`
`bpm_manifest_file="inputs/3_genotyping/Multi-EthnicGlobal_D1.bpm"`
`csv_manifest_file="inputs/3_genotyping/Multi-EthnicGlobal_D1.csv"`
`egt_cluster_file="inputs/3_genotyping/Multi-EthnicGlobal_D1_ClusterFile.egt"`
` gtc_list_file ="inputs/4_GTC2VCF_Alignment/ listGTC.list "`
` ref ="$HOME/ res /human_g1k_v37.fasta"`
` out_prefix =" results /4_GTC2VCF_Alignment/LACRN"`
` bcftools +gtc2vcf \`
` --no- version - Ou \`
` -b $ bpm_manifest_file \`
` -c $ csv_manifest_file \`
` -e $ egt_cluster_file \`
` -f $ ref \`
` -g $ gtc_list_file | \`
` bcftools sort - Ou -T ./ bcftools-sort.XXXXXX | \`
` bcftools norm --no- version - Ob -o $ out_prefix.bcf -c x -f $ ref && \`
` bcftools index -f $ out_prefix.bcf `

- Summary of the results of this stage:

` Lines total/ split / realigned / skipped : 1736786/0/87/32`

- 1736754 genotyped variants are obtained, they are eliminated
  automatically the variants of the Y and XY chromosomes since all
  the samples are women

### Missing samples

- The command to convert GTC files to VCF is as follows:

` find results /3_genotyping/ PendingRawData / | grep gtc > \ `
`inputs/4_GTC2VCF_Alignment/ listGTC_Pending.list `
`bpm_manifest_file="inputs/3_genotyping/Multi-EthnicGlobal_D1.bpm"`
`csv_manifest_file="inputs/3_genotyping/Multi-EthnicGlobal_D1.csv"`
`egt_cluster_file="inputs/3_genotyping/Multi-EthnicGlobal_D1_ClusterFile.egt"`
` gtc_list_file ="inputs/4_GTC2VCF_Alignment/ listGTC_Pending.list "`
` ref ="$HOME/ res /human_g1k_v37.fasta"`
` out_prefix =" results /4_GTC2VCF_Alignment/ LACRN_Pending "`
` bcftools +gtc2vcf \`
` --no- version - Ou \`
` -b $ bpm_manifest_file \`
` -c $ csv_manifest_file \`
` -e $ egt_cluster_file \`
` -f $ ref \`
` -g $ gtc_list_file | \`
` bcftools sort - Ou -T ./ bcftools-sort.XXXXXX | \`
` bcftools norm --no- version - Ob -o $ out_prefix.bcf -c x -f $ ref && \`
` bcftools index -f $ out_prefix.bcf `

- 1,748,250 total loci of egt and manifests
- Summary of the results of this stage:

` Writing VCF file`
`Lines total/missing-reference/skipped: 1748250/32/11464`
` Merging 6 temporary files`
` Cleaning `
`Done`
` Lines total/ split / realigned / skipped : 1736786/0/87/32`

- 1736754 genotyped variants are obtained, they are eliminated
  automatically the variants of the Y and XY chromosomes since all
  the samples are women

- Exit:

` results /4_GTC2VCF_Alignment/*. bcf `

## Step 5 - Convert VCF to binary plink

- We use bcftools view and plink :

` bcftools view results /4_GTC2VCF_Alignment/ LACRN.bcf | plink -- vcf / dev / stdin -- make-bed -- out \`
` results /5_vcf2plink/LACRN`

- Exit:

` results /5_vcf2plink/LACRN.{ bed,bim,fam }`

bims file identifiers for processing
later

` mkdir results /5_vcf2plink/ original_fam_bim /`
`mv results/5_vcf2plink/LACRN.bim results/5_vcf2plink/original_fam_bim/`
`mv results/5_vcf2plink/LACRN.fam results/5_vcf2plink/original_fam_bim/`
`awk '{print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' results/5_vcf2plink/original_fam_bim/LACRN.bim\ `
`> results /5_vcf2plink/ LACRN.bim `
`awk '{print $1"_"$2" "$1"_"$2" "$3" "$4" "$5" "$6}' results/5_vcf2plink/original_fam_bim/LACRN.fam\ `
`> results /5_vcf2plink/ LACRN.fam `

- There are no samples with their duplicate identifier

`cat inputs/1_verify_information_and_data/samples_US-LACRN.csv | awk -F "," '{print $1}' |  \`
` tail -n +2 | sort | uniq -D`

- Generate list of raw file identifiers and identifier
  respective sample, only from samples with information in
  SampleSheet and raw data (usable samples)

`cat inputs/2_quality_control/SampleSheet.csv | awk '{print $1"\t"$5}' | tail -n +2 > \ `
` data_processing /5_vcf2plink/ ID_RawDate_Sample.tsv `

- We created input for plink to update identifiers

`awk '{print $1"\t"$1"\t"$0}' data_processing/5_vcf2plink/ID_RawDate_Sample.tsv > \ `
` data_processing /5_vcf2plink/ UPDATE_IDS_SAMPLES.tsv `

plink command to update sample IDs using
data_processing file /5_vcf2plink/ UPDATE_IDS_SAMPLES.tsv

` plink -- bfile results /5_vcf2plink/LACRN -- update-ids \ `
` data_processing /5_vcf2plink/ UPDATE_IDS_SAMPLES.tsv -- make-bed -- out \`
` results /5_vcf2plink/LACRN_ID_UPDATE`

975 identifiers from 1032 samples were updated

`-- update-ids : 975 people updated , 55 IDs not present .`

- We only keep these 975 usable samples with information in
  SampleSheet and raw data

` plink -- bfile results /5_vcf2plink/LACRN_ID_UPDATE -- keep \ `
` data_processing /5_vcf2plink/ ID_RawDate_Sample.tsv -- make-bed -- out \ `
` results /5_vcf2plink/ LACRN_ID_UPDATE_filter `

- Initial head of fam

`203299780012 R04C01 0 0 0 -9`
`203299780012 R05C01 0 0 0 -9`
`203299780012 R06C01 0 0 0 -9`
`203299780012 R07C01 0 0 0 -9`
`203299780012 R08C01 0 0 0 -9`
`203299780012 R01C01 0 0 0 -9`
`203299780012 R02C01 0 0 0 -9`
`203299780012 R03C01 0 0 0 -9`
`203299780093 R01C01 0 0 0 -9`
`203299780093 R02C01 0 0 0 -9`

- Head end of fam

`203299780012_R04C01 3898 0 0 0 -9`
`203299780012_R05C01 6101 0 0 0 -9`
`203299780012_R06C01 6590 0 0 0 -9`
`203299780012_R07C01 4309 0 0 0 -9`
`203299780012_R08C01 5603 0 0 0 -9`
`203299780012_R01C01 2463 0 0 0 -9`
`203299780012_R02C01 775 0 0 0 -9`
`203299780012_R03C01 8978 0 0 0 -9`
`203299780093_R01C01 8244 0 0 0 -9`
`203299780093_R02C01 5679 0 0 0 -9`

- Initial head bim

`1 1:49554-GA 0 49554 G A`
`1 JHU_1.92674 0 92675 G A`
`1 JHU_1.534237 0 534238 C A`
`1 JHU_1.564671 0 564672 C A`
`1 JHU_1.565475 0 565476 G C`
`1 M:5591-GA 0 566140 A G`
`1 JHU_1.566874 0 566875 T C`
`1 JHU_1.568023 0 568024 G A`
`1 JHU_1.568708 0 568709 G A`
`1 M:8851-TC 0 569399 G A `

- Head final bim

`1 1:49554 0 49554 G A`
`1 1:92675 0 92675 G A`
`1 1:534238 0 534238 C A`
`1 1:564672 0 564672 C A`
`1 1:565476 0 565476 G C`
`1 1:566140 0 566140 A G`
`1 1:566875 0 566875 T C`
`1 1:568024 0 568024 G A`
`1 1:568709 0 568709 G A`
`1 1:569399 0 569399 G A`

### Missing samples

- We use bcftools view and plink :

`bcftools view results/4_GTC2VCF_Alignment/LACRN_Pending.bcf | plink --vcf /dev/stdin --make-bed \`
`-- out results /5_vcf2plink/ LACRN_Pending `

bims file identifiers for processing
later

`mv results/5_vcf2plink/LACRN_Pending.bim results/5_vcf2plink/original_fam_bim/`
`mv results/5_vcf2plink/LACRN_Pending.fam results/5_vcf2plink/original_fam_bim/`
` awk '{ print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' \ `
`results/5_vcf2plink/original_fam_bim/LACRN_Pending.bim > results/5_vcf2plink/LACRN_Pending.bim`
` awk '{ print $1"_"$2" "$1"_"$2" "$3" "$4" "$5" "$6}' \ `
`results/5_vcf2plink/original_fam_bim/LACRN_Pending.fam > results/5_vcf2plink/LACRN_Pending.fam`

plink command to update sample IDs using
data_processing file /5_vcf2plink/ UPDATE_IDS_SAMPLES.tsv

` plink -- bfile results /5_vcf2plink/ LACRN_Pending -- update-ids \ `
` data_processing /5_vcf2plink/ UPDATE_IDS_SAMPLES.tsv -- make-bed -- out \ `
` results /5_vcf2plink/ LACRN_Pending_ID_UPDATE `

Updated 55 IDs for 55 samples -- update-ids : 55
people updated , 975 IDs not present .

- We only keep these 55 usable samples with information in
  SampleSheet and raw data

` plink -- bfile results /5_vcf2plink/ LACRN_Pending_ID_UPDATE -- keep \ `
` data_processing /5_vcf2plink/ ID_RawDate_Sample.tsv -- make-bed -- out \ `
` results /5_vcf2plink/ LACRN_Pending_ID_UPDATE_filter `

### We combine samples from both sets

SNP repetitions

`awk '{print $2}' results/5_vcf2plink/LACRN_ID_UPDATE_filter.bim |sort | uniq > \ `
` data_processing /5_vcf2plink/ SNPS_LACRN_ID_UPDATE_filter.list `
`awk '{print $2}' results/5_vcf2plink/LACRN_Pending_ID_UPDATE.bim | sort | uniq > \ `
` data_processing /5_vcf2plink/ SNPS_LACRN_Pending_ID_UPDATE.list `

- We see how many SNPs there are in common

`wc -l data_processing/5_vcf2plink/SNPS_LACRN_Pending_ID_UPDATE.list`
`1736171`
`wc -l data_processing/5_vcf2plink/SNPS_LACRN_ID_UPDATE_filter.list`
`1736171`
`comm -12 data_processing/5_vcf2plink/SNPS_LACRN_Pending_ID_UPDATE.list \ `
`data_processing/5_vcf2plink/SNPS_LACRN_ID_UPDATE_filter.list | wc -l`
`1736171`

When comparing the list of unique identifiers there are the same SNPS in
common in both data sets, we proceed to join the sets, there are SNPS
tri-allelic and tetra-allelic , we will see what happens. If there is an error,
These SNPs will need to be removed .

- We join sets

` plink -- bfile results /5_vcf2plink/ LACRN_ID_UPDATE_filter -- bmerge \ `
` results /5_vcf2plink/ LACRN_Pending_ID_UPDATE_filter -- make-bed -- out results /5_vcf2plink/LACRN_MERGE`
Error: 364 variants with 3+ alleles present .`
`* If you believe this es due to strand inconsistency , try -- flip with `
` results /5_vcf2plink/LACRN_MERGE- merge.missnp .`

tri-allelic SNPS from both sets:

`awk 'n=x[$1, $4]{print n"\n"$0;} {x[$1, $4]=$0;}' results/5_vcf2plink/LACRN_ID_UPDATE_filter.bim|\ `
`cut -f 2 | sort | uniq > data_processing/5_vcf2plink/SNPS_dump_TRIALELIC_LACRN.list`
` awk 'n=x[$1, $4]{ print n"\n"$0;} {x[$1, $4]=$0;}' \ `
`results/5_vcf2plink/LACRN_Pending_ID_UPDATE_filter.bim | cut -f 2 | sort | uniq > \ `
`data_processing/5_vcf2plink/SNPS_dump_TRIALELIC_LACRN_Pending.list`

` plink -- bfile results /5_vcf2plink/ LACRN_ID_UPDATE_filter -- exclude \ `
` data_processing /5_vcf2plink/ SNPS_dump_TRIALELIC_LACRN.list -- make-bed -- out \ `
` results /5_vcf2plink/ LACRN_ID_UPDATE_filter_DUP `
` plink -- bfile results /5_vcf2plink/ LACRN_Pending_ID_UPDATE_filter -- exclude \ `
`data_processing/5_vcf2plink/SNPS_dump_TRIALELIC_LACRN_Pending.list --make-bed --out \ `
` results /5_vcf2plink/ LACRN_Pending_ID_UPDATE_filter_DUP `

- We join sets

` plink -- bfile results /5_vcf2plink/ LACRN_ID_UPDATE_filter_DUP -- bmerge \ `
` results /5_vcf2plink/ LACRN_Pending_ID_UPDATE_filter_DUP -- make-bed -- out \`
` results /5_vcf2plink/LACRN_MERGE`

<b>1,735,589 variants and 1,030 samples remain</b>

## Step 6 - Quality filters in variants

### Filter by missing data rate in variants

` plink -- bfile results /5_vcf2plink/LACRN_MERGE -- missing -- out \ `
` data_processing /6_quality_filters_variants/LACRN- missing `
` Rscript code /6_quality_filter_variants_1_miss.R`

`awk '$5 >= 0.1 {print $2}' data_processing/6_quality_filters_variants/LACRN-missing.lmiss |  \`
`tail -n +2 > data_processing/6_quality_filters_variants/SNPS_missing_LACRN.list`
` plink -- bfile results /5_vcf2plink/LACRN_MERGE -- exclude \ `
`data_processing/6_quality_filters_variants/SNPS_missing_LACRN.list --make-bed --out \ `
` results /6_quality_filters_variants/LACRN_filter1`

- 25,345 variants are eliminated with a genotyping rate of less than 90%,
  1,710,244 variants remain

Hardy-Weinberg equilibrium filter

` plink -- bfile results /6_quality_filters_variants/LACRN_filter1 -- hardy -- out \ `
` data_processing /6_quality_filters_variants/LACRN_filter1_HW`
` awk '$3 == "ALL(NP)" && $9 < 0.000001 { print $2 }' \ `
`data_processing/6_quality_filters_variants/LACRN_filter1_HW.hwe > \ `
`data_processing/6_quality_filters_variants/SNPS_HW_dump_LACRN_filter1.list`
` plink -- bfile results /6_quality_filters_variants/LACRN_filter1 -- exclude \ `
`data_processing/6_quality_filters_variants/SNPS_HW_dump_LACRN_filter1.list --make-bed --out \ `
` results /6_quality_filters_variants/LACRN_filter2`

- 1,700,996 variants remain after HW filter

### We report INDELS numbers in sets only, we do not delete them

` awk '{ if ( length ($5) > 1 || length ($6) > 1) print $2}' \ `
` results /6_quality_filters_variants/LACRN_filter2.bim > \ `
`data_processing/6_quality_filters_variants/INDELS_ID_LACRN_filter2.list`

- There are 22456 INDELS

### We report variants based on the number of alleles ( bi, tri, tetra allelic)

There are no tri- or tetra- allelic SNPS as they were eliminated to make
the MERGE of the two rounds of genotyping of LACRN samples

## Stage 7 - Quality filters in samples

### Lost data rate filter per sample

` plink -- bfile results /6_quality_filters_variants/LACRN_filter2 -- missing -- out \ `
` data_processing /7_quality_filters_samples/ LACRN_samples-missing `
` Rscript code /7_quality_filter_samples_1_miss.R`

`awk '$6 > 0.05 {print $1}' data_processing/7_quality_filters_samples/LACRN_samples-missing.imiss|\ `
` tail -n +2 | wc -l`
`76`

genotyping rate of less than 95% it would be
76 samples would be eliminated

`awk '$6 > 0.1 {print $1}' data_processing/7_quality_filters_samples/LACRN_samples-missing.imiss|\ `
` tail -n +2 | wc -l`
`50`

It will be filtered by a genotyping rate of less than 90%, that is,
Samples that have at least 10% missing genotypes are eliminated (50
samples) will leave 980 samples

` awk '$6 > 0.1 { print $1"\t"$2}' \`
`data_processing/7_quality_filters_samples/LACRN_samples-missing.imiss | \`
`tail -n +2 > data_processing/7_quality_filters_samples/Sample_missing_LACRN_filter2_remove.list`
` plink -- bfile results /6_quality_filters_variants/LACRN_filter2 -- remove \ `
`data_processing/7_quality_filters_samples/Sample_missing_LACRN_filter2_remove.list --make-bed \ `
`-- out results /7_quality_filters_samples/LACRN_filter3`

genotyping rate of less than 90% were eliminated ,
980 samples remain

- We added reported sex (they are all women = 2) in fam

` mkdir results /7_quality_filters_samples/ fam_original `
` mv results /7_quality_filters_samples/LACRN_filter3.fam \`
` results /7_quality_filters_samples/ fam_original /`
` awk '{ print $1" "$2" "$3" "$4" 2 "$6 }' \ `
`results/7_quality_filters_samples/fam_original/LACRN_filter3.fam > \ `
` results /7_quality_filters_samples/LACRN_filter3.fam`

## Stage 8 - Filters and quality control by variants, sample, MAF, sex and kinship in samples by origin/country

- We created metrics for the number of samples per country, %GT per country and number
  of samples with %GT > 90 per country

` Rscript code /8_Metrics_country.R`

- Create a list of countries from the Stage 2 Sample Sheet :

`awk '{print $8}' inputs/2_quality_control/SampleSheet.csv | tail -n +2 | sort | uniq > \ `
` data_processing /8_filters_by_country/ list_countrys.list `

- We obtain the number of monomorphic variants by samples of the country in the
  filtered set

`input=" data_processing /8_filters_by_country/ list_countrys.list "`
` while IFS= read -r line`
` do`
` echo "############################################################"`
` echo "$line"`
` grep $line inputs/2_quality_control/SampleSheet.csv | awk '{print $1"\t"$5}' > \ `
` data_processing /8_filters_by_country/$line- samples.tsv `
` grep $line inputs/2_quality_control/SampleSheet.csv | wc -l`
` #plink -- bfile results /7_quality_filters_samples/LACRN_filter3 -- keep \ `
` data_processing /8_filters_by_country/$line- samples.tsv -- make-bed -- out \ `
` data_processing /8_filters_by_country/$line`
` #plink -- bfile data_processing /8_filters_by_country/$line -- freq -- out \ `
` data_processing /8_filters_by_country/$line-filter3-FRQ`
` awk '$5 == 0 {print $0}' data_processing/8_filters_by_country/$line-filter3-FRQ.frq | wc -l`
`done < "$input"`

## Step 9, filter by MAF at 0% (homozygotes), 1% and 5%

- I get frequency of variants

` plink -- bfile results /7_quality_filters_samples/LACRN_filter3 -- freq -- out \ `
` data_processing /9_quality_filters_part2/LACRN_filter3_FRQ`
`awk '$5 == 0 {print $0}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq | wc -l`
`391714`

- In the LACRN_filter3 set there are 391714 homozygous variants
- We graph MAF

` Rscript code /9_quality_filter_variants_1_maf.R`

From 1700996 variants we have:

- At 0%, MONOMORPHIC SNPs (MAF 0) are eliminated, equivalent to 391,714
  variants

`awk '$5 == 0 {print $0}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq | wc -l`

- At 1%, 827,799 variants are eliminated (MAF 0.01)

`awk '$5 <= 0.01 {print $0}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq | wc -l`

- At 5%, 1,074,060 variants are eliminated (MAF 0.05)

`awk '$5 <= 0.05 {print $0}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq | wc -l`

I will create 3 sets:

1. one filtered to 0% (monomorphic), used for PCA
2. one filtered at 1% (present in at least 10 samples), used for
   quality control of sex and kinship
3. one filtered at 5% (present in at least 50 samples), used for
   quality control of sex and kinship

`awk '$5 == 0 {print $0}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq > \ `
`data_processing/9_quality_filters_part2/LACRN_filter3_FRQ_0_SNPs.list`
`awk '$5 <= 0.01 {print $2}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq > \ `
`data_processing/9_quality_filters_part2/LACRN_filter3_FRQ_1_SNPs.list`
`awk '$5 <= 0.05 {print $2}' data_processing/9_quality_filters_part2/LACRN_filter3_FRQ.frq > \ `
`data_processing/9_quality_filters_part2/LACRN_filter3_FRQ_5_SNPs.list`

` plink -- bfile results /7_quality_filters_samples/LACRN_filter3 -- exclude \ `
`data_processing/9_quality_filters_part2/LACRN_filter3_FRQ_0_SNPs.list --make-bed --out \ `
` results /9_quality_filters_part2/LACRN_filter4_0_MAF`
` plink -- bfile results /7_quality_filters_samples/LACRN_filter3 -- exclude \ `
`data_processing/9_quality_filters_part2/LACRN_filter3_FRQ_1_SNPs.list --make-bed --out \ `
` results /9_quality_filters_part2/LACRN_filter4_1_MAF`
` plink -- bfile results /7_quality_filters_samples/LACRN_filter3 -- exclude \ `
`data_processing/9_quality_filters_part2/LACRN_filter3_FRQ_5_SNPs.list --make-bed --out \`
` results /9_quality_filters_part2/LACRN_filter4_5_MAF`

For the report we will only use the data filtered at 0 and 1%.

- In set filtered at 0%
  results /9_quality_filters_part2/LACRN_filter4_0_MAF there are 1,309,282
  variants
- In set filtered at 1%
  results /9_quality_filters_part2/LACRN_filter4_1_MAF there are 873,197
  variants
- In set filtered at 5%
  results /9_quality_filters_part2/LACRN_filter4_5_MAF there are 626,936
  variants

## Stage 10, Sex and relationship filter

### Sex assignment problems

- First we filter by LD to use these sets in sex filter and
  relationship

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- indep 50 5 1.2 \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_LD`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- indep 50 5 1.2 \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_LD`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_5_MAF -- indep 50 5 1.2 \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_LD`

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- exclude \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_LD.prune.out --make-bed \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_LD`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- exclude \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_LD.prune.out --make-bed \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_LD`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_5_MAF -- exclude \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_LD.prune.out --make-bed \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_LD`

- <b>We check that the reported sex is identical to the sex obtained by
  genotypes, WE USE LD FILTERED SETS

` plink --bfile data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_LD \ `
`-- check -sex `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_checksex_LD`

-- check -sex: 14151 Xchr and 0 Ychr variant (s) scanned , 33 problems
detected .

` plink --bfile data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_LD \`
`-- check -sex -- out \`
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_checksex_LD`

-- check -sex: 5941 Xchr and 0 Ychr variant (s) scanned , 34 problems
detected .

` plink --bfile data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_LD \ `
`-- check -sex \`
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_checksex_LD`

-- check -sex: 2879 Xchr and 0 Ychr variant (s) scanned , 23 problems
detected .

- We graph the checksex of the 3 sets WITH LD filter

` Rscript code /10_quality_filter_checksex_LD.R`

- CheckSex of set LACRN_filter4_0_MAF (0%)

- <b>We check that the reported sex is identical to the sex obtained by
  genotypes, WE USE SETS WITHOUT FILTERING BY LD

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- check -sex -- out \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_checksex`

-- check -sex: 40609 Xchr and 0 Ychr variant (s) scanned , 28 problems
detected .

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- check -sex -- out \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_checksex`

-- check -sex: 25723 Xchr and 0 Ychr variant (s) scanned , 23 problems
detected .

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_5_MAF -- check -sex -- out \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_checksex`

-- check -sex: 18155 Xchr and 0 Ychr variant (s) scanned , 22 problems
detected .

- <b>The results of the sex test without filtering by LD are better than
  when using LD-filtered sets </b>

<!-- -->

- We plot the checksex of the 3 sets without LD filter

` Rscript code /10_quality_filter_checksex.R`

### Unknown relationship

- <b>We perform kinship tests on the LD-filtered set</b>

` plink --bfile data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_MAF_LD --genome\ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome_LD`
` plink --bfile data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_LD --genome\ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD`
` plink --bfile data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_LD --genome\ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD`

` awk '$10 > 0.125 { print $1}' \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome_LD.genome |  \`
` tail -n +2 | sort | uniq | wc -l`

248

` awk '$10 > 0.125 { print $1}' \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD.genome |  \`
` tail -n +2 | sort | uniq | wc -l`

213

` awk '$10 > 0.125 { print $1}' \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome |  \`
` tail -n +2 | sort | uniq | wc -l`

164

- We obtain kinship metrics on the three sets filtered at MAF 0%,
  1% and 5%

` Rscript code /10_table_relationship_LD.R `

- Departures:

`1_US_LACRN/160120_Pipeline_US_LACRN/results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_X.tsv`
`1_US_LACRN/160120_Pipeline_US_LACRN/results/10_quality_filters_sex_relationship/UniqRelation_LD_MAF_X.tsv`

Where X is the MAF value used for filtering

- Tables obtained with previous script are in results (folder 10
  of results). As a summary we have that:

For the set filtered at 0% MAF there are 299 samples related to
at least one other sample from the same LACRN set after filtering by a value of
PHI_HAT of 0.125. There are 1148 pairs of related samples using the
same threshold. For the 1% MAF filtered set there are 272 samples
related to at least one other, and 505 pairs using the same threshold of
PHI_HAT. For the 5% MAF filtered set, there are 224 related samples.
with at least one other, and 485 pairs using the same PHI_HAT threshold.

- We graph

` Rscript code /10_quality_filter_samples_2_relationship_LD.R`

- We obtain IDs of samples with more than 10 kinship relationships in the set
  MAF 1 and 5% with LD filter

`awk '$3 >= 10 {print $1}' results/10_quality_filters_sex_relationship/UniqRelation_LD_MAF_1.tsv|\ `
`tail -n +2> data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_1_YES_LD.list`
`20 samples`
`awk '$3 >= 10 {print $1}' results/10_quality_filters_sex_relationship/UniqRelation_LD_MAF_5.tsv|\ `
`tail -n +2> data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_5_YES_LD.list`
`21 samples`

- We create a . genome file where we eliminate the kinship relationships
  from the samples from the previous step

`cat data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD.genome |  \`
`grep -vf data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_1_YES_LD.list >\ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_LD_filter.genome`
`cat data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome |  \`
`grep -vf data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_5_YES_LD.list >\ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD_filter.genome`

- We graph the distribution of PHI_HAT values

`Rscript code/10_quality_filter_samples_2_relationship_LD_filter.R`

<b>There are too many kinship relationships using the sets filtered by
LD, so we evaluate the test using the sets without filtering by LD

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- genome \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- genome \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_5_MAF -- genome \ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome`

` awk '$10 > 0.125 { print $1}' \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_0_genome.genome |  \`
` tail -n +2 | sort | uniq | wc -l`

69

` awk '$10 > 0.125 { print $1}' \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome.genome |  \`
` tail -n +2 | sort | uniq | wc -l`

49

` awk '$10 > 0.125 { print $1}' \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome.genome |  \`
` tail -n +2 | sort | uniq | wc -l`

31

- We obtain kinship metrics in the three sets filtered at MAF 0%,
  1% and 5%

` Rscript code /10_table_relationship.R `

- Departures:

`1_US_LACRN/160120_Pipeline_US_LACRN/results/10_quality_filters_sex_relationship/PairsRelation_MAF_X.tsv`
`1_US_LACRN/160120_Pipeline_US_LACRN/results/10_quality_filters_sex_relationship/UniqRelation_MAF_X.tsv`

Where X is the MAF value used for filtering

- Tables obtained with the previous script are in results, as a summary
  we have to:

For the set filtered at 0% MAF there are 85 samples related to at least
less another sample from the same LACRN set after filtering by a value of
PHI_HAT of 0.125. There are 279 pairs of related samples using the same
threshold. For the 1% MAF filtered set, there are 63 related samples
with at least one other, and 200 pairs using the same PHI_HAT threshold. For
The set filtered at 5% MAF has 43 samples related to at least
another, and 96 pairs using the same PHI_HAT threshold.

- We graph

` Rscript code /10_quality_filter_samples_2_relationship.R`

- We obtain IDs of samples with more than 10 kinship relationships in set
  MAF 1% without LD filter

`awk '$3 >= 10 {print $1}' results/10_quality_filters_sex_relationship/UniqRelation_MAF_1.tsv |\ `
`tail -n +2 > data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_1_NO_LD.list`
`16 samples`
`awk '$3 >= 10 {print $1}' results/10_quality_filters_sex_relationship/UniqRelation_MAF_5.tsv |\ `
`tail -n +2> data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_5_NO_LD.list`
`6 samples`

- We create a . genome file where we eliminate the kinship relationships
  from the samples from the previous step

`cat data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome.genome |  \`
`grep -vf data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_1_NO_LD.list >\ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_genome_filter.genome`
`cat data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome.genome |  \`
`grep -vf data_processing/10_quality_filters_sex_relationship/ID_more_10_relations_5_NO_LD.list >\ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_filter.genome`

- We graph the distribution of PHI_HAT values

` Rscript code /10_quality_filter_samples_2_relationship_filter.R`

#### Obtaining relationship test metrics using PHI_HAT

- We execute script to generate tables by set with and without LD filter at 1
  and 5% MAF.
- Run as:

` Rscript code /10_table_relationship_countrys.R \`
`[File with relationship pairs >= 0.125] [alias output]`

` Rscript code /10_table_relationship_countrys.R\`
`results/10_quality_filters_sex_relationship/PairsRelation_MAF_1.tsv 1_NO_LD`
` Rscript code /10_table_relationship_countrys.R\`
`results/10_quality_filters_sex_relationship/PairsRelation_MAF_5.tsv 5_NO_LD`
` Rscript code /10_table_relationship_countrys.R\`
`results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_1.tsv 1_YES_LD`
` Rscript code /10_table_relationship_countrys.R\`
`results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5.tsv 5_YES_LD`

- Departures:

`"results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5_Beta.tsv"`
`"results/10_quality_filters_sex_relationship/related_pairs_by_coutry_",maf_LD,".png"`
`"results/10_quality_filters_sex_relationship/related_pairs_by_coutry_",maf_LD,".tsv"`
`"results/10_quality_filters_sex_relationship/related_pairs_by_PLATE_",maf_LD,".tsv"`

- Data stored in results folder 10

#### KING estimate

This test provides kinship relationships based on the value
KINSHIP. A third-degree kinship relationship is equivalent to a
KINSHIP of 0.0625, duplicate or identical individuals correspond to a
value of 0.5

`~/softwares/plink2 -- bfile results /9_quality_filters_part2/LACRN_filter4_5_MAF -- make - king -table\ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_king `

- Exit:

`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_king.kin0`

`~/softwares/plink2 -- bfile results /9_quality_filters_part2/LACRN_filter4_5_MAF -- make - king -table\ `
`-- king -table- filter 0.044 -- out \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_king_filter`

- Exit:

`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_king_filter.kin0`

`~/softwares/plink2 -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- make - king -table\ `
`-- king -table- filter 0.044 -- out \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_king_filter`
`~/softwares/plink2 -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- make - king -table\ `
`--out data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_king`

` Rscript code /10_PHI_HAT_KING.R`

- Departures:

`results/10_quality_filters_sex_relationship/KINSHIP_VS_PHI_HAT_MAF5.png`
`results/10_quality_filters_sex_relationship/KINSHIP_VS_PHI_HAT_MAF1.png`
` results /10_quality_filters_sex_relationship/KINSHIP_hist.png`

`cat data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_genome_LD.genome \ `
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_king_filter.kin0`

## Stage 11, PCA on MAF sets 0 and 1%

- We perform principal component analysis with plink in set
  filtered by MAF 0 and 1%

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- pca -- out \ `
` results /11_PCA_MAF_0_1/LACRN_filter4_0_MAF_PCA`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- pca -- out \ `
` results /11_PCA_MAF_0_1/LACRN_filter4_1_MAF_PCA`

- We graph PCS 1 to 4 of both sets

`Rscript code/11_PCA.R results/11_PCA_MAF_0_1/LACRN_filter4_0_MAF_PCA.eigenvec 0`
`Rscript code/11_PCA.R results/11_PCA_MAF_0_1/LACRN_filter4_1_MAF_PCA.eigenvec 1`

- Departures:

`" results /11_PCA_MAF_0_1/ Country_Source_PCA _", MAF,".png "`
`" results /11_PCA_MAF_0_1/ Country_PCA _", MAF,".png "`
`" results /11_PCA_MAF_0_1/CHIP_PCA_", MAF,".png "`
`" results /11_PCA_MAF_0_1/WELL_PCA_", MAF,".png "`
`" results /11_PCA_MAF_0_1/ Country_PCA _", MAF,"PC123.png"`

## Step 12 CREATE SET 1000G AYM MAP plus LACRN samples and do PCA

Reference population sets will be created to perform a PCA of the
components in the LACRN samples

- The set will be used
  <b> results /9_quality_filters_part2/LACRN_filter4_0_MAF</b> filtering
  0% MAF, i.e. set where monomorphic SNPs were removed
  SNPS IDs from the lacrn set

`cut -f 2 results/9_quality_filters_part2/LACRN_filter4_0_MAF.bim > \ `
` data_processing /12_1000G_REF_LACRN_SET/ list_ID_SNP_LACRN.list `

- I get a list of common IDs between set reference and set lacrn

`comm -12 <( cut -f 2 inputs/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT.bim | \ `
`sort | uniq ) <(sort data_processing/12_1000G_REF_LACRN_SET/list_ID_SNP_LACRN.list | uniq) > \ `
`data_processing/12_1000G_REF_LACRN_SET/list_ID_SNP_COMM_LACRN_REF.list`

There are 795,371 common SNPs

- Genre Set with common SNPs between reference and LACRN samples

` plink --bfile inputs/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT --extract \ `
`data_processing/12_1000G_REF_LACRN_SET/list_ID_SNP_COMM_LACRN_REF.list --make-bed \ `
`--out data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT_COMM`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- extract \ `
`data_processing/12_1000G_REF_LACRN_SET/list_ID_SNP_COMM_LACRN_REF.list --make-bed \ `
`-- out data_processing /12_1000G_REF_LACRN_SET/LACRN_filter4_COMM`

- We join SETS

` plink --bfile data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT_COMM \ `
`--bmerge data_processing/12_1000G_REF_LACRN_SET/LACRN_filter4_COMM --make-bed \ `
`-- out data_processing /12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN`
Error: 970 variants with 3+ alleles present .`

triallelic variants from the LACRN and Reference sets

` plink --bfile data_processing/12_1000G_REF_LACRN_SET/LACRN_filter4_COMM --exclude \ `
`data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN-merge.missnp --make-bed \ `
`-- out data_processing /12_1000G_REF_LACRN_SET/LACRN_filter5`
` plink --bfile data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT_COMM \ `
`--exclude data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN-merge.missnp --make-bed \ `
`--out data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT_COMM_filter`

- Now we unite SETS

` plink --bfile data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_COMM_LACRN_SORT_COMM_filter \ `
`-- bmerge data_processing /12_1000G_REF_LACRN_SET/LACRN_filter5 -- make-bed \ `
`-- out data_processing /12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN`

- We do PCA

` plink --bfile data_processing/12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN --pca \ `
`-- out results /12_1000G_REF_LACRN_SET/1000G_AYM_MAP_LACRN_PCA`

- We create popinfo sorted manually
- We create sample sheet with the 980 LACRn samples that passed the
  filters

`awk '{print $1}' data_processing/12_1000G_REF_LACRN_SET/LACRN_filter5.fam > \ `
` data_processing /12_1000G_REF_LACRN_SET/ list_SAMPLE_LACRN.list `
`head -n 1 inputs/2_quality_control/SampleSheet.csv > \ `
` data_processing /12_1000G_REF_LACRN_SET/SampleSheet_qc.csv`
`grep -f data_processing/12_1000G_REF_LACRN_SET/list_SAMPLE_LACRN.list \ `
`inputs/2_quality_control/SampleSheet.csv >> \`
` data_processing /12_1000G_REF_LACRN_SET/SampleSheet_qc.csv`

- We plot PCA

` Rscript code /12_PCA.R`

- Departures:

`" results /12_1000G_REF_LACRN_SET/ Country_PCA _", MAF,"_REF.png "`
`"results/12_1000G_REF_LACRN_SET/Country_PCA_", MAF,"_REF_123.pdf"`
`" results /11_PCA_MAF_0_1/ Country_PCA _", MAF,".png "`
`" results /11_PCA_MAF_0_1/CHIP_PCA_", MAF,".png "`
`" results /11_PCA_MAF_0_1/WELL_PCA_", MAF,".png "`

## Stage 13, sample dendrogram , % heterozygotes and extra quality controls

### Dendrogram

- We use the data set filtered at 1% MAF to calculate a
  dendrogram to identify related or identical samples that
  should be discarded.
- We use the data set
  <b> results /9_quality_filters_part2/LACRN_filter4_1_MAF</b>

<!-- -->

- We created sets of only chromosomes 21 and 22 ( smaller )

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_1_MAF -- chr 21-22 -- make-bed \ `
`--out data_processing/13_Dendogram_and_otherQC/LACRN_filter4_1_MAF_chr21-22`

- We convert genotypes to numerical values, counting the minor allele
  set frequency

` plink --bfile data_processing/13_Dendogram_and_otherQC/LACRN_filter4_1_MAF_chr21-22 --recode A \ `
`--out data_processing/13_Dendogram_and_otherQC/LACRN_filter4_1_MAF_chr21-22_recode_A`

- We graph with R dendrogram

` Rscript code /13_Dendogram.R`

- Exit:

`" results /13_Dendogram_and_otherQC/Dendogram_LACRN_CHR21-22.pdf"`

### Obtaining % of heterozygous genotypes

- We use the set <b> results /9_quality_filters_part2/LACRN_filter4_0_MAF
  </b> with filters on variants and samples but without deleting
  monomorphic or MAF filters

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF --recode A- transpose \ `
`--out data_processing/13_Dendogram_and_otherQC/LACRN_filter4_0_MAF_recodeA-T`
` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF --recode A -- out \ `
`data_processing/13_Dendogram_and_otherQC/LACRN_filter4_0_MAF_recodeA`

- We calculate heterozygosity of genotypes per sample:

` python code/13_heterozygosity.py > \`
`data_processing/13_Dendogram_and_otherQC/Heterozygosity_samples.tsv`
`head data_processing/13_Dendogram_and_otherQC/Heterozygosity_samples.tsv`
` Sample Yam    Percent_Heterozygosity `
`203299780012_R04C01 3898 16.126670060974863`
`203299780012_R05C01 6101 16.389141076445547`
`203299780012_R06C01 6590 16.30341434688194`
`203299780012_R07C01 4309 15.879534775300886`
`203299780012_R08C01 5603 15.882218528015311`
`203299780012_R01C01 2463 18.037962065538775`
`203299780012_R02C01 775 16.60322786440761`
`203299780012_R03C01 8978 16.44718681372609`
`203299780093_R01C01 8244 16.203885460501294`

1304144 variants or rows are used in processing

### Kinship, concentration, and %HET graphs

` Rscript code /13_heterozygosity.R`

- <b>This script also generates tables with the sample metrics and
  data quality

` Rscript code /13_heterozygosity.R \`
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_checksex.sexcheck \`
`1_NO_LD \`
`results/10_quality_filters_sex_relationship/UniqRelation_MAF_1.tsv \`
`results/10_quality_filters_sex_relationship/PairsRelation_MAF_1.tsv`

` Rscript code /13_heterozygosity.R \`
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_1_MAF_checksex_LD.sexcheck \`
`1_YES_LD \`
`results/10_quality_filters_sex_relationship/UniqRelation_LD_MAF_1.tsv \`
`results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_1.tsv`

` Rscript code /13_heterozygosity.R \`
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_checksex.sexcheck \`
`5_NO_LD \`
`results/10_quality_filters_sex_relationship/UniqRelation_MAF_5.tsv \`
`results/10_quality_filters_sex_relationship/PairsRelation_MAF_5.tsv`

` Rscript code /13_heterozygosity.R \`
`data_processing/10_quality_filters_sex_relationship/LACRN_filter4_5_MAF_checksex_LD.sexcheck \`
`5_YES_LD \`
`results/10_quality_filters_sex_relationship/UniqRelation_LD_MAF_5.tsv \`
`results/10_quality_filters_sex_relationship/PairsRelation_LD_MAF_5.tsv`

- Departures:

`" results /13_Dendogram_and_otherQC/Het_vs_GT.png"`
`" results /13_Dendogram_and_otherQC/Boxplor_Het.png"`
`"results/13_Dendogram_and_otherQC/Info_samples_filter_QC_",maf_LD, ".tsv"`
`"results/13_Dendogram_and_otherQC/Concentration_vs_N_relations_",maf_LD,".png"`
`"results/13_Dendogram_and_otherQC/N_relations_by_sample_",maf_LD,".png"`
`"results/13_Dendogram_and_otherQC/GT_vs_Mean_PhiHat_",maf_LD,".png"`
`"results/13_Dendogram_and_otherQC/Mean_PhiHat_vs_N_relations_",maf_LD,".png"`

## Stage 14 Admixture

We estimate the global ancestry of the LACRN samples

We created a set of LACRN samples with samples used as references,
Only reference samples with genotypes obtained from
whole genome sequencing, where variants were called and
obtained from the VCFS, the sets to be joined are:

1. inputs/14_Admixture/1000G_COMM_SGDP_LACRN_CLG_AMR : Set with 120
   individuals from 1000 genomes, 40 Asians, 40 Africans and 40 Europeans
2. inputs/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G : Set with 17
   complete genome Mapuches
3. inputs/14_Admixture/SGDP_COMM_LACRN_CLG_AMR_1000G : Set with 21
   Amerindians of the SGDP project

results /9_quality_filters_part2/LACRN_filter4_0_MAF is used
to create subsets with common variants present in all 3 sets and
later join them

- I create a subset of the LACRN set with variants common to the 1000G and SGDP sets.
  and CLG_AMR

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- extract \ `
`inputs/14_Admixture/list_SNP_COMM_1000G_SGDP_LACRN_CLG_AMR.list --make-bed --out \ `
` data_processing /14_Admixture/LACRN_COMM_SGDP_CLG_AMR_1000G`

- We join LACRN set with 1000G

` plink --bfile data_processing/14_Admixture/LACRN_COMM_SGDP_CLG_AMR_1000G --bmerge \ `
`inputs/14_Admixture/1000G_COMM_SGDP_LACRN_CLG_AMR -- make-bed -- out \ `
` data_processing /14_Admixture/LACRN_1000G`
Error: 32 variants with 3+ alleles present .`

- Remove triallelic variants from the list
  data_processing /14_Admixture/LACRN_1000G-merge.missnp

` plink --bfile data_processing/14_Admixture/LACRN_COMM_SGDP_CLG_AMR_1000G --exclude \ `
` data_processing /14_Admixture/LACRN_1000G-merge.missnp -- make-bed -- out \ `
`data_processing/14_Admixture/LACRN_COMM_SGDP_CLG_AMR_1000G_FILTER`
`166153 variants and 980 people pass filters and QC.`

` plink -- bfile inputs/14_Admixture/1000G_COMM_SGDP_LACRN_CLG_AMR -- exclude \ `
` data_processing /14_Admixture/LACRN_1000G-merge.missnp -- make-bed -- out \ `
`data_processing/14_Admixture/1000G_COMM_SGDP_LACRN_CLG_AMR_FILTER`
`166153 variants and 120 people pass filters and QC.`

` plink -- bfile inputs/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G -- exclude \ `
` data_processing /14_Admixture/LACRN_1000G-merge.missnp -- make-bed -- out \ `
`data_processing/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G_FILTER`
`166153 variants and 17 people pass filters and QC.`

` plink -- bfile inputs/14_Admixture/SGDP_COMM_LACRN_CLG_AMR_1000G -- exclude \ `
` data_processing /14_Admixture/LACRN_1000G-merge.missnp -- make-bed -- out \ `
`data_processing/14_Admixture/SGDP_COMM_LACRN_CLG_AMR_1000G_FILTER`
`166153 variants and 21 people pass filters and QC.`

- We joined the LACRN set with 1000G again

` plink --bfile data_processing/14_Admixture/LACRN_COMM_SGDP_CLG_AMR_1000G_FILTER \ `
`--bmerge data_processing/14_Admixture/1000G_COMM_SGDP_LACRN_CLG_AMR_FILTER --make-bed \ `
`-- out data_processing /14_Admixture/LACRN_1000G`

- We join set LACRN_1000G + CLG_AMR

` plink -- bfile data_processing /14_Admixture/LACRN_1000G -- bmerge \ `
`data_processing/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G_FILTER --make-bed \ `
`-- out data_processing /14_Admixture/LACRN_1000G_CLG_AMR`
Error: 333 variants with 3+ alleles present .`
` data_processing /14_Admixture/LACRN_1000G_CLG_AMR-merge.missnp`

- Remove triallelic variants from the list
  data_processing /14_Admixture/LACRN_1000G_CLG_AMR-merge.missnp

` plink -- bfile data_processing /14_Admixture/LACRN_1000G -- exclude \ `
` data_processing /14_Admixture/LACRN_1000G_CLG_AMR-merge.missnp -- make-bed -- out \ `
` data_processing /14_Admixture/LACRN_1000G`
` plink --bfile data_processing/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G_FILTER \ `
`--exclude data_processing/14_Admixture/LACRN_1000G_CLG_AMR-merge.missnp --make-bed \ `
`--out data_processing/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G_FILTER`
` plink --bfile data_processing/14_Admixture/SGDP_COMM_LACRN_CLG_AMR_1000G_FILTER \ `
`--exclude data_processing/14_Admixture/LACRN_1000G_CLG_AMR-merge.missnp --make-bed \ `
`--out data_processing/14_Admixture/SGDP_COMM_LACRN_CLG_AMR_1000G_FILTER`

- We join set LACRN_1000G + CLG_AMR again

` plink -- bfile data_processing /14_Admixture/LACRN_1000G -- bmerge \ `
`data_processing/14_Admixture/CLG_AMR_COMM_LACRN_SGDP_1000G_FILTER --make-bed \ `
`-- out data_processing /14_Admixture/LACRN_1000G_CLG_AMR`

- We join set LACRN_1000G_CLG_AMR + SGDP

` plink -- bfile data_processing /14_Admixture/LACRN_1000G_CLG_AMR -- bmerge \ `
`data_processing/14_Admixture/SGDP_COMM_LACRN_CLG_AMR_1000G_FILTER --make-bed \ `
`-- out data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP`

165,820 common variants

Set<b> data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP</b> is the
which has the samples of LACRN, SGDP, CLG_AMR, 1000G and their 165820 joined together
Common SNPS without triallelic variants

- Create organized popinfo , with our references and those of LACRAN

`inputs/14_Admixture/info_samples/popinfo_1000G_SGDP_PATAGONIA_LACRN.csv`

- I modify the fam file so that the information can be compared
  the SGDP project samples in the set on plink . They were removed from
  the sample identifiers the word " variantsXX "

` data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP.fam`

- I create a list of samples from the set that are already sorted

`awk '{print $1}' inputs/14_Admixture/info_samples/popinfo_1000G_SGDP_PATAGONIA_LACRN.csv |  \`
`tail -n +2 > inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_LACRN.list`
` awk '{ print $1"\t"$1}' \`
`inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_LACRN.list \ `
`> inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_LACRN.tsv`

- We filter by LD

` plink -- bfile data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP -- indep 50 5 1.2 \ `
`-- out data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD`
` plink -- bfile data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP -- exclude \ `
`data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD.prune.out --make-bed --out \ `
` data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD`

-- exclude : 41054 variants remaining

- FAM Change:

` mkdir data_processing /14_Admixture/ original_fam `
`mv data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD.fam \`
` data_processing /14_Admixture/ original_fam /`
` awk '{ print $1" "$1" "$3" "$4" "$5" "$6}' \ `
`data_processing/14_Admixture/original_fam/LACRN_1000G_CLG_AMR_SGDP_LD.fam > \ `
` data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD.fam`

- We order set in plink

` plink -- bfile data_processing /14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD -- indiv-sort f \ `
`inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_LACRN.tsv --make-bed \ `
`--out data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD_SORT`

We use Admixture to calculate global ancestry.

` for i in {3..10}`
`do`
` admixture -j8 --cv data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD_SORT.bed $i > \ `
`data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD_SORT.K$i.log`
`done`

`mv LACRN_1000G_CLG_AMR_SGDP_LD_SORT.* data_processing/14_Admixture/`

` for i in {3..10}`
`do`
`grep CV data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD_SORT.K$i.log |  \`
`awk '{ print '$i', $4}' >> data_processing/14_Admixture/CV_LACRN_1000G_CLG_AMR_SGDP_LD_SORT.txt`
`done`

- Create ordered sample reference list

`head -n 158 inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_LACRN.tsv > \ `
`inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_REFERENCES.tsv`

There are 158 reference samples

- Create subset with only reference samples

` plink --bfile data_processing/14_Admixture/LACRN_1000G_CLG_AMR_SGDP_LD_SORT \ `
`--keep inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_REFERENCES.tsv \ `
`--indiv-sort f inputs/14_Admixture/info_samples/list_popinfo_1000G_SGDP_PATAGONIA_REFERENCES.tsv\ `
`-- make-bed --out data_processing/14_Admixture/REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT`

- We use Admixture to calculate ancestry from just the references,
  to compare ancestral components if they vary with the samples
  of lacrn

` for i in {3..10}`
`do`
` admixture -j8 --cv data_processing/14_Admixture/REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT.bed $i > \ `
`data_processing/14_Admixture/REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT.K$i.log`
`done`

`mv REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT.* data_processing/14_Admixture/`

` for i in {3..10}`
`do`
`grep CV data_processing/14_Admixture/REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT.K$i.log |  \`
`awk '{ print '$i', $4}'>> data_processing/14_Admixture/CV_REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT.txt`
`done`

## Stage 15 Admixture Windows

Global ancestry is estimated using random sample windows
from US-LACRN

- In inputs/15_Admixture_windows we copy the sets obtained in the point
  previous, the popinfo and the sample list:

`LACRN_1000G_CLG_AMR_SGDP_LD_SORT`
`REFERENCE_1000G_CLG_AMR_SGDP_LD_SORT`
`list_popinfo_1000G_SGDP_PATAGONIA_LACRN.tsv`
`popinfo_1000G_SGDP_PATAGONIA_LACRN.csv`

- We created a set with only LACRN samples

`cat inputs/15_Admixture_windows/list_popinfo_1000G_SGDP_PATAGONIA_LACRN.tsv | grep _R0 > \ `
`inputs/15_Admixture_windows/ list_popinfo_LACRN.tsv `
`plink1.9 --bfile inputs/15_Admixture_windows/LACRN_1000G_CLG_AMR_SGDP_LD_SORT --keep \ `
`inputs/15_Admixture_windows/ list_popinfo_LACRN.tsv -- indiv-sort f \ `
`inputs/15_Admixture_windows/ list_popinfo_LACRN.tsv -- make-bed -- out \ `
` data_processing /15_Admixture_windows/LACRN_LD_SORT`

- Calculation of ancestry by window in JOIN SET WITH LD FILTER

`endAdmixed=$(wc -l ancestry/LACRN/input/LACRN_1000G_CLG_AMR_SGDP_LD_SORT.fam | awk '{print $1}')`
`bash code/1_ancestry_windows_iterator.sh -p ancestry/LACRN/input/LACRN_1000G_CLG_AMR_SGDP_LD_SORT\ `
`-s 159 -e $endAdmixed -i ancestry/LACRN/input/popinfo_1000G_SGDP_PATAGONIA_LACRN.csv \ `
`-t 8 -d 2 -w ancestry /LACRN -r LACRN -a input/CLG2_Ancestry.tsv`

- WE GENERATE A TABLE WITH ANCESTRY AND SAMPLE POPINFO INFORMATION
  references and LACRN

` Rscript code / process_order_Q_SET.R `

- We order set in popinfo order to graph in R

` plink -- bfile ancestry /LACRN/temporal/REF158-RANDOM -- indiv-sort f \ `
` ancestry /LACRN/output/list_REF158-LACRN-SORT.tsv -- make-bed -- out \ `
` ancestry /LACRN/output/REF158-LACRN-SORT`

- We copy popinfo and CV file renamed with set name in folder
  output
- we execute R script to graph

`Rscript code/New_admix.R REF158-LACRN-SORT popinfo_1000G_SGDP_PATAGONIA_LACRN.csv 2 \ `
`REF158-LACRN-SORT.4.Q 159 ancestry/LACRN input/CLG2_Ancestry.tsv`
` pdf `
` 2 `
` pdf `
` 2 `
`[1] " Ancestry;Average;SD;SE "`
`[1] "African;0.0589;0.1068;0.0034"`
`[1] "Asian;0.0393;0.0844;0.0027"`
`[1] "European;0.6787;0.1806;0.0058"`
`[1] "Amerindian;0.2231;0.1446;0.0046"`

## Step 16 PHASE and IMPUTATION of samples from the LACRN(1000G) set

- This section shows the steps and commands used for the
  Imputation of the LACRN set using only the samples as reference
  and haplotypes of 1000 Genomes

- Keep common SNPs from the LACRN set with 1000G (1000G in format
  legend )

I use set results /9_quality_filters_part2/LACRN_filter4_0_MAF.bim with
1309282

- I build a list of the variants present in 1000G from
  Legend files , the list is called
  <b>data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND.tsv</b>,
  contains the composite identifier of the variant by chr:pos a0(REF)
  a1(ALT). The LACRN samples should be left with the variants in
  common and the alleles in the same order as this file.

` for i in {1..22}`
`do`
`echo "#################"`
`echo $i`
`echo resources/1000G/1000GP_Phase3/1000GP_Phase3_chr$i.legend.gz`
`zcat resources/1000G/1000GP_Phase3/1000GP_Phase3_chr$i.legend.gz | \`
` awk '{ print "'$i'"":"$2"\t"$3"\t"$4}' | tail -n +2 >> \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND.tsv`
`done`

There are 81706022 variants in 1000G

reported variants such as Multiallelic_CNV and Biallelic_DEL
in 1000G of the list, for example the variants:

`1:713044 C `<CN0>
`1:738570 G `<CN0>
`1:766600 G `<CN0>
`1:773090 T `<CN0>
`1:775292 T `<CN0>
`1:794496 G `<CN0>
`cat data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND.tsv | grep -v "`<CN0>`" > \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter1.tsv `

We eliminated 35,079 variants, leaving 8,167,0943

- we eliminate INDELS

`awk '{ if( length($2) > 1 || length($3) > 1) print $1"\t"$2"\t"$3 }' \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter1.tsv | wc -l`
`THERE ARE 3304104 INDELS`
`awk '{ if( length($2) == 1 && length($3) == 1) print $1"\t"$2"\t"$3 }' \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter1.tsv > \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter2.tsv`

78366823 variants left

- I delete rows with duplicate variants or triallelic variants based
  in the identifier

`awk '{a[$1]++;b[$1]=$0}END{for(x in a)if(a[x]==1)print b[x]}' \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter2.tsv > \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv`

77844341 variants remain

- I create a list of unique variants in 1000G, we eliminate the ones that are
  triallelics from the list

`awk '{print $1}' data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv |  \`
`sort | uniq -u > data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list`
`77844341 unique variants`

- I create a LACRN subset with chromosomes 1 to 22, chromosomes
  autosomal

` plink -- bfile results /9_quality_filters_part2/LACRN_filter4_0_MAF -- chr 1-22 -- make-bed -- out \ `
` data_processing /16_phase_and_imputation/LACRN-chr1-22`

1268261 variants remain

- We get a set with common variants for 1000G

`awk '{print $2}' data_processing/16_phase_and_imputation/LACRN-chr1-22.bim | sort | uniq > \ `
`data_processing/16_phase_and_imputation/list_variants_LACRN_sort.list`
`comm -12 data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list \ `
`data_processing/16_phase_and_imputation/list_variants_LACRN_sort.list > \ `
` data_processing /16_phase_and_imputation/ list_COMM_variants-list `
` plink -- bfile data_processing /16_phase_and_imputation/LACRN-chr1-22 -- extract \ `
`data_processing/16_phase_and_imputation/list_COMM_variants-list --make-bed --out \ `
` data_processing /16_phase_and_imputation/LACRN-chr1-22-comm`

1185700 variants

- Correct allele order of LACRN plink set in file order
  1000G legend

` plink --bfile data_processing/16_phase_and_imputation/LACRN-chr1-22-comm --a1-allele \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`--out data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF`

- Generate tabulated list with changes in allele order, to verify
  that were performed correctly

`paste data_processing/16_phase_and_imputation/LACRN-chr1-22-comm.bim \ `
`data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF.bim |  \`
` awk '{ if ($5!=$11) print $2"\t"$5"\t"$6"\t"$11"\t"$12} ' > \ `
`data_processing/16_phase_and_imputation/changes-order-alleles.tsv`

- Just to verify I evaluate some of the SNPs on this list by looking at the
  order in 1000G and reviewing this list

`head data_processing/16_phase_and_imputation/changes-order-alleles.tsv`
`1:49554 G A A G`
`1:568024 G A A G`
`1:737263 A G G A`
`1:746189 G A A G`
`1:761191 T C C T`
`1:761764 A G G A`
`1:761958 T C C T`
`1:762187 T C C T`
`1:770377 T A A T`
`1:773998 T C C T`

`grep "1:773998" data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv`
`1:773998 C T`

Successfully changed alleles in the set in plink

<b>data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF
set to IMPUT

- Separate sets by chromosomes and order sets according to reference

` for i in {1..22}`
`do`
` plink --bfile data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF \ `
`-- chr $i -- make-bed -- out data_processing /16_phase_and_imputation/LACRN- chr ${i}`
` plink -- bfile data_processing /16_phase_and_imputation/LACRN- chr ${i} --a1-allele \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`-- out data_processing /16_phase_and_imputation/LACRN- chr ${i}`
`done`

### PHASE

- Phasing, WE ELIMINATE VARIANTS THAT have problems for phasing, such as
  INDELS and where the alternative allele does not match 1000G for example,
  generating new updated set
- We run phases, detect variants to eliminate, eliminate by creating
  new set plink and run again

` for i in {1..22}`
`do`
` bash code/16_phase_shapeit.sh $i`
`awk '{print $4}' results/16_phase_and_imputation/LACRN-chr${i}.snp.strand |  \`
`tail -n +2 > results/16_phase_and_imputation/LACRN-chr${i}_REMOVE_VARIANTS.list`
` plink -- bfile data_processing /16_phase_and_imputation/LACRN- chr ${i} -- exclude \ `
`results/16_phase_and_imputation/LACRN-chr${i}_REMOVE_VARIANTS.list --a1-allele \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`-- out data_processing /16_phase_and_imputation/LACRN- chr ${i}`
` bash code/16_phase_shapeit.sh $i`
`done`

### IMPUTATION

- Commands that generate the commands to impute 610 windows of 5MB

` bash code/16_looper_impute2.sh 1 50`
` bash code/16_looper_impute2.sh 2 49`
` bash code/16_looper_impute2.sh 3 40`
` bash code/16_looper_impute2.sh 4 39`
` bash code/16_looper_impute2.sh 5 37`
` bash code/16_looper_impute2.sh 6 35`
` bash code/16_looper_impute2.sh 7 31`
` bash code/16_looper_impute2.sh 8 30`
` bash code/16_looper_impute2.sh 9 29`
` bash code/16_looper_impute2.sh 10 28`
` bash code/16_looper_impute2.sh 11 28`
` bash code/16_looper_impute2.sh 12 27`
` bash code/16_looper_impute2.sh 13 24`
` bash code/16_looper_impute2.sh 14 22`
` bash code/16_looper_impute2.sh 15 21`
` bash code/16_looper_impute2.sh 16 19`
` bash code/16_looper_impute2.sh 17 17`
` bash code/16_looper_impute2.sh 18 16`
` bash code/16_looper_impute2.sh 19 12`
` bash code/16_looper_impute2.sh 20 13`
` bash code/16_looper_impute2.sh 21 10`
` bash code/16_looper_impute2.sh 22 11`

These commands generate all possible execution commands of the
IMPUTE2 program, corresponding to all the windows to be imputed,
automatically generating the commands:

` bash code/16_Impute2.sh chr initial_pos final_pos `

chromosome varies , the initial and final position of the window. By
example:

` bash code/16_Impute2.sh 5 1 5000000`

- All these commands are grouped into a maximum of 60 commands per
  BASH file. These BASH files run independently in a
  instance with 90 CPUs and 768 GB of RAM. Having 60 commands of
  When IMPUTE2 is executed, 60 independent processes of this type are executed.
  program, the limitation being RAM memory.

<!-- -->

- This method of Imputation is repeated later in the other
  imputations .

<!-- -->

- Of 610 5MB windows, there are imputed SNPs in 567 windows

<!-- -->

- We join impute 2 files by chromosomes
- It is advisable to delete the files by loops and leave only the
  merged file

` for i in {1..22}`
`do`
`find results/16_phase_and_imputation/ | grep impute2 | grep -v impute2_ |  \`
`grep "chr${i}\\." | xargs -I{} cat {} > results/16_phase_and_imputation/LACRN.chr${i}.impute2 &`
`done`

- Accounting for imputed SNPs

SNPs : 80,955,574 SNPs

` for i in {1..22}`
`do`
`echo $i`
`find results/16_phase_and_imputation/ | grep impute2 | grep -v impute2_ |  \`
`grep "chr${i}\\." | xargs -I{} wc -l {} | awk -F " " '{sum+=$1} END {print sum}'`
`done`

- Delete impute files by windows

`find results/16_phase_and_imputation/ | grep impute2 | grep -v impute2_ |  \`
`grep pos | xargs -I{} rm {}`

ls - lh results /16_phase_and_imputation/ \| grep impute2 \| grep -v
impute2_ \| wc -l

### Imputation filter

- We filter imputed files, keeping only the SNPs that have a
  good probability

` for i in {1..22}`
`do`
`python2.7 code/16_filter_genotype_v2.py results/16_phase_and_imputation/LACRN.chr${i}.impute2 \ `
`0.1 0.9 0 > results/16_phase_and_imputation/LACRN.chr${i}-filter.impute2 &`
`done`

### Get imputed set in plink format

sample file in Oxford format from

` plink --bfile data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF \ `
` --recode oxford --out results /16_phase_and_imputation/ sample `

We use file results /16_phase_and_imputation/ sample.sample

plink files per chromosome

` for i in {1..22}`
`do`
` plink --gen results/16_phase_and_imputation/LACRN.chr${i}-filter.impute2 --sample \ `
` results /16_phase_and_imputation/ sample.sample -- oxford -single- chr $i -- make-bed \ `
`--out results/16_phase_and_imputation/LACRN.chr${i}-imputed-filtered &`
`done`

plink sets by chromosomes into one

`find results/16_phase_and_imputation/ | grep bed | rev | cut -c 4- | rev | xargs -I{}\`
`echo -e "{}bed\t{}bim\t{}fam" > results/16_phase_and_imputation/chr_list.txt`
`head -n -1 results /16_phase_and_imputation/chr_list.txt > \ `
` results /16_phase_and_imputation/chr_list2.txt`

` plink --bfile results/16_phase_and_imputation/LACRN.chr22-imputed-filtered --merge-list \ `
` results /16_phase_and_imputation/chr_list2.txt -- make-bed -- out \ `
` results /16_phase_and_imputation/ LACRN.all-imputed-filtered `

## Stage 17 Quality control on variants of the imputed set

`cp results/16_phase_and_imputation/LACRN.all-imputed-filtered.* \ `
` data_processing /17_quality_filter_variants_imputed/`

bims file identifiers for processing
later

`mv data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered.bim \ `
`data_processing/17_quality_filter_variants_imputed/original_bim/`
` awk '{ print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' \ `
`data_processing/17_quality_filter_variants_imputed/original_bim/LACRN.all-imputed-filtered.bim >\ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered.bim`

### Filter by missing data rate in variants

` plink --bfile data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered \ `
`-- missing -- out \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered-missing`
` Rscript code /17_quality_filter_1_miss.R`

- Number of variants with a missing data rate of >= 10%

` awk '$5 >= 0.1 { print $2}' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered-missing.lmiss |  \`
` tail -n +2 | wc -l`

739,047

- Number of variants with a missing data rate of >= 5%

` awk '$5 >= 0.05 { print $2}' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered-missing.lmiss |  \`
` tail -n +2 | wc -l`

1,415,094

- Number of variants with a missing data rate of >= 1%

` awk '$5 >= 0.01 { print $2}' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered-missing.lmiss |  \`
` tail -n +2 | wc -l`

6,139,412

- We eliminate variants that have a missing data rate of >= 1%

` awk '$5 >= 0.01 { print $2}' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered-missing.lmiss | \`
`tail -n +2 > data_processing/17_quality_filter_variants_imputed/SNPS_missing_LACRN.list`
` plink --bfile data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered \ `
`--exclude data_processing/17_quality_filter_variants_imputed/SNPS_missing_LACRN.list --make-bed\ `
`--out data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter1`

genotyping rate of >99%.

Hardy-Weinberg equilibrium filter

` plink -- bfile \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter1\`
`-- hardy --out data_processing/17_quality_filter_variants_imputed/LACRN_filter1_HW`
` awk '$3 == "ALL(NP)" && $9 < 0.000001 { print $2 }' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN_filter1_HW.hwe > \ `
`data_processing/17_quality_filter_variants_imputed/SNPS_HW_dump_LACRN_filter1.list`

660 variants in the list with pvalue \< 0.000001

` plink -- bfile \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter1\`
`--exclude data_processing/17_quality_filter_variants_imputed/SNPS_HW_dump_LACRN_filter1.list \ `
`-- make-bed -- out \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter2`

- 75,425,432 variants remain after HW filter

<b>data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter2
genotyping rate and by HW

### We remove INDELS in set

` awk '{ if ( length ($5) > 1 || length ($6) > 1) print $2}' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter2.bim > \ `
`data_processing/17_quality_filter_variants_imputed/INDELS_ID_LACRN_filter2.list`

- There are 2350827 INDELS to be eliminated

` plink -- bfile \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter2\`
`--exclude data_processing/17_quality_filter_variants_imputed/INDELS_ID_LACRN_filter2.list \ `
`-- make-bed -- out \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter3`

73,015,459 variants remain

triallelic SNPS :

` awk 'n=x[$1, $4]{ print n"\n"$0;} {x[$1, $4]=$0;}' \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter3.bim |  \`
` cut -f 2 | sort | uniq > \`
`data_processing/17_quality_filter_variants_imputed/SNPS_dump_TRIALELIC_LACRN.list`

199132
data_processing/17_quality_filter_variants_imputed/SNPS_dump_TRIALELIC_LACRN.list

` plink -- bfile \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter3\`
`--exclude data_processing/17_quality_filter_variants_imputed/SNPS_dump_TRIALELIC_LACRN.list \ `
`-- make-bed -- out \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter4`

72,616,182 Variants Remain

### Remove monomorphic variables

` plink -- bfile \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter4\`
`-- freq --out data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-FRQ`
` awk '$5 == 0 { print $0}' \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-FRQ.frq | wc -l`

51193342

- Graph MAF

` Rscript code /17_quality_filter_variants_MAFF.R`

- Filter by MAF 0

` awk '$5 == 0 { print $2}' \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-FRQ.frq > \ `
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-FRQ_0_SNPs.list`
` plink -- bfile \`
`data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter4\`
`--exclude data_processing/17_quality_filter_variants_imputed/LACRN.all-imputed-FRQ_0_SNPs.list \ `
`-- make-bed -- out \`
`results/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter4_0_MAF`

21,422,840 variants remain

## Step 18 Create set for RFMIX or local ancestry estimation

- I create a set of imputed LACRN with variants common to 1000G, SGDP and
  PATAGONIAN

` plink --bfile results/17_quality_filter_variants_imputed/LACRN.all-imputed-filtered_filter4_0_MAF\ `
`-- extract \`
`inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/comm_SNPS_LACRN_1000G_PATAGONIA_SGDP.list \ `
`-- make-bed --out data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/LACRN_comm`

- I create a list of only Amerindians in SGDP

`awk '{print $3"\t"$2}' inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/info_AMR.tsv |  \`
`tail -n +2 > inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/info_AMR_2.tsv`

- I only extract Amerindians in SGDP

` plink -- bfile inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ SGDP_comm -- keep \ `
`inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/info_AMR_2.tsv -- make-bed -- out \ `
`inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ SGDP_comm `

plink sets into one

`find inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ | grep 1000G_comm.bed | rev |  \`
`cut -c 4- | rev | xargs -I{} echo -e "{}bed\t{}bim\t{}fam" > \ `
`data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/SET_list.txt`
`find inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ | grep PATAGONIA_comm.bed |  \`
`rev | cut -c 4- | rev | xargs -I{} echo -e "{}bed\t{}bim\t{}fam" >> \ `
`data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/SET_list.txt`
`find inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ | grep SGDP_comm.bed |  \`
`rev | cut -c 4- | rev | xargs -I{} echo -e "{}bed\t{}bim\t{}fam" >> \ `
`data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/SET_list.txt`

- We merge sets

` plink --bfile data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/LACRN_comm \ `
`--merge-list data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/SET_list.txt --make-bed \ `
`--out results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED`

Error: 2726 variants with 3+ alleles present .`
`* If you believe this es due to strand inconsistency , try -- flip with `
` results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED-merge.missnp.`

triallelic variants between sets

` plink --bfile inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_comm --exclude \ `
`results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED-merge.missnp\ `
`-- make-bed -- out inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_comm`
` plink --bfile inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/PATAGONIA_comm --exclude \ `
`results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED-merge.missnp\ `
`-- make-bed --out inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/PATAGONIA_comm`
` plink -- bfile inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ SGDP_comm -- exclude \ `
`results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED-merge.missnp\ `
`-- make-bed -- out inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/ SGDP_comm `
` plink --bfile data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/LACRN_comm --exclude \ `
`results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED-merge.missnp\ `
`-- make-bed --out data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/LACRN_comm`

- We merge sets AGAIN

` plink --bfile data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/LACRN_comm --merge-list \ `
`data_processing/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/SET_list.txt --allow-no-sex\`
`-- make-bed -- out \`
`results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED`

<b>results/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/1000G_SGDP_PATAGONIAN_LACRN_IMPUTED.fam
</b> final set to use for RFMIX in local ancestry estimation ,
contains:

Total genotyping rate is 0.99081.`
`2775724 variants and 1141 people pass filters and QC.`

## Stage 19 PHASE and IMPUTATION of SGPD reference

Native American samples from the Simons Diversity Project Genome Project (SGPD)

` mkdir original_bim `
` mv cteam_extended.v4.maf0.1perc.bim original_bim /`
` awk '{ print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' \ `
`original_bim/cteam_extended.v4.maf0.1perc.bim > cteam_extended.v4.maf0.1perc.bim`

` mkdir data_processing /19_phase_impute_SGDP`
` mkdir results /19_phase_impute_SGDP`

SGDP samples will be phased and imputed.

- The set will be used
  resources / reference_sets /cteam_extended.v4.maf0.1perc.bim with
  34,418,131 variants

<!-- -->

- 1000G variant file where triallelics and indels were removed
  and CNVs

`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv`

77844341 variants remain

- File with the list of these 77844341 1000G variants sorted by
  identifier

`data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list`

- I create a SGDP subset with chromosomes 1 to 22, autosomal chromosomes

` plink -- bfile resources / reference_sets /cteam_extended.v4.maf0.1perc -- chr 1-22 -- make-bed \`
`-- out data_processing /19_phase_impute_SGDP/SGDP-chr1-22`

33512001 variants remain

- We get a set with common variants for 1000G

`awk '{print $2}' data_processing/19_phase_impute_SGDP/SGDP-chr1-22.bim | sort | uniq > \ `
`data_processing/19_phase_impute_SGDP/list_variants_SGDP_sort.list`
`comm -12 data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list \ `
`data_processing/19_phase_impute_SGDP/list_variants_SGDP_sort.list > \ `
` data_processing /19_phase_impute_SGDP/ list_COMM_variants.list `
` plink -- bfile data_processing /19_phase_impute_SGDP/SGDP-chr1-22 -- extract \ `
` data_processing /19_phase_impute_SGDP/ list_COMM_variants.list -- make-bed -- out \ `
` data_processing /19_phase_impute_SGDP/SGDP-chr1-22-comm`

22264410 variants

plink set allele order in file order
  1000G legend

` plink -- bfile data_processing /19_phase_impute_SGDP/SGDP-chr1-22-comm --a1-allele\`
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`--out data_processing/19_phase_impute_SGDP/SGDP-chr1-22-comm-order-REF`

- Separate sets by chromosomes and order sets according to reference

` for i in {1..22}`
`do`
` plink --bfile data_processing/19_phase_impute_SGDP/SGDP-chr1-22-comm-order-REF --chr $i \ `
`--a1-allele data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv --make-bed\ `
`-- out data_processing /19_phase_impute_SGDP/SGDP- chr ${i}`
`done`

### PHASE

- Phasing, WE ELIMINATE VARIANTS THAT have problems for phasing, such as
  INDELS and where the alternative allele does not match 1000G for example,
  generating new updated set
- We run phases, detect variants to eliminate, eliminate by creating
  new set plink and run again

` for i in {1..22}`
`do`
` bash code/19_phase_shapeit.sh $i`
`awk '{print $4}' results/19_phase_impute_SGDP/SGDP-chr${i}.snp.strand | tail -n +2 > \ `
` results /19_phase_impute_SGDP/SGDP- chr ${i}_ REMOVE_VARIANTS.list `
` plink -- bfile data_processing /19_phase_impute_SGDP/SGDP- chr ${i} -- exclude \ `
` results /19_phase_impute_SGDP/SGDP- chr ${i}_ REMOVE_VARIANTS.list --a1-allele \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`-- out data_processing /19_phase_impute_SGDP/SGDP- chr ${i}`
` bash code/19_phase_shapeit.sh $i`
`done`

### IMPUTATION

We use script code/19_Impute2.sh

Run as:

` bash code/19_Impute2.sh chr posStart posFinal `

The following windows failed out of the total executed, an attempt was made to run
again but it is not possible since there are no genotypes to impute in
those windows:

` bash code/19_Impute2.sh 15 15000001 20000000`
` bash code/19_Impute2.sh 21 5000001 10000000`
` bash code/19_Impute2.sh 21 10000001 15000000`
` bash code/19_Impute2.sh 9 45000001 50000000`
` bash code/19_Impute2.sh 9 65000001 70000000`

- We create files imputed by chromosome

` for i in {1..22}`
`do`
`find results/19_phase_impute_SGDP/ | grep impute2 | grep -v impute2_ | grep "chr${i}\\." |  \`
`xargs -I{} cat {} > results/19_phase_impute_SGDP/SGDP.chr${i}.impute2 &`
`done`

- Delete impute files by windows

`find results/19_phase_impute_SGDP/ | grep impute2 | grep -v impute2_ | grep pos | xargs -I{}rm{}`

### Imputation filter

- We filter imputed files, keeping only the SNPs that have a
  good probability

` for i in {1..22}`
`do`
`python2.7 code/16_filter_genotype_v2.py results/19_phase_impute_SGDP/SGDP.chr${i}.impute2 \`
`0.1 0.9 0 > results/19_phase_impute_SGDP/SGDP.chr${i}-filter.impute2 &`
`done`

### Get imputed set in plink format

sample file in Oxford format from

` plink --bfile data_processing/19_phase_impute_SGDP/SGDP-chr1-22-comm-order-REF --recode oxford \ `
`-- out results /19_phase_impute_SGDP/ sample `

We use the file results /19_phase_impute_SGDP/ sample.sample

plink files per chromosome

` for i in {1..22}`
`do`
` plink --gen results /19_phase_impute_SGDP/ SGDP.chr ${i}-filter.impute2 -- sample \ `
` results /19_phase_impute_SGDP/ sample.sample -- oxford -single- chr $i -- make-bed -- out \ `
` results /19_phase_impute_SGDP/ SGDP.chr ${i}- imputed-filtered &`
`done`

plink sets by chromosomes into one

`find results/19_phase_impute_SGDP/ | grep bed | rev | cut -c 4- | rev | xargs -I{} echo -e \ `
`"{}bed\t{}bim\t{}fam" > results/19_phase_impute_SGDP/chr_list.txt`
`head -n -1 results/19_phase_impute_SGDP/chr_list.txt > results/19_phase_impute_SGDP/chr_list2.txt`

` plink -- bfile results /19_phase_impute_SGDP/SGDP.chr15-imputed-filtered -- merge-list \ `
` results /19_phase_impute_SGDP/chr_list2.txt -- allow -no-sex -- make-bed -- out \ `
` results /19_phase_impute_SGDP/ SGDP.all-imputed-filtered `

## Stage 20 PHASE and IMPUTATION of reference PATAGONIA

- 17 Mapuche samples that were genome sequenced will be imputed
  complete at a high depth of coverage (30X)

` mkdir data_processing /20_phase_impute_PATAGONIA`
` mkdir results /20_phase_impute_PATAGONIA`

The PATAGONIA samples will be phased and imputed.

- The set resources / reference_sets / CLG_AMR.bim with 9058848 will be used
  variants

<!-- -->

- 1000G variant file where triallelics and indels were removed
  and CNVs

`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv`

77844341 variants remain

- File with the list of these 77844341 1000G variants sorted by
  identifier

`data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list`

- I create a subset of PATAGONIA with chromosomes 1 to 22, chromosomes
  autosomal

` plink -- bfile resources / reference_sets /CLG_AMR -- chr 1-22 -- make-bed -- out \ `
` data_processing /20_phase_impute_PATAGONIA/PATAGONIA-chr1-22`

8756105 variants remain

- We get a set with common variants for 1000G

`awk '{print $2}' data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22.bim | sort |  \`
`uniq > data_processing/20_phase_impute_PATAGONIA/list_variants_PATAGONIA_sort.list`
`comm -12 data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list \ `
`data_processing/20_phase_impute_PATAGONIA/list_variants_PATAGONIA_sort.list > \ `
`data_processing/20_phase_impute_PATAGONIA/list_COMM_variants.list`
` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22 --extract \ `
`data_processing/20_phase_impute_PATAGONIA/list_COMM_variants.list --make-bed --out \ `
`data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm`

6047697 variants

plink set allele order in file order
  1000G legend

` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm --a1-allele \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`--out data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF`

genotyping rate

` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF \ `
`-- missing --out data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-missing`

`R`
`miss <- read.table ("\`
`data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-missing.lmiss" , \`
` header =T)`
`png(" results /20_phase_impute_PATAGONIA/missing_patagonia.png")`
` hist ( miss$F_MISS )`
` dev.off ()`

- Number of variants with a missing data rate of >= 60%

` awk '$5 >= 0.6 { print $2}' \ `
`data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-missing.lmiss |  \`
` tail -n +2 | wc -l`
`2366883`

- We eliminated variants that had a missing data rate of >= 60%

` awk '$5 >= 0.6 { print $2}' \ `
`data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-missing.lmiss |  \`
`tail -n +2 > data_processing/20_phase_impute_PATAGONIA/SNPS_missing_PATAGONIA.list`
` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF \ `
`--exclude data_processing/20_phase_impute_PATAGONIA/SNPS_missing_PATAGONIA.list --make-bed \ `
`--out data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-filter1`

genotyping rate of >60%.

- Separate sets by chromosomes and order sets according to reference

` for i in {1..22}`
`do`
` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-filter1\ `
`-- chr $i --a1-allele data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv \ `
`-- make-bed -- out data_processing /20_phase_impute_PATAGONIA/PATAGONIA- chr ${i}`
`done`

### PHASE

- Phasing, WE ELIMINATE VARIANTS THAT have problems for phasing, such as
  INDELS and where the alternative allele does not match 1000G for example,
  generating new updated set
- We run phases, detect variants to eliminate, eliminate by creating
  new set plink and run again

` for i in {1..22}`
`do`
` bash code/20_phase_shapeit.sh $i`
`awk '{print $4}' results/20_phase_impute_PATAGONIA/PATAGONIA-chr${i}.snp.strand |  \`
`tail -n +2 > results/20_phase_impute_PATAGONIA/PATAGONIA-chr${i}_REMOVE_VARIANTS.list`
` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr${i} --exclude \ `
`results/20_phase_impute_PATAGONIA/PATAGONIA-chr${i}_REMOVE_VARIANTS.list --a1-allele \ `
`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 --make-bed \ `
`-- out data_processing /20_phase_impute_PATAGONIA/PATAGONIA- chr ${i}`
` bash code/20_phase_shapeit.sh $i`
`done`

### IMPUTATION

We use script code/20_Impute2.sh

Run as:

` bash code/20_Impute2.sh chr posStart posFinal `

No windows failed out of the total executed

- We create files imputed by chromosome

` for i in {1..22}`
`do`
`find results/20_phase_impute_PATAGONIA/ | grep impute2 | grep -v impute2_ | grep "chr${i}\\." | \`
`xargs -I{} cat {} > results/20_phase_impute_PATAGONIA/PATAGONIA.chr${i}.impute2 &`
`done`

- Delete impute files by windows

`find results/20_phase_impute_PATAGONIA/ | grep impute2 | grep -v impute2_ | grep pos | xargs\`
`-I{} rm {}`

### Imputation filter

- We filter imputed files, keeping only the SNPs that have a
  good probability

` for i in {1..22}`
`do`
`python2.7 code/16_filter_genotype_v2.py\`
` results /20_phase_impute_PATAGONIA/ PATAGONIA.chr ${i}.impute2 \ `
`0.1 0.9 0 > results/20_phase_impute_PATAGONIA/PATAGONIA.chr${i}-filter.impute2 &`
`done`

### Get imputed set in plink format

sample file in Oxford format from

` plink --bfile data_processing/20_phase_impute_PATAGONIA/PATAGONIA-chr1-22-comm-order-REF-filter1\ `
` --recode oxford --out results /20_phase_impute_PATAGONIA/ sample `

We use fileresults /20_phase_impute_PATAGONIA/ sample.sample

plink files per chromosome

` for i in {1..22}`
`do`
` plink --gen results/20_phase_impute_PATAGONIA/PATAGONIA.chr${i}-filter.impute2 --sample \ `
` results /20_phase_impute_PATAGONIA/ sample.sample -- oxford -single- chr $i -- make-bed -- out \ `
`results/20_phase_impute_PATAGONIA/PATAGONIA.chr${i}-imputed-filtered &`
`done`

plink sets by chromosomes into one

`find results/20_phase_impute_PATAGONIA/ | grep bed | rev | cut -c 4- | rev | xargs -I{}\`
`echo -e "{}bed\t{}bim\t{}fam" > results/20_phase_impute_PATAGONIA/chr_list.txt`
`head -n -1 results /20_phase_impute_PATAGONIA/chr_list.txt > \`
` results /20_phase_impute_PATAGONIA/chr_list2.txt`

` plink --bfile results/20_phase_impute_PATAGONIA/PATAGONIA.chr9-imputed-filtered --merge-list \ `
` results /20_phase_impute_PATAGONIA/chr_list2.txt -- make-bed -- out \ `
`results/20_phase_impute_PATAGONIA/PATAGONIA.all-imputed-filtered`

## STAGE 21 merge_PATAGONIA_SGDP_IMPUTED

` data_processing /21_merge_PATAGONIA_SGDP_IMPUTED`
` results /21_merge_PATAGONIA_SGDP_IMPUTED`

- IMMUTED SGDP SET (81300780 variants):

` results /19_phase_impute_SGDP/ SGDP.all-imputed-filtered `

- PATAGONIA SET IMPUTED (variants 81706022):

`results/20_phase_impute_PATAGONIA/PATAGONIA.all-imputed-filtered`

### We changed BIMS identifiers

` mkdir results /19_phase_impute_SGDP/ original_bim `
` mkdir results /20_phase_impute_PATAGONIA/ original_bim `

` mv results /19_phase_impute_SGDP/ SGDP.all-imputed-filtered.bim \`
` results /19_phase_impute_SGDP/ original_bim `
` awk '{ print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' \ `
`results/19_phase_impute_SGDP/original_bim/SGDP.all-imputed-filtered.bim > \ `
` results /19_phase_impute_SGDP/ SGDP.all-imputed-filtered.bim `

`mv results/20_phase_impute_PATAGONIA/PATAGONIA.all-imputed-filtered.bim \ `
` results /20_phase_impute_PATAGONIA/ original_bim `
` awk '{ print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' \ `
`results/20_phase_impute_PATAGONIA/original_bim/PATAGONIA.all-imputed-filtered.bim > \ `
`results/20_phase_impute_PATAGONIA/PATAGONIA.all-imputed-filtered.bim`

### We eliminated INDELS in both sets

` awk '{ if ( length ($5) > 1 || length ($6) > 1) print $2}' \ `
`results/19_phase_impute_SGDP/SGDP.all-imputed-filtered.bim > \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_SGDP.list`
` awk '{ if ( length ($5) > 1 || length ($6) > 1) print $2}' \ `
`results/20_phase_impute_PATAGONIA/PATAGONIA.all-imputed-filtered.bim > \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_PATAGONIA.list`

`cat data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_SGDP.list | sort | uniq > \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_SGDP_uniq.list`

3163639 variants to be eliminated

`cat data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_PATAGONIA.list | sort | uniq > \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_PATAGONIA_uniq.list`

3179449 variants to be eliminated

- We eliminated INDELS

` plink -- bfile results /19_phase_impute_SGDP/ SGDP.all-imputed-filtered -- exclude \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_SGDP_uniq.list --make-bed --out \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter1`

77884913 variants left

` plink --bfile results/20_phase_impute_PATAGONIA/PATAGONIA.all-imputed-filtered --exclude \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/INDELS_ID_PATAGONIA_uniq.list --make-bed \ `
`--out data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter1`

78273171 variants left

### We eliminated triallelic SNPS in both sets

` awk 'n=x[$1, $4]{ print n"\n"$0;} {x[$1, $4]=$0;}' \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter1.bim |  \`
` cut -f 2 | sort | uniq > \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SNPS_dump_TRIALELIC_SGDP.list`

258148
data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SNPS_dump_TRIALELIC_SGDP.list

` plink --bfile data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter1 \ `
`--exclude data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SNPS_dump_TRIALELIC_SGDP.list \`
`-- make-bed -- out \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2`

77367085 variants

` awk 'n=x[$1, $4]{ print n"\n"$0;} {x[$1, $4]=$0;}' \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter1.bim |  \`
` cut -f 2 | sort | uniq > \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SNPS_dump_TRIALELIC_PATAGONIA.list`

259429
data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SNPS_dump_TRIALELIC_PATAGONIA.list

` plink -- bfile \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter1\`
`--exclude data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SNPS_dump_TRIALELIC_PATAGONIA.list \ `
`-- make-bed -- out \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter2`

77752770 variants

### Create sets with common variants (MERGE) of imputed Native American references

` awk '{ print $2}' \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2.bim \ `
`| sort | uniq > data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP-list-variants.list`
` awk '{ print $2}' \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter2.bim |  \`
`sort | uniq > data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA-list-variants.list`
`comm -12 data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP-list-variants.list \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA-list-variants.list > \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/comm-variants.list`

77367085 common variants

` plink --bfile data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2 \ `
`--extract data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/comm-variants.list --make-bed \ `
`--out data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2-comm`
` plink -- bfile \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter2\`
`--extract data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/comm-variants.list --make-bed \ `
`--out data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter2-comm`

- I only extract Amerindians in SGDP

` plink -- bfile \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2-comm\`
`--keep inputs/18_SET_COMM_1000G_SGDP_PATAGONIAN_LACRN/info_AMR_2.tsv --make-bed --out \ `
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2-comm-AMR`

- We combined both sets of SGDP and PATAGONIA references

` plink -- bfile \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/SGDP.all-imputed-filtered_filter2-comm-AMR\`
`-- bmerge \`
`data_processing/21_merge_PATAGONIA_SGDP_IMPUTED/PATAGONIA.all-imputed-filtered_filter2-comm \ `
`-- allow -no-sex -- make-bed --out results/21_merge_PATAGONIA_SGDP_IMPUTED/AMR_REFERENCE-IMPUTED`

## Step 22 IMPUTE_LACRN_1000G_AMR or LACRN(1000G+PAT+SGDP)

- The LACRN samples will be imputed using as reference the
  1000G samples and those of AMERINDIAS imputed

` mkdir data_processing /22_IMPUTAR_LACRN_1000G_AMR`
` mkdir results /22_IMPUTAR_LACRN_1000G_AMR`

### PROCESSING OF IMPUTED AMERINDIAN REFERENCE FOR PRE-PHASING

The set of references AMERINCIAS of SGDP and PATAGONIA will be phased
previously charged

` results /21_merge_PATAGONIA_SGDP_IMPUTED/AMR_REFERENCE-IMPUTED`

77367085 variants

- 1000G variant file where triallelics and indels were removed
  and CNVs

`data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv`

77844341 variants

- File with the list of these 77844341 1000G variants sorted by
  identifier

`data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list`

- We get a set with common variants for 1000G

`awk '{print $2}' results/21_merge_PATAGONIA_SGDP_IMPUTED/AMR_REFERENCE-IMPUTED.bim | sort |  \`
`uniq > data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_variants_AMR_IMPUTED_sort.list`
`comm -12 data_processing/16_phase_and_imputation/list_variants_1000G_uniq.list \ `
`data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_variants_AMR_IMPUTED_sort.list > \ `
`data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_COMM_variants.list`

77365649
data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_COMM_variants.list

` plink --bfile results/21_merge_PATAGONIA_SGDP_IMPUTED/AMR_REFERENCE-IMPUTED --extract \ `
`data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_COMM_variants.list --make-bed --out \ `
`data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-comm`

77365649 variants

- Correct the order of alleles in the AMERINDIAN reference set of SGDP and
  1000G legend file order

` plink --bfile data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-comm \ `
`--a1-allele data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv 2 1 \ `
`-- make-bed --out data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-comm-order-REF`

- Separate sets by chromosomes and order sets according to reference

` for i in {1..22}`
`do`
` plink --bfile data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-comm-order-REF \ `
`-- chr $i --a1-allele data_processing/16_phase_and_imputation/VARIANTS_1000G_LEGEND_filter3.tsv \ `
`-- make-bed --out data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${i}`
`done`

### PHASE

- Phasing, WE ELIMINATE VARIANTS THAT have problems for phasing, such as
  alternative allele does not match 1000G for example,
  generating new updated set
- We run phases, detect variants to eliminate, eliminate by creating
  new set plink and run again

` for i in {1..22}`
`do`
` bash code/22_phase_shapeit.sh $i`
`done`

- chromosome 15 could not be phased since there are two fariantes with one
  100% genotyping rate

Reading reference haplotypes in
\[ resources /1000G/1000GP_Phase3/1000GP_Phase3_chr15.hap.gz\]

`Reading genetic map in [resources/1000G/1000GP_Phase3/genetic_map_chr15_combined_b37.txt]`
`* 90378 genetic positions found`
` * #set=88825 / #interpolated=2229608`
` * Physical map [20.00 Mb -> 102.52 Mb] / Genetic map [0.00 cM -> 150.90 cM]`

` Checking missingness and MAF...`
` * 0 individuals with high rates of missing data (>5%)`
` * 25219 SNPs with high rates of missing data (>5%) `

`ERROR: 2 fully missing SNPs (=100%)`

genotyping rate on chromosome 15

` plink --bfile data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr15 --missing \ `
`-- out data_processing /22_IMPUTAR_LACRN_1000G_AMR/missing-15`
`awk ' $5 > 0.9 {print $2}' data_processing/22_IMPUTAR_LACRN_1000G_AMR/missing-15.lmiss |   \`
`tail -n +2 > data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_missing09-15.list`
` plink --bfile data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr15 \ `
`--exclude data_processing/22_IMPUTAR_LACRN_1000G_AMR/list_missing09-15.list --make-bed \ `
`--out data_processing/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr15`

`i=15`
` bash code/22_phase_shapeit.sh $i`

### CONVERT phased set to impute2 format

<https://github.com/baharian/SHAPEIT_to_PLINK>

` for i in {1..22}`
`do`
`python2.7 code/19_convert_shapeit2_to_impute2.py\`
`results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${i}.haps \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${i}.sample \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${i}-format-impute2.haps \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${i}-format-impute2.legend \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${i}-format-impute2.sample &`
`done`

### IMPUTE LACRN using 1000G + AMR reference imputed

We will impute the LACRN samples using the samples from
1000G and the imputed set of AMERINDIAN samples found in
impute2 format ( haps , legend , sample )

- For each 5MB window we will use the following command to impute
  using both sets of references.

`bash code/22_Impute2_two_references.sh CHR CHUNK_START CHUNK_END`

Code :

`#!/bin/bash`
`CHR=$1`
`` CHUNK_START=` printf "%.0f" $2` ``
`` CHUNK_END=` printf "%.0f" $3` ``

`# directories`
`RESULTS_DIR=" results /22_IMPUTAR_LACRN_1000G_AMR/" `
`# executable (IMPUTE version 2.2.0 or higher)`
`IMPUTE2_EXEC=imput2`
`# parameters `
`NE=20000`
`# 1000 genomes reference files.`
`GENMAP_FILE="resources/1000G/1000GP_Phase3/genetic_map_chr${CHR}_combined_b37.txt"`
`HAPS_FILE="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.hap.gz"`
`LEGEND_FILE="resources/1000G/1000GP_Phase3/1000GP_Phase3_chr${CHR}.legend.gz"`

`#imputed and phased AMR reference files`
`HAPS_FILE_AMR=\`
`"results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${CHR}-format-impute2.haps"`
`LEGEND_FILE_AMR=\`
`"results/22_IMPUTAR_LACRN_1000G_AMR/AMR_REFERENCE-IMPUTED-chr${CHR}-format-impute2.legend" `

`# haplotypes generated with SHAPEIT`
`GWAS_HAPS_FILE="results/16_phase_and_imputation/LACRN-chr${CHR}.haps"`
`# output imputed files.`
`OUTPUT_FILE="${RESULTS_DIR}LACRN_REF_1000G-AMR.chr${CHR}.pos${CHUNK_START}-${CHUNK_END}.impute2"`
`## command line`
`$IMPUTE2_EXEC \`
` - merge_ref_panels \`
` - use_prephased_g \`
` -m $GENMAP_FILE \`
` - known_haps_g $GWAS_HAPS_FILE \`
` -h $HAPS_FILE $HAPS_FILE_AMR\`
` -l $LEGEND_FILE $LEGEND_FILE_AMR\`
` -Ne $NE \`
` - int $CHUNK_START $CHUNK_END \`
` -o $OUTPUT_FILE \`
` - allow_large_regions \`
` - seed 367946 &`

- We create files imputed by chromosome (By space. When I executed
  These commands had already previously expanded the volume which was
  I was checking. It required even more space but I couldn't go back
  expand storage space in quite a while)

` for i in {1..11}`
`do`
`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep impute2 | grep -v impute2_ | grep pos |  \`
`grep " chr ${i}\\." | xargs -I{} cat {} > \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr${i}.impute2 &`
`done`

- We deleted impute files from windows to chromosome 1 to 11

` for i in {1..11}`
`do`
`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep impute2 | grep -v impute2_ | grep pos |  \`
`grep " chr ${i}\\." | xargs -I{} rm {}`
`done`

- We create files imputed by chromosome

` for i in {12..22}`
`do`
`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep impute2 | grep -v impute2_ | grep pos |  \`
`grep " chr ${i}\\." | xargs -I{} cat {} > \`
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr${i}.impute2 &`
`done`

- We deleted impute files from windows to chromosome 1 to 11

` for i in {12..22}`
`do`
`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep impute2 | grep -v impute2_ | grep pos |  \`
`grep " chr ${i}\\." | xargs -I{} rm {}`
`done`

### Imputation filter

- We filter imputed files, keeping only the SNPs that have a
  good probability

` for i in {1..22}`
`do`
`python2.7 code/16_filter_genotype_v2.py\`
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr${i}.impute2 0.1 0.9 0 > \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr${i}-filter.impute2 &`
`done`

### Get imputed set in plink format

sample file in Oxford format from

` plink --bfile data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF \`
` --recode oxford --out results /22_IMPUTAR_LACRN_1000G_AMR/ sample `

We use the file results /22_IMPUTAR_LACRN_1000G_AMR/ sample.sample

plink files per chromosome

` for i in {1..22}`
`do`
` plink --gen results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr${i}-filter.impute2 \ `
`-- sample results /22_IMPUTAR_LACRN_1000G_AMR/ sample.sample -- oxford -single- chr $i -- make-bed \`
`-- out \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr${i}-imputed-filtered &`
`done`

plink sets by chromosomes into one

`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep bed | rev | cut -c 4- | rev | xargs -I{}\`
`echo -e "{}bed\t{}bim\t{}fam" > results/22_IMPUTAR_LACRN_1000G_AMR/chr_list.txt`
`head -n -1 results/22_IMPUTAR_LACRN_1000G_AMR/chr_list.txt > \ `
` results /22_IMPUTAR_LACRN_1000G_AMR/chr_list2.txt`

` plink --bfile results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.chr22-imputed-filtered \ `
`-- merge-list results /22_IMPUTAR_LACRN_1000G_AMR/chr_list2.txt -- make-bed -- out \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.all-imputed-filtered`

## STAGE 23 get IMPUTATION metrics

- The following commands using R scripts get metrics
  using the data obtained from the imputation

`Rscript code/22_Get_MEtrics_Imputation.R results/16_phase_and_imputation/ LACRN`
`Rscript code/22_Get_MEtrics_Imputation.R results/19_phase_impute_SGDP/ SGDP`
`Rscript code/22_Get_MEtrics_Imputation.R results/20_phase_impute_PATAGONIA/ PATAGONIA`
`Rscript code/22_Get_MEtrics_Imputation_2.R results/22_IMPUTAR_LACRN_1000G_AMR/ LACRN_REF_1000G_AMR`

- Departures:

`"results/23_metrics_IMPUTED/", "Histogram_concordance_by_Sample_",name_set,".png"`
`"results/23_metrics_IMPUTED/", "Histogram_R2_by_Sample_",name_set,".png"`
`"results/23_metrics_IMPUTED/", "Summary_",name_set,"_by_file_Concordance.csv"`
`" results /23_metrics_IMPUTED/", " Summary _",name_set,". csv "`
`"results/23_metrics_IMPUTED/", "Histogram_Perc_Called_",name_set,".png"`
`"results/23_metrics_IMPUTED/", "Histogram_Perc_Concordance_",name_set,".png"`

<b>I got the metrics from the files: \*.impute2_info_by_sample
where I obtained the concordance and R2 of the 980 samples per window of
imputation and the files \*.impute2_summary where the is at the end
Concordance table with genotypes with calling rate = 0.9

Results in

` results /23_metrics_IMPUTED/`

### We obtain imputation metrics in LACRN set imputed only with 1000G

`Rscript code/22_Get_MEtrics_Imputation.R results/16_phase_and_imputation/ LACRN`

Number of windows processed:

`567`

Number of imputed SNPs obtained:

`81706022`

### We get imputation metrics in SGDP set

`Rscript code/22_Get_MEtrics_Imputation.R results/19_phase_impute_SGDP/ SGDP`

Number of windows processed:

`560`

Number of imputed SNPs obtained:

`81300780`

### We obtain imputation metrics in set PATAGONIA

`Rscript code/22_Get_MEtrics_Imputation.R results/20_phase_impute_PATAGONIA/ PATAGONIA`

Number of windows processed:

`567`

Number of imputed SNPs obtained:

`81706022`

### We obtain imputation metrics in imputed LACRN set with 1000G and imputed SGDP+PATAGONIA

`Rscript code/22_Get_MEtrics_Imputation_2.R results/22_IMPUTAR_LACRN_1000G_AMR/ LACRN_REF_1000G_AMR`

Number of windows processed:

`567`

Number of imputed SNPs obtained:

`81704742`

### Processing metrics in imputations by variant

- We generate summary files with metrics with imputation by variant
  from set LACRN

`find results/16_phase_and_imputation/ | grep impute2_info | grep -v impute2_info_by_sample > \ `
` results /16_phase_and_imputation/list_info_used.txt`
` list_files =" results /16_phase_and_imputation/list_info_used.txt"`
` while IFS= read -r line`
` do`
` #echo $line`
` awk '$12 != -1 { print $0}' $line >> \`
` results /16_phase_and_imputation/resume_used_variants_LACRN.txt`
`done < "$ list_files "`
`head -n 1 results/16_phase_and_imputation/resume_used_variants_LACRN.txt > \ `
`results/16_phase_and_imputation/resume_used_variants_LACRN.resume`
`grep -v "snp_id" results/16_phase_and_imputation/resume_used_variants_LACRN.txt >> \ `
`results/16_phase_and_imputation/resume_used_variants_LACRN.resume`

`results/16_phase_and_imputation/resume_used_variants_LACRN.resume`
`wc -l results/16_phase_and_imputation/resume_used_variants_LACRN.resume`
`1184290 results/16_phase_and_imputation/resume_used_variants_LACRN.resume`

- We generate summary files with metrics with imputation by variant
  from set SGDP

`find results/19_phase_impute_SGDP/ | grep impute2_info | grep -v impute2_info_by_sample > \ `
` results /19_phase_impute_SGDP/list_info_used.txt`
` list_files =" results /19_phase_impute_SGDP/list_info_used.txt"`
` while IFS= read -r line`
` do`
` awk '$12 != -1 {print $0}' $line >> results/19_phase_impute_SGDP/resume_used_variants_SGDP.txt`
`done < "$ list_files "`
`head -n 1 results/19_phase_impute_SGDP/resume_used_variants_SGDP.txt > \ `
` results /19_phase_impute_SGDP/ resume_used_variants_SGDP.resume `
`grep -v "snp_id" results/19_phase_impute_SGDP/resume_used_variants_SGDP.txt >> \ `
` results /19_phase_impute_SGDP/ resume_used_variants_SGDP.resume `

` results /19_phase_impute_SGDP/ resume_used_variants_SGDP.resume `
`wc -l results/19_phase_impute_SGDP/resume_used_variants_SGDP.resume`
`21802847 results/19_phase_impute_SGDP/resume_used_variants_SGDP.resume`

- We generate summary files with metrics with imputation by variant
  from set PATAGONIA

`find results/20_phase_impute_PATAGONIA/ | grep impute2_info | grep -v impute2_info_by_sample > \ `
` results /20_phase_impute_PATAGONIA/list_info_used.txt`
`list_files="results/20_phase_impute_PATAGONIA/list_info_used.txt"`
` while IFS= read -r line`
` do`
` awk '$12 != -1 { print $0}' $line >> \`
`results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.txt`
`done < "$ list_files "`
`head -n 1 results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.txt > \ `
`results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.resume`
`grep -v "snp_id" results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.txt >> \ `
`results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.resume`

`results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.resume`
`wc -l results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.resume`
`3153537 results/20_phase_impute_PATAGONIA/resume_used_variants_PATAGONIA.resume`

- We generate summary files with metrics with imputation by variant
  from set LACRN(1000G+SGDP+PAT)

`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep impute2_info | grep -v \ `
`impute2_info_by_sample > results/22_IMPUTAR_LACRN_1000G_AMR/list_info_used.txt`
`list_files="results/22_IMPUTAR_LACRN_1000G_AMR/list_info_used.txt"`
` while IFS= read -r line`
` do`
` awk '$12 != -1 { print $0}' $line >> \`
`results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.txt`
`done < "$ list_files "`
`head -n 1 results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.txt > \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.resume`
`grep -v "snp_id" results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.txt >> \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.resume`

`results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.resume`
`wc -l results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.resume`
`1184416 results/22_IMPUTAR_LACRN_1000G_AMR/resume_used_variants_LACRN_REF.resume`

#### We obtain MAF in imputed variants

- We use set
  data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF
- We calculate frequency or MAF in the set that was imputed from LACRN

` plink --bfile data_processing/16_phase_and_imputation/LACRN-chr1-22-comm-order-REF \ `
`-- freq -- out results /23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq`

- We generate a list of variants with MAF between 0 and 0.05 (\>0 and \<= 0.05)

` awk '$5 >0 && $5 <= 0.05 { print $0}' \`
`results/23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq.frq \ `
`> results/23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq_0_05.frq`

- We generate a list of variants with MAF greater than 0.05 (>0.05)

`awk '$5 > 0.05 {print $0}' results/23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq.frq > \ `
`results/23_metrics_IMPUTED/LACRN-chr1-22-comm-order-REF-frq_more_05.frq`

- We obtain metrics from imputation by samples, by variants and
  by variants according to MAF

<!-- -->

- Script to generate tables and images

` Rscript code /23_resumen_metricas_imputacion.R`

- Departures:

`" results /23_metrics_IMPUTED/CONCORANCE_SETs_09GEnos.png"`
`" results /23_metrics_IMPUTED/CONCORANCE_SETs_by_sample.png"`
`" results /23_metrics_IMPUTED/R2_SETs_by_sample.png"`
`" results /23_metrics_IMPUTED/R2_SETs_by_VARIANTS.png"`
`"results/23_metrics_IMPUTED/R2_SETs_by_VARIANTS_gruoped_by_MAF.png"`

### Getting metrics from info files

=

Metrics will be obtained by variant from the info files of the
imputed windows

info files in set LACRN(1000G+PAT+SGDP)

`find results/22_IMPUTAR_LACRN_1000G_AMR/ | grep .impute2_info | grep -v by_sample > \ `
` results /23_metrics_IMPUTED/list_infos_file_LACRN.txt`

`list_files="results/23_metrics_IMPUTED/list_infos_file_LACRN.txt"`
` while IFS= read -r line`
` do `
` awk '{print $7}' $line | tail -n +2 >> results/23_metrics_IMPUTED/all_info_LACRN.txt`
`done < "$ list_files " `

- We graph the distribution of information

`R`
`table <- read.table("results/23_metrics_IMPUTED/all_info_LACRN.txt", header=F)`
`png(" results /23_metrics_IMPUTED/hist_all_info_LACRN.png")`
`hist(table$V1, main="Histogram info values LACRN(1000G+PAT+SGDP)", xlab="Info")`
` dev.off ()`

- We generate a list of variants with an info value less than 0.5

`list_files="results/23_metrics_IMPUTED/list_infos_file_LACRN.txt"`
` while IFS= read -r line`
` do `
` ####echo $line`
` chr =$( awk -F " chr " '{ print $2}' <(echo "$line") )`
` chr =$( awk -F " pos " '{ print $1}' <(echo "$ chr ") )`
` chr2=$( echo "$ chr " | rev | cut -c 2- | rev )`
` ####echo $chr2`
` awk '$7<0.5 { print '"$chr2"'":"$3"\t"$7}' $line >> \ `
` results /23_metrics_IMPUTED/infos_file_LACRN_less_05.txt`
`done < "$ list_files " `

- 51743222 variants with info less than 0.5 will be eliminated

`51743222 results/23_metrics_IMPUTED/infos_file_LACRN_less_05.txt`

- We generate a list of variants with info value of all variants

`list_files="results/23_metrics_IMPUTED/list_infos_file_LACRN.txt"`
` while IFS= read -r line`
` do `
` ####echo $line`
` chr =$( awk -F " chr " '{ print $2}' <(echo "$line") )`
` chr =$( awk -F " pos " '{ print $1}' <(echo "$ chr ") )`
` chr2=$( echo "$ chr " | rev | cut -c 2- | rev )`
` ####echo $chr2`
` awk '{print '"$chr2"'":"$3"\t"$7}' $line >> results/23_metrics_IMPUTED/infos_file_LACRN_all.txt`
`done < "$ list_files "`

plink set variant ID and column
INFO, this file can be used by another researcher to filter
plink set LACRN(1000G+PAT+SGDP)

`81705309 results /23_metrics_IMPUTED/infos_file_LACRN_all.txt`

- Generate filtered imputed LACRN(1000G+PAT+SGDP) plink set
  removing variants with info \<0.5
- Route of the imputed set:

`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.all-imputed-filtered.* (bed,bim,fam)`

BIM variant identifiers

` mkdir results /22_IMPUTAR_LACRN_1000G_AMR/ orginal_bim `
`mv results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.all-imputed-filtered.bim \ `
` results /22_IMPUTAR_LACRN_1000G_AMR/ orginal_bim /`
` awk '{ print $1"\t"$1":"$4"\t"$3"\t"$4"\t"$5"\t"$6}' \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/orginal_bim/LACRN_REF_1000G-AMR.all-imputed-filtered.bim > \ `
`results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.all-imputed-filtered.bim`

- We eliminated variants with info \< 0.5 in imputation

` plink --bfile results/22_IMPUTAR_LACRN_1000G_AMR/LACRN_REF_1000G-AMR.all-imputed-filtered \ `
`--exclude results/23_metrics_IMPUTED/infos_file_LACRN_less_05.txt --make-bed --out \ `
`results/23_metrics_IMPUTED/LACRN_REF_1000G-AMR.all-imputed-filtered-info_more_05`

- Set filtered in:

`results/23_metrics_IMPUTED/LACRN_REF_1000G-AMR.all-imputed-filtered-info_more_05`
`29751535 variants and 980 people pass filters and QC.`
`wc -l results/23_metrics_IMPUTED/LACRN_REF_1000G-AMR.all-imputed-filtered-info_more_05.bim `
`29751535 results/23_metrics_IMPUTED/LACRN_REF_1000G-AMR.all-imputed-filtered-info_more_05.bim`


## References

<https://genome.sph.umich.edu/wiki/IMPUTE2:_1000_Genomes_Imputation_Cookbook>

Pipeline developed by Cristian Yáñez, Bioinformatics Engineer.
ChileGenomico Laboratory , Faculty of Medicine, University of Chile.
