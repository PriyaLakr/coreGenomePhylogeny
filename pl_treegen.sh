#!/bin/bash

## raw data is fasta files containing orthologous genes 
## need to install mafft


help(){
	echo -e "\n========= Usage =========\n"
	echo -e "bash pl_treegen.sh -i ~/Desktop/practice -n deinoOMCL -o ~/Desktop/practice -a y -r y -c y -p 6"
	echo -e "-i (infold)          Provide input directory path. Same to the location of get_homologous output files\n"
	echo -e "-p (num_threads)     Provide number of threads\n"  
	echo -e "-o (outfold)         Provide output directory path. User defined\n"
	echo -e "-a (align)           Specify 'y' to align fasta files. It will use the extracted core genes from get_homologouy\n"
	echo -e "-c (countgaps)       Specify 'y' to start constructing tree. It will use the extracted core genes from get_homologouy\n" 
	echo -e "-r (removegaps)      Specify 'y' to remove gaps from the multiple sequence alignment files.\n"
	echo -e "-n (expName)         Name of the outfolder which contains get_homologous output faa files\n"
	echo -e "-t (core_phylogeny)  Specify 'y' to start constructing tree. It will use the extracted core genes from get_homologouy\n"                
	echo -e "-b (bootstrap)       Provide the bootstrap value for the tree\n"
	echo -e "-m (approach)        Tree approach. Choose between 'supertree' and 'supergene' approach"
	exit 1
}


while getopts "i:p:o:a:c:r:n:t:b:m:" opt; do
	case "$opt" in
		i ) infold="$OPTARG" ;;
		p ) num_threads="$OPTARG" ;;
		o ) outfold="$OPTARG" ;;
		a ) align="$OPTARG" ;;
		c ) countgaps="$OPTARG" ;;
		r ) removegaps="$OPTARG" ;;
		n ) expName="$OPTARG" ;;
		t ) tree="$OPTARG" ;;
		b ) bootstrap="$OPTARG" ;;
		m ) approach="$OPTARG" ;;
		\?) help; exit 1 ;;
	esac
done

echo
echo -e "Please provide absolute path" 
echo " Process start at "$(date +"%T")" with parameters: align "$align" ; removegaps "$removegaps" ; tree "$tree" ; approach "$approach"; num_threads "$num_threads" " | tee -a $outfold/run.info
echo

## usage: bash pl_treegen.sh -i ~/Desktop/practice/deinocoregen_homologues_output -t 6 -n murrayiDSM11303_f0_alltaxa_algOMCL_e1_C50_S50_ -o ~/Desktop/practice -a y
## ============ Filtering orthologous genes ========== 

## steps: Align genes -> select genes less than 5% gaps in their multiple sequence alignment -> concatente them into a super matrix or use each gene to create a phylognetic tree and then combine all those tree into a super tree 
## pre install mafft here ... 

## ============ Align genes ==========
if [[ "$align" == "y" ]]; then 

    mkdir -p $outfold/aligned_out && \
    cd "$infold"/"$expName" && \
    echo -e "changed dir to "$infold"/"$expName" input directory" | tee -a $outfold/run.info && \
    for i in *.faa; do mafft --auto --thread $num_threads ${i} > $outfold/aligned_out/${i}_aligned.fasta 2>>$outfold/mafft.log; done
    echo -e "Aligned all fasta files using MAFFT" | tee -a $outfold/run.info

fi


## ============ Remove genes ========== 
## Make a scripts folder in you home directory and save pl_cal_gap.py in that folder. Or make sure edit the location of the pl_cal_gap.py script in line 61
if [[ "$countgaps" == "y" ]]; then	
	
	python ~/Desktop/pl_cal_gap.py --path $outfold/aligned_out --suffix fasta && \
	mv $outfold/aligned_out/result.csv $outfold && \
	echo "Done counting gaps" | tee -a $outfold/run.info
	
fi


if [[ "$removegaps" == "y" ]]; then
	
	mkdir -p $outfold/conserved_coregenes && \
	sort -t "," -n -k 5 $outfold/result.csv | awk -F "," '{ if ($5 < 5) print $2 }' > $outfold/coregeneNames.txt && \
    while read i; do cp $outfold/aligned_out/${i} $outfold/conserved_coregenes; done < $outfold/coregeneNames.txt && \
	echo "Done removing gaps" | tee -a $outfold/run.info
	
fi


## ============ Making tree ========== 
## requires conda installation of IQtree; version 2.0 highlight: Input alignment (-s option) or partition (-p) can be a directory of alignment files
if [[ "$tree" == "y" || "$approach" == "supermatrix" ]]; then
	
	## supermatrix approach
	iqtree2 -p $outfold/conserved_coregenes -B $bootstrap -T $num_threads --prefix $outfold/concat
	echo "Done making tree using supermatrix approach" | tee -a $outfold/run.info
	
fi


if [[ "$tree" == "y" || "$approach" == "supertree" ]]; then

	## supertree approach
	iqtree2 -S $outfold/conserved_coregenes -B $bootstrap -T $num_threads --prefix $outfold/loci
	echo "Done making tree using supergene approach" | tee -a $outfold/run.info
	
fi

echo "Process ended at: "$(date +"%T")" " | tee -a $outfold/run.info

