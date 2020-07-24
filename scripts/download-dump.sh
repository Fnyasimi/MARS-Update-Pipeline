#! /usr/bin/env bash

# Script Name: download-dump.sh
# Author: Festus Nyasimi
# Date: 11 Mar 2020

# Description: Download and dump SRA files from a text file containing SRR accessions
# Automatically downloads the fastq files in the Data/Reads dir in your working dir
# works with sra 2.10 and above

# Usage bash sra_downloader.sh <accesion txt file>

# checks the input provided into the command
if [ $# -ne 1 ]
then
        echo "You have to provide a file with download links as single argument to this script."
        exit 1
fi

echo "You want to download sra files from $1 file"

#Load module
#module load 

# Make the directory if it doesnot exist and change into the directory
mkdir -p Data/Reads
[[ -f missing-reads.txt ]] && rm missing-reads.txt

infile=$1

# Download and dump function
checkdownload() {
        line=$1
        echo "Downloading ${line##*/}"
        cd Data/Reads
        if [[ ! -f ${line##*/}_1.fastq.gz ]]
        then
                # Do a while loop till file is downloaded
                count=0
                srapath=~/ncbi/public/sra
                while [[ ! -f ${line##*/}/${line##*/}.sra ]] || [[ ! -s ${line##*/}/${line##*/}.sra ]] || [[ ! -f ${srapath}/${line##*/}.sra ]] && [[ ${count} -ne 2 ]]
                do
                        prefetch --max-size 100000000 ${line##*/}
                        [[ -f ${line##*/}/${line##*/}.sra ]] && echo "Prefetched successfully" # for v 2.10.0 and above
			[[ -f ${srapath}/${line##*/}.sra ]] && echo "Prefetched successfully" # for v2.9.6 and below
                        (( count ++ ))
                        sleep 3
                done
		# Dump the reads
		[[ -s ${line##*/}/${line##*/}.sra ]] && fastq-dump -B --gzip --split-files ${line##*/}/${line##*/}.sra
		[[ -f ${srapath}/${line##*/}.sra ]] && fastq-dump -B --gzip --split-files ${line##*/}/${line##*/}.sra

                # clean up
                [[ -f ${line##*/}/${line##*/}.sra ]] && rm ${line##*/}/${line##*/}.sra
		[[ -f ${srapath}/${line##*/}.sra ]] && rm ${srapath}/${line##*/}.sra ${srapath}/${line##*/}.sra.cache
                [[ -d ${line##*/} ]] && rm -r ${line##*/}

       fi
        cd ../..

        # Echo undownloadable links
        if [[ ${count} -eq 2 ]]
        then
                echo ${line} >> missing-reads.txt
        fi
}

# export the function
export -f checkdownload

# Work on the infile
while read -r line
do
	checkdownload "${line}"
done < ${infile}

echo -e "Your fastq files are in $PWD/Data/Reads\n Job finished!!"


