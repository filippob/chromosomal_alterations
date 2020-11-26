#!/bin/bash

export PATH="$HOME/bin:$PATH"
export BCFTOOLS_PLUGINS="$HOME/bin"

dir="covid_genotypes/intensity-data-ita/intensity-data-ita_Raw_data_Raw_data/"
output_dir="covid_genotypes/idat"

## get all .idat files and copy them in one single folder prior to conversion to vcf
mkdir -p "$output_dir/idat_files"
find $dir -type f -name "*.idat" -print0 | xargs -0 cp -t $output_dir/idat_files

