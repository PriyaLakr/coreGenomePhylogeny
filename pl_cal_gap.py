
import argparse
from Bio import AlignIO
import pandas as pd
import os


def cal_gaps_align(file_path,in_format):
    
    total_len = []
    without_gap_len = []
    gaps_per = []
    name = []
    
    os.chdir(file_path)
    
    for file in os.listdir():
        if file.endswith(in_format):
            alignment = AlignIO.read(file, "fasta")
            name.append(file)

            nogap_alignment = []
    
            for i in range(len(alignment[0])):
                if '-' not in alignment[:,i]:
                    nogap_alignment.append(i)
            
            gaps=(len(alignment[0])-len(nogap_alignment))/len(alignment[0]) * 100
     
            total_len.append(len(alignment[0]))
            without_gap_len.append(len(nogap_alignment))
            gaps_per.append(gaps)
        
    results = pd.DataFrame({"name":pd.Series(name),"total_len":pd.Series(total_len),"without_gap_len":pd.Series(without_gap_len),"gaps_per":pd.Series(gaps_per)})
    results.to_csv("result.csv") 


if __name__ == "__main__":

	parser = argparse.ArgumentParser(description = "This script calculates gaps in the multiple sequence alignment")
	parser.add_argument("--path", type=str, help="Path of the directory where alignment files are stored")
	parser.add_argument("--suffix", type=str, help="Suffix of the alignment files")
	
	print("Input files should be aligned first")
	
	args = parser.parse_args()
	file_path = args.path
	in_format = args.suffix

    	cal_gaps_align(file_path,in_format)


