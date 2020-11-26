#!/bin/bash

export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

bpm_manifest_file="covid_genotypes/illumina_support_files/GSA-24v3-0_A2.bpm"
csv_manifest_file="covid_genotypes/illumina_support_files/GSA-24v3-0_A2.csv"
egt_cluster_file="covid_genotypes/illumina_support_files/GSA-24v3-0_A1_ClusterFile.egt"
ref="$HOME/res/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna" # or ref="$HOME/res/human_g1k_v37.fasta
path_to_gtc_folder="covid_genotypes/gtc/"
out_prefix="folder_204212610005"

## 2) convert gtc files to vcf files
bcftools +gtc2vcf --no-version -Ou --bpm $bpm_manifest_file --csv $csv_manifest_file --egt $egt_cluster_file --gtcs $path_to_gtc_folder --fasta-ref $ref --extra $out_prefix.tsv | bcftools sort -Ou -T ./bcftools-sort.XXXXXX | bcftools norm --no-version -Ob -o $out_prefix.bcf -c x -f $ref &&  bcftools index -f $out_prefix.bcf

## 3) extract the .crt and .srx files from the .tsv file (produced with the --extra option) ## remove extension .gtc from sample names
tail -n+2 $out_prefix.tsv | cut -f1,21 > $out_prefix.crt
tail -n+2 $out_prefix.tsv | cut -f1,22 > $out_prefix.sex
