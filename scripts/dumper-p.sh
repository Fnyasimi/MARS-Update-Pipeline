#! /bin/bash

# Script Name: dumper.sh
# Author: Festus Nyasimi
# Date: 11 May 2020

# Description: Dump SRA files from a text file containing SRR link accessions in parallel which have been prefetched already

# Usage bash dumper.sh <accesion txt file>

# checks the input provided into the command
if [ $# -ne 1 ]
then
        echo "You have to provide a file with download links as single argument to this script."
        exit 1
fi

echo "You want to download sra files from $1 file"

#Load module
module load chpc/gnu/parallel-20180622

# Make the directory if it doesnot exist and change into the directory
mkdir -p Data/Reads

infile=$1

dump() {
	line=$1
	echo "Dumping ${line##*/}"
        cd Data/Reads
        if [[ ! -f ${line##*/}_1.fastq.gz ]]
        then
                # Do a while loop to check if file is available
                count=0
                while [[ ! -f ${line##*/}/${line##*/}.sra ]] || [[ ! -s ${line##*/}/${line##*/}.sra ]] && [[ ${count} -ne 2 ]]
                do
			#[[ -f ${line##*/}/${line##*/}.sra ]] && mv ${line##*/}/${line##*/}.sra
                       	(( count ++ ))
                done
                [[ -s ${line##*/}/${line##*/}.sra ]] && fastq-dump -B --gzip --split-files ${line##*/}/${line##*/}.sra

		# clean up
                [[ -f ${line##*/}/${line##*/}.sra ]] && rm ${line##*/}/${line##*/}.sra
		[[ -d ${line##*/} ]] && rm -r ${line##*/}
        fi
        cd ../..

        # Echo undownloadable links
        if [[ ${count} -eq 2 ]]
        then
                echo ${line} >> non-dumped-reads.txt
        fi
}

# export the function
export -f dump

# Run in gnu parallel
#cat ${infile} | parallel --dry-run -j 15 dump {} {%} {#}
parallel -a ${infile} --delay 0.1 -j 24 --joblog dump.log dump {}

# Get the date and time
#for t in $(cat download.log | cut -f3 | cut -d'.' -f1 | tail -n +2); do date -d @$t; done
