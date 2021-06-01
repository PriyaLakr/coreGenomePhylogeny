
#!/bin/bash

## raw data is fasta files containing orthologous genes 
## need to install mafft


help(){
	echo -e "\n========= Usage =========\n"
	echo -e "-i (infold)          Provide input directory path. Same to the location of get_homologous output files\n"
	echo -e "-t (num_threads)     Provide number of threads\n"  
#	echo -e "-r (run_mode)        Provide rum mode for get_homologous. OMCL (m) or BBDH (default) or COG (g)\n"
	echo -e "-n (expName)         Name of the outfolder which contains get_homologous output\n"
	echo -e "-a (align)           Specify 'y' to align fasta files. It will use the extracted core genes from get_homologouy\n"
	echo -e "-c (core_phylogeny)  Specify 'y' to start constructing tree. It will use the extracted core genes from get_homologouy\n"
	echo -e "-s (suffix)          Suffix of the files"
	exit 1
}


while getopts "g:i:s:p:t:m:o:c:b:a:r:e:f:n:" opt; do
	case "$opt" in
		i ) infold="$OPTARG" ;;
	#	s ) seq_sim="$OPTARG" ;;
	#	p ) seq_iden="$OPTARG" ;;
		t ) num_threads="$OPTARG" ;;
	#	m ) run_mode="$OPTARG" ;;
		o ) outfold="$OPTARG" ;;
		c ) py_path="$OPTARG" ;;
		b ) py_suffix="$OPTARG" ;;
		a ) align="$OPTARG" ;;
		r ) removegaps="$OPTARG" ;;
		n ) expName="$OPTARG" ;;
		\?) help; exit 1 ;;
	esac
done


## usage: bash pl_treegen.sh -i ~/Desktop/practice/deinocoregen_homologues_output -t 6 -n murrayiDSM11303_f0_alltaxa_algOMCL_e1_C50_S50_ -o ~/Desktop/practice -a y
## ============ Filtering orthologous genes ========== 

## steps: Align genes -> select genes less than 5% gaps in their multiple sequence alignment -> concatente them into a super matrix or use each gene to create a phylognetic tree and then combine all those tree into a super tree 
## pre install mafft here ... 
## ============ Align genes ==========


if [[ "$align" == "y" ]]; then 
  
	mkdir -p $outfold/aligned_out
	cd $infold/"${expName}"

	echo -e "changed dir to ${outfold} input directory"

	for i in *.faa; do mafft --auto --thread $num_threads ${i} > $outfold/aligned_out/${i}_aligned.fasta 2>$outfold/aligned_out/mafft.log; done
fi

## ============ Remove genes ========== 

if [[ "$removegap" == "y" ]]; then
	cd $aligned_out
	python pl_cal_gap.py --path $py_path --suffix $py_suffix
fi


## ============ Making tree ========== 

#bin/iqtree -s orf_20noninter -spp orf_20noninter -bb 1000 -nt 3 -redo

## ..... ## 


