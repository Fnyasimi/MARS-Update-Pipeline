# MAARIFA SETUP

## Setting up the analysis pipeline and conda environment
I set up my local  distribution of mininconda which I used to set up two main conda environments;
  1. encode-chip-seq-pipeline
  2. my_tools
  
`my_tools` contains two major modules;
   - parallel
   - sra-tools

## Download the reference genome

The reference genome was downloaded based on the encode pipeline description

## Preprocessing input files

### Change absolute paths
First we need to change the absolute files in our json files as they were created on a different machine. 
To do this I updated the paths to the input files in the json files using a modified version of the [`change-resources-p.sh`]() script.
Inside that script is where I changed the absolute paths. To run the script;

`change-resources-p.sh <path to json files dir> <align cpus> <peakcall cpus>`

Ensure the absolute paths I am using in the [`links-parallel-p.sh`]() and [`dumper-p.sh`]() are the same ones I am using in the `change-resources-p.sh` script.
These scripts are used in the analysis script to download and dump reads.

### Create a jobs yaml file
Starting with a template yaml file, make a copy of the template;

`cp batch-template-jobs.yaml batch25-jobs.yaml`

Echo all the json files in the json directory into the jobs yaml file.

`ls /work/MARS_update/hg-jsonfiles/Batch2/sub-batch4/ >> batch24-jobs.yaml`

Edit it to fit a yaml style format while removing the suffix

`sed -i -e 's/GSE/    GSE/g' -e 's/.json/ : .json/g' batch24-jobs.yaml`

### Create a job template
Using an automated job creator and submitter tool and the yaml file, edit the [`template_submission.yaml`]() with correct path to;
  - jobs yaml file
  - job directory
  - json files directory
  - log files directory 
  - path to the script used to run analysis
  
 This tool will create job scripts and submit them automatically to the job scheduler by running;
 
 `python3 badger/src/badger.py -yaml_configuration_file template_submission.yaml -parsimony 9`
 
 Incase submission fails because of the scheduler set up do it manually;
 
 `for file in $(ls Batch2/sbatch3/); do sbatch Batch2/sbatch3/$file ; sleep 30; done`
 
 The jobs are executed using [`chip_analysis.sh`]() script which embeds the following tasks;
   - Downloading raw reads
   - Dumping raw reads into the `.sra` format
   - Running the Encode chip-seq analysis pipeline
   - Collecting the peak files in a specific location
   - Cleaning up the raw reads and working directory to save on space
   

  
