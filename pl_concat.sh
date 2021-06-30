#!/bin/bash

help(){
	echo -e "\n========= Usage =========\n"
	echo -e "-d (conserved_coregenes_dir)       Provide input directory path where conserved coregenes are located\n"
	echo -e "-s (suffix)                        Provide suffix of the files\n"  
	echo -e "-n (samplenames)                   Provide file containing samplenames (i.e. names of the organisms)\n\n\tExample:\n \n\tfasta file1: \
												\n\t>organism1.1.1\n\tMPGIAIIGAQWGDEGKGKIVDFLAPEAKFVARYQGGANAGHTVNAKGKTFKLNLLPSGVL \
												\n\t>organism2.2.1\n\tHEQTVSVLGDGMVIDPEKFLAERQNLLDGGLTPELRISERAHLVLPHHKYVDGRKDFVGL\n \
												\n\tfasta file2: \
												\n\t>organism1.2.1\n\tMPGIAIIGAQWGDEGKGKITDFLAPQANYVVRYQGGANAGHTVTAKGQTFKLNLLPSGVLL \
												\n\t>organism2.2.1\n\tTGRGIGPAYADRARRVGIRFGDLSDLSVLRERVERLLEAKPNSTAAAGWGSVSDALGYLLG\n \
												\n\tsamplenames: \
												\n\torganism1 \
												\n\torganism2\n "
	echo -e "-f (reference_file)                Provide name of one of the files in conserved coregenes folder\n"
	echo -e "\nbash pl_concat.sh -d /Users/priyalakra/Desktop/dwdpractice/conserved_coregenes -s fasta -f 89706_murrayi_DSM11303_peg.858.faa_aligned.fasta -o /Users/priyalakra/Desktop\n"
	exit 1
}


while getopts "d:s:n:f:o::h" opt; do
	case "$opt" in
		d ) conserved_coregenes_dir="$OPTARG" ;;
		s ) suffix="$OPTARG" ;;
		n ) samplenames="$OPTARG" ;;
		f ) reference_file="$OPTARG" ;;
		o ) outfold="$OPTARG" ;;
		h ) help; exit 1 ;;
	esac
done
		

## change directory to folder containing conserved genes and concatenate files
mkdir -p "$conserved_coregenes_dir"/tempfiles  &&  \
cd "$conserved_coregenes_dir"  &&  \
cat *.$suffix > "$conserved_coregenes_dir"/tempfiles/final.fa && \
cd "$conserved_coregenes_dir"/tempfiles  &&  \
echo "dir changed to "$PWD" "


## remove unnecessary line breaks from the fasta file 
awk '/^>/ { print (NR==1 ? "" : RS) $0; next } { printf "%s", $0 } END { printf RS }' final.fa > final.ed.fa


mkdir -p out1/out2/out3/out4


## extract names and individual fasta # needs better optimization 
if [[ -z "$samplenames" ]]; then
	grep ">" ../"$reference_file" | cut -f1 -d " " | cut -f1 -d "." | cut -f2 -d ">" > samplenames 
	while read line; do ggrep -A1 --no-group-separator "$line" final.ed.fa > out1/"$line".fasta; done < samplenames
fi


if [[ "$samplenames" ]]; then
	while read line; do ggrep -A1 --no-group-separator "$line" final.ed.fa > out1/"$line".fasta; done < "$samplenames"
fi


## remove all header lines and paste
cd out1 && for i in *.fasta; do grep -v ">" $i > out2/$i.edited; done 
cd out2 && for i in *.edited; do paste -d "-" -s $i > out3/$i.edit; done 


## re add > header and then concatenate
cd out3 && for i in *.edit; do names=(${i//./ }); awk -v n="$names" 'NR==1{print ">"n"\n"$0}' $i > out4/$i.final.fasta; done 
cd out4 && cat *.fasta > "$outfold"/supermatrix.fasta


echo -e "\n\tSuper matrix fasta file is located in "$outfold" folder. Use this file for further analysis\n"
