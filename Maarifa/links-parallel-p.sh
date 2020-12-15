#! /usr/bin/env bash

# Script Name: links-parallel.sh
# Author: Festus Nyasimi
# Date: 11 Mar 2020

# Description: Download SRA files from a text file containing SRR link accessions in parallel

# Usage bash sra_downloader.sh <accesion txt file>

# checks the input provided into the command
if [ $# -ne 1 ]
then
        echo "You have to provide a file with download links as single argument to this script."
        exit 1
fi

echo "You want to download sra files from $1 file"

# Make the directory if it doesnot exist and change into the directory
mkdir -p /mnt/scratch/fnyasimi/Data/Reads
[[ -f missing-reads.txt ]] && rm missing-reads.txt

infile=$1

checkdownload() {
	line=$1
	echo "Downloading ${line##*/}"
        cd /mnt/scratch/fnyasimi/Data/Reads
        if [[ ! -f ${line##*/}_1.fastq.gz ]]
        then
                # Do a while loop till file is downloaded
                count=0
		#srapath=/home/ckibet/lustre/MARS_update/sra-data
                while [[ ! -f ${line##*/}/${line##*/}.sra ]] || [[ ! -s ${line##*/}/${line##*/}.sra ]] && [[ ${count} -ne 4 ]]
                do
			prefetch --max-size 100000000 ${line##*/}
			#[[ -f ${line##*/}/${line##*/}.sra ]] && mv ${line##*/}/${line##*/}.sra .
			#[[ -f ${srapath}/${line##*/}.sra ]] && mv ${srapath}/${line##*/}.sra .
                       	(( count ++ ))
			sleep 3
                done
                #[[ -s ${line##*/}.sra ]] && fastq-dump -B --gzip --split-files ${line##*/}.sra

		# clean up
                #[[ -f ${line##*/}.sra ]] && rm ${line##*/}.sra
		#[[ -d ${line##*/} ]] && rm -r ${line##*/}
        fi
        cd ../..

        # Echo undownloadable links
        if [[ ${count} -eq 4 ]]
        then
                echo ${line} >> ${infile}-missing-reads.txt
        fi
}

# export the function
export -f checkdownload

# Run in gnu parallel
#cat ${infile} | parallel --dry-run -j 15 checkdownload {} {%} {#}
parallel -a ${infile} --delay 0.2 -j 15 --joblog download.log checkdownload

# Get the date and time
#for t in $(cat download.log | cut -f3 | cut -d'.' -f1 | tail -n +2); do date -d @$t; done
