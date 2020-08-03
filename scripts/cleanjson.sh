#! /usr/bin/env bash
set -e

# Script name: Cleanhson.sh

# Author: Festus Nyasimi

# Date: 14-Apr-2020

# Description: This script is used to remove json files with no data and those with epigenetic targets

# Check all arguments are provided
if [ $# -ne 4 ]
then
        echo -e "Provide all the arguments.\n"
	echo -e "USAGE: cleanjson.sh <org> <metadata.tsv> <json dir> <links dir>\n"
        exit 1
fi

org=$1 #dm
intsv=$2 #dm-metadata.tsv
indir=$3 #dm/Jsonfiles
links=$4 #dm/links_tmp

name=$(basename ${intsv} .tsv)

# Make directories
mkdir -p ${org}/No-data-json
mkdir -p ${org}/Epigenetic-targets

nodata=${org}/No-data-json
epitarget=${org}/Epigenetic-targets

# Remove json files with no reads data
count=0
for file in $(grep -L "chip.fastqs_rep1_R1" ${indir}/*)
do
	mv ${file} ${nodata}
	(( count ++ ))
done
echo "Files without data moved to ${nodata}"

# Remove these files from the metadata
[[ -f remove.txt ]] && rm remove.txt
for file in $(ls ${nodata})
do
	echo $(basename ${file} .json) >> remove.txt
done 

# Remove the above files from the metadata file
echo "Removing files with no data from metadata.tsv..."

if grep -v -f remove.txt ${intsv} > tmp.tsv
then
	echo "Removed files with no data"
elif grep -E -v -f remove.txt ${intsv} > tmp.tsv
then
	echo "Removed files with no data"
else
	echo "Files not removed try modifying grep command or use egrep"
fi

# Create a function to remove epigenetic targets
getepi(){
        
        #set the inputfile
        infile=$1
        name=$2

        #Get all the epigenetic targets
        echo "Searching for epigenetics targets..."
        awk -F "\t" '{print$2}' ${infile} | grep "\(\b\(\([Aa][Nn][Tt][Ii]\|[Hh][Ii][Ss][Tt][Oo][Nn][Ee]\)[-_ ]\)\?[Hh][0-9][a-Z][.0-Z]\{,8\}\+\|^[Hh][0-9]$\)\|[Hh][Ii][Ss][Tt][Oo][Nn][Ee][-_ ][Hh][0-9]\|\b\([Aa]nti[- ]\)\?\(u\|[Uu]b\|m\|y\|γ\|g\)\?H[A0-9][^ND]\|\bH[A0-9]\b\|histone[-_ ]\?H[A0-9]\|gammaH[0-9]A[A-Z]\|macroH2A\|\bK[0-9]\{1,2\}[a-zA-Z]\+[0-9a-z]\+\|\bK27\b\|antiH3K9me3" | sort -u > festus.txt
        
        # Loop through the epi targets to get unique identifiers in column 6
        echo "Extracting epigenetic targets..."
        while read -r line
        do
                awk -F "\t" '$2=='"\"${line}\""' {print$6}' ${infile} >> ${name}-epigenetics.txt
        done < festus.txt

        # Write out a file with no epigenetics
        echo "Writing a clean metadata file to ${name}-cleaned.tsv"
        grep -v -f ${name}-epigenetics.txt ${infile} > ${name}-cleaned.tsv

        [[ -f festus.txt ]] && rm festus.txt

        echo "Cleaning complete!!!"
}

getepi tmp.tsv ${name}

# Move the epigenetic files
echo "Moving json files containing epigenetic targets"
while read -r line
do
	[[ -f ${indir}/${line}.json ]] && mv ${indir}/${line}.json ${epitarget}
done < ${name}-epigenetics.txt

# Stats
echo "$(ls ${indir} | wc -l) cleaned Json files"
echo "$(ls ${epitarget} | wc -l) epigenetics Json files"
echo "$(ls ${nodata} | wc -l) no read data Json files"

# Clean up
[[ -f remove.txt ]] && rm remove.txt
[[ -f tmp.tsv ]] && rm tmp.tsv
