#!/bin/bash

## raw data is amino acid fasta files of genomic assemblies of organisms 
## extracting core genome (orthologous genes) avoiding paralogous genes 
## need to install get_homologous
 ##  ==== in development ====
if [[ $get_homo ]]; then
git clone https://github.com/eead-csic-compbio/get_homologues.git
cd get_homologues
perl install.pl 

infold=$1 # folder containing input files either containing amino acid sequences or GenBank format

echo -e "Identifying core genome....." 

./get_homologues.pl -d $infold -e -S $seq_sim -C $seq_iden -n $num_threads -M $run_mode
