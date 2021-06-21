#!/bin/bash

## change directory to folder containing conserved genes
cd conserved_coregenes &&

## concatenate files
cat *.fasta > final.fasta

## remove unnecessary line breaks from the fasta file 
awk '/^>/ { print (NR==1 ? "" : RS) $0; next } { printf "%s", $0 } END { printf RS }' final.fasta > final.ed.fasta

## extract names
grep ">" 1.fasta | cut -f1 -d " " | cut -f1 -d "." | cut -f2 -d ">" > samplenames.txt 

## extract individual fasta
mkdir -p out/outnew/outnew2/outnew3
while read line; do grep -A1 --no-group-separator "$line" final.ed.fasta > out/"$line".fasta; done < samplenames.txt

## remove all header lines and paste
for i in *.fasta; do grep -v ">" $i > ./outnew/$i.edited.fasta; done
for i in *.fasta; do paste -d "-" -s $i > ./outnew2/$i.final; done 

## re add > header and then concatenate
for i in *.fasta.final; do names=(${i//./ }); awk -v n="$names" 'NR==1{print ">"n"\n"$0}' $i > ./outnew3/$i.final.fasta; done
cat *.final.fasta > supermatrix.fasta

