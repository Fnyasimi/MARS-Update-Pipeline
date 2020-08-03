#! /bin/bash

# Script Name: check_endedness.sh

# Author: Festus Nyasimi

# Date: 20 Dec 2019

# Description: Check if a file is single ended or paired ended

# Usage bash check_endedness.sh <SRA accesion> <links output>

if [ $# -ne 2 ]
then
        echo "You have to provide the accession and output file."
        exit 1
fi

# Assign the arguments
infile=$1
outfile=$2

mkdir -p links_tmp

# Search for sample info
while [ ! -f ${infile}_testfile.txt ]
do
	esearch -db sra -query ${infile} | efetch -format runinfo > ${infile}_testfile.txt
done

# Test the endedness
if grep -i -e "single" ${infile}_testfile.txt > ${infile}_dump.txt
then
	echo "single ended"
elif grep -i -e "paired" ${infile}_testfile.txt > ${infile}_dump.txt
then
	echo "paired ended"
fi

# Get the download links

#grep -o "https:\/\/[-a-z.]\+\/[a-z0-9]\+\/[-a-z0-9]\+\/[A-Z0-9]\+\/[A-Z0-9]\+\/[A-Z0-9]\+" testfile.txt > links.txt # substitute for SRR
if grep -o "https:\/\/[-a-z.]\+\/[a-z0-9]\+\/[a-z0-9]\+\/SRR\/[0-9]\+\/[A-Z0-9]\+" ${infile}_testfile.txt > ${infile}_links.txt
then
        true
elif grep -o "https:\/\/[-a-z.]\+\/[a-z0-9]\+\/[-a-z0-9]\+\/[A-Z0-9]\+\/[A-Z0-9]\+" ${infile}_testfile.txt > ${infile}_links.txt
then
        true
fi

# Get individual reads
while read -r line
do
	echo "${line##*/}"
done < ${infile}_links.txt

# Move links to one file for later download when doing the analysis
cat ${infile}_links.txt >> links_tmp/${outfile}.txt

# remove tmp files
rm ${infile}_testfile.txt
rm ${infile}_dump.txt
rm ${infile}_links.txt
