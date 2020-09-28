# MARS Update Pipeline

## Introduction

This is a pipeline used to collect ChIP-Seq data from humans (_Homo sapiens_) and fruit fly (_Drosophila melanogaster_) from various sources and experiments to update the Motif Assessment and Ranking Suite ([MARS](http://bioinf.ict.ru.ac.za/)) benchmark data.

In this pipeline we collated ChIP-Seq data from different source;
  * Humans
      1. ENCODE Consortium 
      2. Geo datasets
      3. Sequence Read Archives
  * Drosophila
      1. ModERN
      2. Geo datasets
      3. modENCODE
      
The ChIP-Seq data is processed using [encode chipseq pipeline](https://github.com/ENCODE-DCC/chip-seq-pipeline2) if its collected from a source outside encode consortium

## Setting up the encode chipseq pipeline
Set up the encode chip seq pipeline following this [guide](https://github.com/ENCODE-DCC/chip-seq-pipeline2/blob/master/README.md).
 
Activate the pipeline's conda environment
   >> `conda activate encode-chip-seq-pipeline`

Install additional tools to the pipeline
  >> `conda install --file requirements.txt`
  
## Search and download experiments data from GEO datasets
GEO experiments were searched and downloaded in the *soft file format* using a custom script [`geo_search.sh`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/geo_search.sh).

Edit the `input.json` file with the organism you are working with i.e _Drosophila melanogaster_ or _Homo sapiens_.

>> `"organism" : "Drosophila melanogaster"`

## Pre-processing the data
This step involves excluding experiments which do not contain ChIP-Seq data and cleaning experiments with mixed data to remain with experiments containing only ChiP-seq data.

The downloaded experiments were cleaned using a build custom script [`filesort.py`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/filesort.py) which separates experiments which dont contain ChIP-Seq data from those that contain ChIP-Seq data. The script also separates data in GEO experiments soft files which have mixed data i.e RNA Seq data and ChIP-Seq data to only retain ChIP-Seq Data.

## Extract experiment data and convert to json file
For each GEO experiment soft file, the experimental data (TF antibody targets, experimental description and GSM accessions) was extracted and used to create a json file for each antibody target in the experiment and the GSM samples accessions associated.

For each antibody target in the experiment the metadata (GEO acc, Ab Target, cell line, tissue, cell type and the json file name) were recorded in a metadata.tsv file for later processing.

The SRA accessions associated to each GSM accession were also extracted for later downloading of the raw reads in fastq format when processing the data uniformly using the Encode ChIP-Seq pipeline.

All of the processes in this step are perfomed by a custom build module [`geosoft_extractor.py`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/geosoft_extractor.py) which uses support modules at different steps.

## Curation of the extracted experiments
In our study we are intereted in TF experiments only and not other type of  experiments. Some of the downloaded experiments contain Epigenetic targets and Cell signalling pathways which were not of interest to us. We developed custom scripts to filter out non-TF targets.  

We used the metadata file to find antibody targets which are not for transcription factors and remove the while  alsp droping the json files asoociated with them.

This step involved manual curation of the each record in the generated metadata file to assign the correct Antibody Target for each record. After this curation step the Epigenetics targets, Cell signalling Targets, RNA targets and other targets which were not TF targets were removed from the metadata file using a custom script [`cleanjson.sh`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/cleanjson.sh).

## Download Reads
The raw reads of each curated experiment were download in `.sra` file format then dumped into fastq.gz format using the Ncbi's sra-tool kit.

We develop a custom  script [`links_download.sh`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/links-parallel-p.sh) that downloads the raw reads from sra. It donwloads the SRA accessions from a list.

Once downloaded the reads are dumped using a custom script [`dumper.sh`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/dumper-p.sh), this converts them from .sra to .fastq.

## Run analysis pipeline
The analysis pipeline was run using a custom script [`chip_analysis.sh`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/scripts/chip_analysis.sh). This script invokes the chipseq analysis and outputs the results in the results dir. The peak files are also colleted in the `peak-files` directory for easy collection and retrieval.

# Reproducible pipeline

All the steps above are wrapped up in a reproducible snakemake environments which starts from experiment search to analysis of the data.

The steps have been tied up in a job submission script `analyze_chip.pbs` for working on an hpc environment.





