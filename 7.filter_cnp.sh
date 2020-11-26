#!/bin/bash

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

awk -F "\t" 'NR==FNR && FNR==1 {for (i=1; i<=NF; i++) f[$i] = i}
  NR==FNR && FNR>1 {sample_id=$(f["sample_id"]); call_rate=$(f["call_rate"]); baf_auto=$(f["baf_auto"])}
  NR==FNR && FNR>1 && (call_rate<.97 || baf_auto>.03) {xcl[sample_id]++}
  NR>FNR && FNR==1 {for (i=1; i<=NF; i++) g[$i] = i; print}
  NR>FNR && FNR>1 {sample_id=$(g["sample_id"]); len=$(g["length"]); p_arm=$(g["p_arm"]); q_arm=$(g["q_arm"]);
    bdev=$(g["bdev"]); rel_cov=$(g["rel_cov"]); lod_baf_phase=$(g["lod_baf_phase"]); type=$(g["type"]);
    if (lod_baf_phase=="nan") lod_baf_phase=0}
  NR>FNR && FNR>1 && !(sample_id in xcl) && rel_cov>0.5 && type!~"^CNP" &&
    ( len>5e6 + 5e6 * (p_arm!="N" && q_arm!="N") ||
      len>5e5 && bdev<1/10 && rel_cov<2.5 && lod_baf_phase>10 ||
      rel_cov<2.1 && lod_baf_phase>10 )' $pfx.stats.tsv $pfx.calls.tsv > $pfx.calls.filtered.tsv

awk 'NR==FNR {x[$1"_"$3"_"$4"_"$5]++} NR>FNR && ($0~"^track" || $4"_"$1"_"$2"_"$3 in x)' \
  $pfx.calls.filtered.tsv $pfx.ucsc.bed > $pfx.ucsc.filtered.bed

      
