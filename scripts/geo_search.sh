#! /bin/bash

# Script name: geo_search

# Author: Festus Nyasimi

# Data: 19 Dec 2019

# The script is used to search GEO database for Chip-Seq data

if [[ $# -ne 1 ]]
then
        echo "Missing one argument"
	echo 'Usage: geo_search.sh "Organism name"'
        exit 1
fi

org=$1

# Get the number of records
total=`esearch -db gds -query "genome binding/occupancy profiling by high throughput sequencing[DataSet Type] AND ${org}[Organism] AND ChIP-Seq"  | efetch -format uid | wc -l`

#Get the ftp links of the datasets

esearch -db gds -query "genome binding/occupancy profiling by high throughput sequencing[DataSet Type] AND ${org}[Organism] AND ChIP-Seq"  | efetch -format docsum | xtract -pattern DocumentSummary -element FTPLink > ftp_links.txt

echo "FTP links saved to ftp_links.txt"

# Make an empty directory for the soft files
[[ -d Series_soft_files ]] && rm -rf Series_soft_files
[[ -f undownloaded_files.txt ]] && rm undownloaded_files.txt
mkdir -p Series_soft_files

inputfile=ftp_links.txt
while read -r line
do
	line1=${line%/}
	line2=${line1##*/}
	ftp_link="http:${line#*:}soft/${line2}_family.soft.gz"
	echo "Downloading ${line2} series soft file"
	cd Series_soft_files
	wget ${ftp_link}
	filename="${line2}_family.soft.gz"
	if [[ -f "${filename}" ]];
	then
		gunzip ${filename}
	else
		echo ${ftp_link} >> ../undownloaded_files.txt
	fi
	cd ..

done < ${inputfile}

# Clean up
rm ftp_links.txt

# Write summary stats
downloaded=`ls Series_soft_files | wc -l`
undownloaded=` cat undownloaded_files.txt | wc -l`
outfile=Summary_`date +"%d-%m-%Y"`.txt

echo "SUMMARY STATS for ${org} on `date`" > ${outfile} 
echo "Total number of datasets ${total}" >> ${outfile}
echo "Downloaded datasets ${downloaded}" >> ${outfile}
echo "Undownloaded datasets ${undownloaded}" >> ${outfile}

echo "Successfully downloaded the soft files"

