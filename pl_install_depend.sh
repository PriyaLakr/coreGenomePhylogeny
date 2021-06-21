#!/bin/bash

## Installing dependencies with conda 

conda create -n core_genome_phylo

conda activate core_genome_phylo

conda install -c bioconda mafft

conda install -c bioconda iqtree

conda deactivate 

echo "Dependencies installation complete!"
echo "Before starting the analysis, always run first: conda activate <enviornment_name> ; eg. conda activate core_genome_phylo"


