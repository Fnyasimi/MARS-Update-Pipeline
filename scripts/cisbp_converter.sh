#! /bin/bash

# Name: cisbp_converter.sh
# Author: Festus Nyasimi
# Date: 25 Feb 2020

# The script convert Cis-BP motif matrixes to transfac format then meme format

# Check arguments
if [[ $# -ne 3 ]]
then
	echo "Missing arguments"
	echo "Usage: cisbp_converter.sh <metadata.txt> <matrix folder> <output.meme>"
	exit 1
fi

infile=$1 #Metadata file from Cis-BP
infolder=$2 # Folder containing the matrix file
outfile=$3 # name of the output file

#file info
# 4 name of matrix
# 7 name of Tf
# 8 name of species

[[ -f ids.txt ]] && rm ids.txt

# Extract metadata from information file
echo "Extracting metadata from text file"
awk -F " " 'NR>1 {if ($4 != ".") {print$4 "  " $7}}' ${infile} > ids.txt

# Convert to transfac like format
echo "Converting to transfac like format"
while read -r line
do 
	echo "NA  ${line}" >> cis-bp.transfac
	motif=${line%\ \ *}.txt
	#echo ${motif}

	[[ -f ${infolder}/${motif} ]] && cat ${infolder}/${motif} | sed 's/Pos/PO/g' >> cis-bp.transfac
	echo "//" >> cis-bp.transfac
	
done < ids.txt
# Convert to meme format
echo "Converting to meme format"
transfac2meme -use_name cis-bp.transfac > ${outfile}

# Clean up
rm ids.txt
rm cis-bp.transfac

echo "Successfully converted"


