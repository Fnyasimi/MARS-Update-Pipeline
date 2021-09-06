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
outdir=/mnt/scratch/fnyasimi/Results/${org}/${basefile}
peak=/work/MARS_update/peak-files/${org}


# Activate conda env
source /mnt/exports/shared/home/festus.nyasismi/conda_env.sh
conda activate /mnt/exports/shared/home/festus.nyasismi/miniconda3/envs/my_tools

links=/mnt/exports/shared/home/festus.nyasismi/MARS_update/hg-links/Batch2/${basefile}.txt
# Download the reads
bash /mnt/exports/shared/home/festus.nyasismi/links-parallel-p.sh ${links} 

# Dump the reads
bash /mnt/exports/shared/home/festus.nyasismi/dumper-p.sh ${links}

# Activate the analysis env
conda deactivate
conda activate /mnt/exports/shared/home/festus.nyasismi/miniconda3/envs/encode-chip-seq-pipeline

mkdir -p ${peak}

# Run analysis
caper run /mnt/exports/shared/home/festus.nyasismi/chip-seq-pipeline2/chip.wdl -i "${infile}" --out-dir "${outdir}"

# Change directory
cd "${outdir}"

# Organize output
croo chip/*/metadata.json --out-def-json /mnt/exports/shared/home/festus.nyasismi/chip-seq-pipeline2/chip.croo.v4.json

# Make QC metrics
[[ -f qc/qc.json ]] && qc2tsv qc/qc.json > ${basefile}.tsv

# Copy the peak file
### RegionPeak (With controls)
[[ -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz) ${basefile}.regionPeak.bed.gz
[[ -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.regionPeak.gz) ${peak}/${basefile}.regionPeak.bed.gz

## NarrowPeak (Without Controls)
[[ -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz)  ${basefile}.narrowPeak.bed.gz
[[ -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz ]] && cp $(readlink -f peak/idr_reproducibility/idr.optimal_peak.narrowPeak.gz)  ${peak}/${basefile}.narrowPeak.bed.gz
cd $HOME

## Clean up 
rm -r ${outdir}
while read -r line
do
	[[ -f /mnt/scratch/fnyasimi/Data/Reads/${line##*/}_1.fastq.gz ]] && rm /mnt/scratch/fnyasimi/Data/Reads/${line##*/}*
done < ${links}
