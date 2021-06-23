#!/bin/bash

## Installing dependencies with conda 

conda create -n core_genome_phylo | tee -a install.info

source activate core_genome_phylo && echo "Env activated" | tee -a  install.info

conda install -c bioconda mafft | tee -a install.info 

conda install -c bioconda iqtree | tee -a install.info

conda deactivate 

echo -e "\nDependencies installation complete!" 
echo -e "\nBefore starting the analysis, always run first: conda activate <enviornment_name> ; eg. conda activate core_genome_phylo\n"


