#!/bin/bash

export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

vcf="folder_204212610005.bcf" # input VCF file with phased GT, LRR, and BAF
pfx="folder_204212610005" # output prefix
map="$HOME/res/genetic_map_hg38_withX.txt.gz"
dup="$HOME/res/dup.grch38.bed.gz"
thr="2" # number of threads to use
crt="folder_204212610005.crt" # file with call rate information (first column sample ID, second column call rate)
sex="folder_204212610005.sex" # file with computed gender information (first column sample ID, second column gender: 1=male; 2=female)
dir="res" # directory where output files will be generated
kgp_pfx="$HOME/res/ALL.chr"
kgp_sfx="_GRCh38.genotypes.20170504"

mkdir -p $dir

for chr in {1..22} X; do
  eagle --geneticMapFile $map --outPrefix $dir/$pfx.chr$chr --numThreads $thr --vcfRef $kgp_pfx${chr}$kgp_sfx.bcf --vcfTarget $dir/$pfx.unphased.bcf \
    --vcfOutFormat b \
    --noImpMissing \
    --outputUnphased \
    --vcfExclude $dir/$pfx.xcl.bcf \
    --chrom $chr \
    --pbwtIters 3 && \
  bcftools index -f $dir/$pfx.chr$chr.bcf
done


