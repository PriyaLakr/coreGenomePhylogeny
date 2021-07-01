# coreGenomePhylogeny 

Author: Priya Lakra

# Description

This is the script for constructing core genome phylogeny for taxonomic purposes. It involves extraction of core genome from the genome assemblies of closely and/or distantly related species, and employing this core genome for construction of phylogenomic tree. 

# Requirements: 

### get_homologues 

[get_homologues](http://eead-csic-compbio.github.io/get_homologues/manual/) package is required for extracting core and pan genomes among different species. 

### MAFFT 

[MAFFT](https://mafft.cbrc.jp/alignment/software/source.html) is used for generating multiple sequence alignment.

### Sequence matrix (optional)

For concatenating alignments into a super matrix, one can use 
1. [Sequence matrix](http://www.ggvaidya.com/taxondna/) 
2. Custom scripts

### Phylogeny tools

[IQtree](http://www.iqtree.org) and [MEGA X](https://www.megasoftware.net) can be used for generating phylogenomic trees. 

### Tree visualization tools

[iTOL](https://itol.embl.de) is used for tree visualization and editing. [Figtree](http://tree.bio.ed.ac.uk/software/figtree/) can also be used. 


# Steps:

## 1. Clone the repository with

	`git clone https://github.com/PriyaLakr/coreGenomePhylogeny.git` 
	`cd PATH/TO/coreGenomePhylogeny`

## 2. Installing all dependencies 
	
	`bash pl_install_depend.sh`
	
   You can check installation information in the file "install.info" 
   
## 3. Extracting core genome using get_homologues

	`bash pl_getcg.sh [options]`
	
  for help: run `bash pl_getcg.sh -h`
  
## 4. Filtering orthologous genes 

### Steps: 
### 4.1. Align genes 
### 4.2. Select genes containing less than 5% gaps in their multiple sequence alignments 

	 `bash pl_treegen.sh [options]`
	
   for help: run `bash pl_treegen.sh -h`
	
### 4.3. Create a super matrix using either the given script, your custom script and/or sequence matrix
	
	`bash pl_concat.sh`
	
   for help: run `bash pl_concat.sh -h`
	
### Notes: Another way is to create trees using individual gene files and concatenate individual gene trees to create a super tree. Read first if you really require this approach.  

## 5. Generating the phylogenomic tree

	`bash pl_treegen.sh [options]`
	
## 6. Visualize and edit tree newick file in your choice of tools


Reference data adapted from Lakra, P et al., 2021.
