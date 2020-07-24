#!/usr/bin/env bash
set -e

# Author: Caleb Kibet
# Modified by: Festus Nyasimi
# Date: 17 Apr 2020

# This script is used to extract positive and negative sequence from peak files
# It also uses helper scripts:
#	1. bed-widen
#	2. extractnegative.py
#	3. removemasked.py

if [[ $# -ne 4 ]]
then
	echo "USAGE: bed2seq.sh <bed file> <ref genome> <size> <outname>"
	exit 1
fi

get_fasta(){
	
	#check the size of the input sequence of reduce the processing time for large files (assumes sorted file)
	lenbed=$(wc -l ${bed_in} | cut -f1 -d " ")
	lenuse=$((${lenbed}/10))
	if [[ "${lenbed}" -gt 5000 ]]
	then
		cut -f 1,2,3 ${bed_in} | head -${lenuse} | bed-widen -width ${len} > ${outfile}.bed
	else
		cut -f 1,2,3 ${bed_in} | bed-widen -width ${len} > ${outfile}.bed
	fi

    	#Extract negative bed file downstream
    	python extractnegative.py ${outfile}.bed ${outfile}.negbed 500

	# Use bedtools to extract fasta sequences
	fastaFromBed -tab -fi ${hg} -bed ${outfile}.bed -fo ${outfile}.fas
	fastaFromBed -tab -fi ${hg} -bed ${outfile}.negbed -fo ${outfile}.negfas

    	# Prepare the fasta sequences pos
	cut -f 7 ${bed_in} >/tmp/f1 
	cut -f 1 ${outfile}.fas >/tmp/f2
	cut -f 2 ${outfile}.fas >/tmp/f3
	paste /tmp/f2 /tmp/f1 /tmp/f3  >${outfile}.fas

	# prepare the negative sequences neg
	cut -f 7 ${bed_in} >/tmp/f1
	cut -f 1 ${outfile}.negfas >/tmp/f2
	cut -f 2 ${outfile}.negfas >/tmp/f3
	paste /tmp/f2 /tmp/f1 /tmp/f3  > ${outfile}.negfas

	# Remove masked sequences
	python removemasked.py ${outfile}.fas ${outfile}.fa
	python removemasked.py ${outfile}.negfas ${outfile}.negfa

    	# use the length of the available sequences to determine the size of test and negative sequences
    	lenfa=$(wc -l ${outfile}.fa | cut -f1 -d " ")
    	len_negfa=$(wc -l ${outfile}.negfa | cut -f1 -d " ")
    	lenuse=$(($lenbed/20))

    	if [[ ${lenuse} -gt 500 ]]
        then
            lenuse=${lenuse}
     	else
            lenuse=500
     	fi


    	if [[ "${lenfa}" -gt ${lenuse} ]] &&  [[ "${len_negfa}" -gt ${lenuse} ]]
        then
		cutoff=${lenuse}
    	elif [[ "${lenfa}" -lt "${len_negfa}" ]]
        then
		cutoff=${lenfa}
     	else
            	cutoff=${len_negfa}
    	fi

    	head -${cutoff} ${outfile}.fa >${outfile}.posneg
	head -${cutoff} ${outfile}.negfa >>${outfile}.posneg

    	#clean up the temporary files
	rm ${outfile}.bed
	rm ${outfile}.neg*
	rm ${outfile}.fa*
	rm /tmp/f*
}

bed_in=$1 # Input bed file
hg=$2 #Reference genome
len=$3 #{:-100} #Use a default of 100 if not provided
outfile=$4 #Output name

get_fasta
