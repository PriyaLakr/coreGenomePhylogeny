#!/bin/bash

## raw data is amino acid fasta files of genomic assemblies of organisms 

 
help(){
	echo -e "\n========= Usage =========\n"
	echo -e "-i (infold)          Provide input directory path where amino acid fasta files are located\n"
	echo -e "-g (get_homo)        Provide path where get_homologous is downloaded. Or Add path to the PATH environment variable\n"
	echo -e "-s (seq_sim)         Provide sequence similairty value. If unsure on what to choose, write 50\n"
	echo -e "-p (seq_iden)        Provide sequence identity value. If unsure on what to choose, write 50\n"
	echo -e "-t (num_threads)     Provide number of threads\n"  
	echo -e "-m (run_mode)        Provide rum mode for get_homologous. OMCL (m) or BBDH (default) or COG (g)\n"
	echo -e "-d (outfold)         Path to the output folder\n"
	exit 1
}


while getopts "g:i:s:p:t:m:d:e::h" opt; do
	case "$opt" in
		g ) get_homo="$OPTARG" ;;
		i ) infold="$OPTARG" ;;
		s ) seq_sim="$OPTARG" ;;
		p ) seq_iden="$OPTARG" ;;
		t ) num_threads="$OPTARG" ;;
		m ) run_mode="$OPTARG" ;;
		d ) outfold="$OPTARG" ;;
		h ) help; exit 1 ;;
	esac
done
				

if [[ -z "${infold}"  ||  -z "${run_mode}" ||  -z "${outfold}" ]]; then 
	help
fi


name=get_homologues
## to store output files to $outfold location 
cd "$outfold"

if [[ "$seq_sim"  &&  "$seq_iden" ]]; then
	## folder containing input files either containing amino acid sequences or GenBank format
	echo -e "\tExtracting core genome (orthologous genes) avoiding paralogous genes" 
	"$get_homo"/$name/get_homologues.pl -d $infold -e -S $seq_sim -C $seq_iden -n $num_threads -M $run_mode -o $outfold > $outfold/get_homologues_log.out;
fi


if [[ -z "$seq_sim"  &&  -z "$seq_iden"  &&  -z "$num_threads" ]]; then
## folder containing input files either containing amino acid sequences or GenBank format
	echo -e "\tExtracting core genome (orthologous genes) avoiding paralogous genes" 
	"$get_homo"/$name/get_homologues.pl -d $infold -e -S 50 -C 50 -n 3 -M $run_mode -o $outfold > $outfold/get_homologues_log.out; 
fi
