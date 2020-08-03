#! /usr/bin/env bash

# Author: Festus Nyasimi
# Date: 16 Mar 2020

# Description
# This script is used to modify already created json file
# Use it carefully

# 1. change the absolute path
# 2. change allocated resources to the pipeline

# load module
module load chpc/gnu/parallel-20180622

if [[ $# -ne 3 ]]
then
        echo "Usage: <input dir> <align cpus> <call peak cpus>"
        exit 1
fi

# Assign variables
indir=$1
al=$2
cp=$3

ch_res() {

[[ -f $1 ]] && infile=$1; al=$2; cp=$3 

# Change the absolute path
sed -i s'/\/home\/user\/MARStools/\/home\/ckibet\/lustre\/MARS_update/'g ${infile}

# Delta number of chip align cores and peak calling cores
# Check if the resources exist before changing
if grep -Fq "chip.call_peak_cpu" ${infile}
then
	echo "Already updated"
else
	echo "Updating parameters"
	sed -i "s/\"chip.call_peak_mem_mb\"\ :\ 32000/\"chip.call_peak_mem_mb\"\ :\ 32000,\n\ \ \ \ \"chip.align_cpu\"\ :\ ${al},\n\ \ \ \ \"chip.call_peak_cpu\"\ :\ ${cp}/" ${infile}
	sed -i "s/\"chip.call_peak_mem_mb\"\ :\ 64000/\"chip.call_peak_mem_mb\"\ :\ 64000,\n\ \ \ \ \"chip.align_cpu\"\ :\ ${al},\n\ \ \ \ \"chip.call_peak_cpu\"\ :\ ${cp}/" ${infile}
fi
}

# export function
export -f ch_res

ls ./${indir}/*.json | parallel -j10 ch_res {} ${al} ${cp}
echo "Successfully done"
