#!/bin/bash

## raw data is amino acid fasta files of genomic assemblies of organisms 
## need to install get_homologous
 																																																		##  ==== in development ====
 
help(){
	echo -e "\n========= Usage =========\n"
	echo -e "-i (infold)          Provide input directory path where amino acid fasta files are located\n"
	echo -e "-g (get_homo)        Specify 'y' to install get_homologous in your home directory\n"
	echo -e "-s (seq_sim)         Provide sequence similairty value. If unsure on what to choose, write 50\n"
	echo -e "-p (seq_iden)        Provide sequence identity value. If unsure on what to choose, write 50\n"
	echo -e "-t (num_threads)     Provide number of threads\n"  
	echo -e "-r (run_mode)        Provide rum mode for get_homologous. OMCL (m) or BBDH (default) or COG (g)\n"
	echo -e "-o (outfold)         Path to the output folder\n"
	exit 1
}


while getopts "g:i:s:p:t:m:o:c:b:a:r:e:f:" opt; do
	case "$opt" in
		g ) get_homo="$OPTARG" ;;
		i ) infold="$OPTARG" ;;
		s ) seq_sim="$OPTARG" ;;
		p ) seq_iden="$OPTARG" ;;
		t ) num_threads="$OPTARG" ;;
		m ) run_mode="$OPTARG" ;;
		o ) outfold="$OPTARG" ;;
		e ) extract="$OPTARG" ;;
		\?) help; exit 1 ;;
	esac
done
				
cd ~/Desktop/practice ## change to home directory mkdir -p ~/coregenomePhylo cd ~/coregenomePhylo
## install get_homologous in your home directory; make sure you have internet connection to execute the download properly 
if [[ "$get_homo" == "y" ]]; then
	git clone https://github.com/eead-csic-compbio/get_homologues.git
	cd get_homologues
	perl install.pl 
	echo -e "Get homologoues software downloaded in your home directory with name: coregenomePhylo" 
fi

if [[ -z "${infold}"  ||  -z "${run_mode}" ||  -z "${outfold}" ||  -z "$seq_sim"  ||  -z "$seq_iden" ]]; then 
	help
fi

## find name of the get_homologous directory :P name=dir; default name is get_homologous
name=get_homologues

if [[ "$extract" == "y" &&  "$num_threads" ]]; then
	## folder containing input files either containing amino acid sequences or GenBank format
	echo -e "\tExtracting core genome (orthologous genes) avoiding paralogous genes" 
	./$name/get_homologues.pl -d $infold -e -S $seq_sim -C $seq_iden -n $num_threads -M $run_mode -o $outfold > $outfold/get_homologues_log.out; #storing output to a different location $outfold
fi

if [[ "$extract" == "y" &&  -z "$num_threads" ]]; then
## folder containing input files either containing amino acid sequences or GenBank format
	echo -e "\tExtracting core genome (orthologous genes) avoiding paralogous genes" 
	./$name/get_homologues.pl -d $infold -e -S $seq_sim -C $seq_iden -n 3 -M $run_mode -o $outfold > $outfold/get_homologues_log.out; #storing output to a different location $outfold
fi






