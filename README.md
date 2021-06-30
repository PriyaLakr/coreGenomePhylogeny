# coreGenomePhylogeny 

Author: Priya Lakra

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

## 1. Installing all dependencies 
	
	`bash pl_install_depend.sh`
	
   You can check installation information in the file "install.info" 
   
## 2. Extracting core genome using get_homologues

	`bash pl_getcg.sh [options]`
	
  for help: run `bash pl_getcg.sh -h`
  
## ============ Filtering orthologous genes ========== 

### steps: 
### 1. Align genes 
### 2. Select genes containing less than 5% gaps in their multiple sequence alignments 

	 `bash pl_treegen.sh [options]`
	
   for help: run `bash pl_treegen.sh -h`
	
### 3. Create a super matrix using either the given script, your custom script and/or sequence matrix
	
	`bash pl_concat.sh`
	
   for help: run `bash pl_concat.sh -h`
	
### Notes: Another way is to create trees using individual gene files and concatenate individual gene trees to create a super tree. Read first if you really require this approach.  

## 3. Generating the phylogenomic tree

	`bash pl_treegen.sh [options]`
	
## 4. Visualize and edit tree newick file in your choice of tools


Reference data adapted from Lakra, P et al., 2021. 
