#!/bin/bash

#################################################
## script to call mosaic chromosomal alterations
#################################################
export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

pfx="folder_204212610005" # output prefix
sex="folder_204212610005.sex" # file with computed gender information (first column sample ID, second column gender: 1=male; 2=female)
crt="folder_204212610005.crt" # file with call rate information (first column sample ID, second column call rate)
lst="..." # file with list of samples to analyze for asymmetries (e.g. samples with 1p CN-LOH)
cnp="$HOME/res/cnp.grch38.bed" # file with list of regions to genotype in BED format
mhc_reg="chr6:27518932-33480487" # MHC region to skip
kir_reg="chr19:54071493-54992731" # KIR region to skip
rule="GRCh38"

dir="res" # directory where output files will be generated

bcftools +mocha --rules $rule --sex $sex --call-rate $crt --no-version --output-type b --output $dir/$pfx.mocha.bcf --variants ^$dir/$pfx.xcl.bcf --mosaic-calls $dir/$pfx.calls.tsv --genome-stats $dir/$pfx.stats.tsv --ucsc-bed $dir/$pfx.ucsc.bed --cnp $cnp --mhc $mhc_reg --kir $kir_reg $dir/$pfx.bcf && bcftools index -f $dir/$pfx.mocha.bcf


