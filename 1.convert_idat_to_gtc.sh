#!/bin/bash

export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

bpm_manifest_file="covid_genotypes/illumina_support_files/GSA-24v3-0_A2.bpm"
egt_cluster_file="covid_genotypes/illumina_support_files/GSA-24v3-0_A1_ClusterFile.egt"
path_to_output_folder="covid_genotypes/gtc/"
path_to_idat_folder="covid_genotypes/idat/idat_files/"

## 1) convert idat files to gtc files
$HOME/bin/iaap-cli/iaap-cli gencall $bpm_manifest_file $egt_cluster_file $path_to_output_folder -f $path_to_idat_folder -g
