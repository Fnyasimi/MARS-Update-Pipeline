#! /bin/bash

# Script Name: sra_downloader.sh
# Author: Festus Nyasimi
# Date: 14 Jan 2020

# Description: Download SRA files from a text file containing SRR link accessions

# Usage bash sra_downloader.sh <accesion txt file>

# checks the input provided into the command
if [ $# -ne 1 ]
then
        echo "You have to provide a file with download links as single argument to this script."
        exit 1
fi

echo "You want to download sra files from $1 file"

# Make the directory if it doesnot exist and change into the directory
mkdir -p Data/Reads

infile=$1

# Loop through the lines to download the files
while read -r line
do
	cd Data/Reads
	# Do a while loop till file is downloaded
	#while [ ! -f ${line##*/} ]
	#do
	#	wget ${line}
	#done

	# Change the file from .sra to .fastq.gz
	fastq-dump --gzip --split-files ${line##*/}
	#fastq-dump --gzip --split-spot --skip-technical --split-3 ${line##*/}
	rm ${line##*/}
	cd ../..
done < ${infile}

