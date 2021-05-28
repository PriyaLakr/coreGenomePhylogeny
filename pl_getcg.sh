#!/bin/bash

## raw data is amino acid fasta files of genomic assemblies of organisms 
## need to install get_homologous
 																																																		##  ==== in development ====
 
help(){
				echo - e "========= Usage\n ========="
				echo -e "-i (infold)          Provide input directory path where amino acid fasta files are located\n"
				echo -e "-g (get_homo)        Specify 'y' to install get_homologous in your home directory\n"
				echo -e "-s (seq_sim)         Provide sequence similairty value. Default is 50\n"
				echo -e "-p (seq_iden)        Provide sequence identity value. Default is 50\n"
				echo -e "-t (num_threads)     Provide number of threads\n"  
				echo -e "-r (run_mode)        Provide rum mode for get_homologous. OMCL (m) or BBDH (default) or COG (g)\n"
				echo -e "-e (outfold)       		Path to the output folder\n"
				echo -e "-c (core_phylogeny)  Specify 'y' to start constructing tree. It will use the extracted core genes from get_homologouy\n"
		#		echo -e "-r (bowtie2_run_mode)   Provide run mode for bowtie2 alignment. Two options: local or  end-to-end \n"
			#	echo -e "-p (process_reads)      Specify 'y' to run processing function. It will process the output files and return idx stats\n"
		#		echo -e "-s (infile suffix)      Provide suffix of input file, i.e, fastq or fq\n"
	exit 1
}


while getopts "g:i:s:p:t:m:o:" opt; do
		case "opts" in
				g ) get_homo="$OPTARG" ;;
				i ) infold="$OPTARG" ;;
				s ) seq_sim="$OPTARG" ;;
				p ) seq_iden="$OPTARG" ;;
				t ) num_threads="$OPTARG" ;;
				m ) run_mode="$OPTARG" ;;
				o ) outfold="$OPTARG" ;;
				\?) help; exit
			esac
done
				
cd ~ # change to home directory
		# install get_homologous in your home directory; make sure you have internet connection to execute the download properly 
if [[ $get_homo == 'y' ]]; then
				git clone https://github.com/eead-csic-compbio/get_homologues.git
				cd get_homologues
				perl install.pl 
fi

if [ -z "$infold" ] | [ -z "$run_mode" ] | [ -z "$outfold" ]; then 
				help
fi


infold=$1 # folder containing input files either containing amino acid sequences or GenBank format

echo -e "\tExtracting core genome (orthologous genes) avoiding paralogous genes" 

## 
./get_homologues.pl -d $infold -e -S $seq_sim -C $seq_iden -n $num_threads -M $run_mode

## ============ Filtering orthologous genes ========== 

## steps: Align genes -> select genes less than 5% gaps in their multiple sequence alignment -> concatente them into a super matrix or use each gene to create a phylognetic tree and then combine all those tree into a super tree 

## ============ Align genes ========== 

cd $outfold
mkdir $aligned_out

echo -e "changed dir to ${outfold} input directory"

for i in *.faa; do mafft --auto --thread $num_threads ${i} > $aligned_out/${i}_aligned.fasta; done


## ============ Remove genes ========== 

cd $aligned_out

python gapped.py


## ============ Making tree ========== 

bin/iqtree -s orf_20noninter -spp orf_20noninter -bb 1000 -nt 3 -redo

## ..... ## 




