#! /usr/bin/env bash

# A script for running the chip seq analysis"
if [[ $# -ne 2 ]]
then
        echo "Usage: <json file> <organism> "
        exit 1
fi


file=$1
org=$2

# Get the base name
basefile=`basename ${file} .json`
# Give the infile and outfolder absolute paths
infile=$(cd "$(dirname "${file}")"; pwd)/$(basename "${file}")
outdir=$PWD/Results/${org}/${basefile}
peak=$PWD/peak-files/${org}

mkdir -p ${peak}

# Run analysis
caper run $PWD/chip-seq-pipeline2/chip.wdl -i "${infile}" --out-dir "${outdir}"

# Change directory
cd "${outdir}"

# Organize output
[[ -f croo chip/*/metadata.json ]] && croo chip/*/metadata.json --out-def-json $PWD/chip-seq-pipeline2/chip.croo.v4.json

# Make QC metrics
[[ -f qc/qc.json ]] && qc2tsv qc/qc.json > ${basefile}.tsv

# Copy the peak file
### RegionPeak (With controls)
[[ -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz) ${basefile}.regionPeak.bed.gz
[[ -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz) ${peak}/${basefile}.regionPeak.bed.gz

## NarrowPeak (Without Controls)
[[ -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz)  ${basefile}.narrowPeak.bed.gz
[[ -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz)  ${peak}/${basefile}.narrowPeak.bed.gz
cd ../../..
