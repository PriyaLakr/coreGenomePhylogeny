#!/bin/bash

present_dir="$PWD"

## install get_homologous in your home directory; make sure you have internet connection to execute the download properly 
get_homo(){
	git clone https://github.com/eead-csic-compbio/get_homologues.git 
	cd get_homologues
	perl install.pl && \
	echo -e "Get homologoues software downloaded in your home directory: "$PWD" " 
}

## Installing dependencies with conda 

conda create -n core_genome_phylo | tee -a install.info

source activate core_genome_phylo && echo -e "\nEnv activated\n" | tee -a install.info

conda install -c bioconda mafft | tee -a install.info 

conda install -c bioconda iqtree | tee -a install.info

conda deactivate && echo -e "\nEnv deactivated\n" | tee -a install.info 

cd ~
get_homo 
cd "$present_dir"

echo -e "\nDependencies installation complete!" | tee -a install.info 
echo -e "\nBefore starting the analysis, always run first: conda activate <enviornment_name> ; eg. conda activate core_genome_phylo\n" | tee -a install.info 




