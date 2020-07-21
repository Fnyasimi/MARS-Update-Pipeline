#! /bin/bash

# Name: converter.sh
# Author: Festus Nyasimi
# Date: 25 feb 2020

# The script converts motifs in cm format into meme format
# Used for data from Wolf's lab and Fly vector lab

if [[ $# -ne 1 ]]
then
	echo "Missing an argument"
	echo "Usage: converter.sh <input>"
	exit 1
fi

infile=$1
outfile=${infile%.*}.meme
echo "Converting very fast"

[[ -d temp ]] && rm -r temp
mkdir -p temp

# Break the file into individual CM files
while read -r line
do
	if [[ ${line:0:1} == ">" ]]
	then 
		name=${line:1}.cm
	fi

	[[ ! -z "${name}" ]] && echo ${line} >> temp/${name}

done < ${infile}

for file in $(ls temp)
do
	#echo ${file}
	# Remove first line header
	sed -i 1d temp/${file}
done

# CM converter
jaspar2meme -cm temp > ${outfile}

# Clean up
rm -r temp

echo "Succeessfully converted to MEME format"
echo "Output written to ${outfile}"
