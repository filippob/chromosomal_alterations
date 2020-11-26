#!/bin/bash

export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

vcf="folder_204212610005.bcf" # input VCF file with phased GT, LRR, and BAF
pfx="folder_204212610005" # output prefix
dup="$HOME/res/dup.grch38.bed.gz"
thr="2" # number of threads to use
crt="folder_204212610005.crt" # file with call rate information (first column sample ID, second column call rate)
sex="folder_204212610005.sex" # file with computed gender information (first column sample ID, second column gender: 1=male; 2=female)
dir="res" # directory where output files will be generated
mkdir -p $dir

### 1) generate a minimal binary VCF
bcftools annotate --no-version -Ob -o $dir/$pfx.unphased.bcf $vcf -x ID,QUAL,^INFO/ALLELE_A,^INFO/ALLELE_B,^INFO/GC,^FMT/GT,^FMT/BAF,^FMT/LRR && bcftools index -f $dir/$pfx.unphased.bcf

# bcftools view --no-version -h $vcf | sed 's/^\(##FORMAT=<ID=AD,Number=\)\./\1R/' | bcftools reheader -h /dev/stdin $vcf | \
#  bcftools filter --no-version -Ou -e "FMT/DP<10 | FMT/GQ<20" --set-GT . | \
#  bcftools annotate --no-version -Ou -x ID,QUAL,^INFO/GC,^FMT/GT,^FMT/AD | \
#  bcftools norm --no-version -Ou -m -any --keep-sum AD | \
#  bcftools norm --no-version -Ob -o $dir/$pfx.unphased.bcf -f $ref && \
#  bcftools index $dir/$pfx.unphased.bcf


### 2) generate list of variants to be removed

awk -F"\t" '$2<.97 {print $1}' $crt > samples_xcl_list.txt; \
echo '##INFO=<ID=JK,Number=1,Type=Float,Description="Jukes Cantor">' | \
  bcftools annotate --no-version -Ou -a $dup -c CHROM,FROM,TO,JK -h /dev/stdin $dir/$pfx.unphased.bcf | \
  bcftools view --no-version -Ou -S ^samples_xcl_list.txt | \
  bcftools +fill-tags --no-version -Ou -t ^Y,MT,chrY,chrM -- -t ExcHet,F_MISSING | \
  bcftools +mochatools --no-version -Ou -- -x $sex -G | \
  bcftools annotate --no-version -Ob -o $dir/$pfx.xcl.bcf \
    -i 'FILTER!="." && FILTER!="PASS" || INFO/JK<.02 || INFO/ExcHet<1e-6 || INFO/F_MISSING>1-.97 ||
    INFO/AC_Sex_Test<1e-6 && CHROM!="X" && CHROM!="chrX" && CHROM!="Y" && CHROM!="chrY"' \
    -x ^INFO/JK,^INFO/ExcHet,^INFO/F_MISSING,^INFO/AC_Sex_Test && \
  bcftools index -f $dir/$pfx.xcl.bcf;
/bin/rm samples_xcl_list.txt

