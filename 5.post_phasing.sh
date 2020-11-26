#!/bin/bash

export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

pfx="folder_204212610005" # output prefix
dir="res" # directory where output files will be generated

## Extract chromosomes that do not require phasing
bcftools view --no-version -Ob -o $dir/$pfx.other.bcf $dir/$pfx.unphased.bcf -t ^$(seq -s, 1 22),X,$(seq -f chr%.0f -s, 1 22),chrX && bcftools index -f $dir/$pfx.other.bcf

## Concatenate eagle output into a single VCF file and add GC/CpG content information
bcftools concat --no-version -Ob -o $dir/$pfx.bcf $dir/$pfx.{chr{{1..22},X},other}.bcf && \
bcftools index -f $dir/$pfx.bcf



