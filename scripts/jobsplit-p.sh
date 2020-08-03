#! /bin/bash

# Script name: jobsplit.sh
# Author: Festus Nyasimi
# Date: 09 Mar 2020

# The script is used to split large number of files into smaller chunks for submission to a PBS job scheduler, it uses gnu parallel for parallelization of tasks.

# Check if arguments are provided
if [[ $# -ne 4 ]]
then
	echo "Missing one argument"
	echo 'Usage: bash jobsplit-p.sh <jsondir> <linksdir> <chunksize> <organism>'
	exit 1
fi

# Assign the dir
indir=$1
links=$2
chunk=$3
org=$4

[[ ! -d ${indir} ]] && echo "${indir} is not a directory" && exit 1
[[ ! -d ${links} ]] && echo "${links} is not a directory" && exit 1

count=0
bcount=1

# Make dir for jobs scripts and output files
[[ ! -d ${indir}-jobs ]] && mkdir -p ${indir}-jobs
jobs=${indir}-jobs
# Make chunks of files
echo "Splitting files and creating job scripts"
for file in $(ls ${indir})
do
	if [[ ${count} -eq 0 ]]
	then
		# Make sub batch directory
		[[ ! -d ${indir}/sub-batch${bcount} ]] && mkdir -p ${indir}/sub-batch${bcount}
		

		# Create sub batch job script for submitting
		echo -e "#! /bin/bash\n" > ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -N ${indir}-sub-batch${bcount}-${org}" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -o localhost:/mnt/lustre/users/ckibet/MARS_update/${jobs}/sub-batch${bcount}.out" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -e localhost:/mnt/lustre/users/ckibet/MARS_update/${jobs}/sub-batch${bcount}.err" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -P CBBI0922" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -l select=10:ncpus=24:mpiprocs=24:mem=120gb:nodetype=haswell_reg" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -l walltime=48:00:00" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -q normal" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -m abe" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#PBS -M sg30pu36145@pu.ac.ke" >> ${jobs}/sub-batch${bcount}.pbs
		#echo -e "#PBS -p 300\n" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "cd /mnt/lustre/users/ckibet/MARS_update\n" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "#Load module" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "module load chpc/python/anaconda/3" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "module load chpc/gnu/parallel-20180622" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "source activate /home/ckibet/lustre/miniconda3/envs/encode-chip-seq-pipeline\n" >> ${jobs}/sub-batch${bcount}.pbs
		
		echo -e "# Process all files in inputs directory 10 at a time" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "# Run analysis" >> ${jobs}/sub-batch${bcount}.pbs

		#echo -e "cat \$PBS_NODEFILE > nodes.txt" >> ${jobs}/sub-batch${bcount}.pbs
		echo -e "ls ./${indir}/sub-batch${bcount}/*.json | parallel --joblog ${jobs}/p-sub-batch${bcount}.log --sshloginfile \$PBS_NODEFILE -j1 'module load chpc/python/anaconda/3; source activate /home/ckibet/lustre/miniconda3/envs/encode-chip-seq-pipeline; cd /mnt/lustre/users/ckibet/MARS_update; ./chip_analysis.sh {} ${org}'" >> ${jobs}/sub-batch${bcount}.pbs
	fi

	[[ -f ${indir}/${file} ]] && mv ${indir}/${file} ${indir}/sub-batch${bcount}
	(( count ++ ))

	# Echo out the link files
	[[ -f ${links}/${file%.*}.txt ]] && cat ${links}/${file%.*}.txt >> ${indir}/sub-batch${bcount}-links.txt

	if [[ ${count} -eq ${chunk} ]]
	then
		count=0
		(( bcount ++ ))
	fi
done

# Submit the jobs to a scheduler
#for pbsfile in $(ls ${jobs}/*.pbs)
#do
#	qsub ${jobs}/${pbsfile}
#done
echo "Kazi si rahisi!!!"
