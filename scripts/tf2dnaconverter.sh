#! /bin/bash

# Script name: tf2dnaconverter.sh
# Author: Festus Nyasimi
# Date: 02 Mar 2020

#Used to convert tf2dna motifs into meme format

# Check arguments
if [[ $# -ne 2 ]]
then
	echo "Missing arguments"
	echo "Usage: tf2dnaconverter.sh <matrix folder> <output.meme>"
	exit 1
fi

# Get the folder
indir=$1
outfile=$2

[[ -f tmp.txt ]] && rm tmp.txt
temp=tmp.txt

# Make a temporary file
echo "Converting to uniprobe format"
for file in $(ls ${indir})
do
	echo $(basename ${file} .mat) >> ${temp}
	#echo -e "\n"
	cat ${indir}/${file} >> ${temp}
	echo -e "\n" >> ${temp}
done

# Convert to meme format
echo "Converting to meme format"
uniprobe2meme ${temp} > ${outfile}

#clean up
rm ${temp}

echo "Feeling Great!!!"
