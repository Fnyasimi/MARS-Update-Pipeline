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
  
## Download experiments data from GEO datasets
Edit the `input.json` file with the organism you are working with i.e _Drosophila melanogaster_ or _Homo sapiens_.
>> `"organism" : "Drosophila melanogaster"`

## Pre-processing the data
This step involves excluding experiments which do not contain ChIP-Seq data and cleaning experiments with mixed data to remain with experiments containing only ChiP-seq data. 

## Extract metadata
For each experiment extract the metadata to create a json file for each TF target and the samples associated. Also extract the links to raw read files in SRA for later downloading when running the experiment

## Download Reads and Run the Pipeline
Download the .sra reads and convert them to fastq.gz files, run the ChIP-Seq analysis. 
