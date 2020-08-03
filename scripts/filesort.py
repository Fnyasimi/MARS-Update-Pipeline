#! /bin/python

# Script name: filesort.py

# Author: Festus Nyasimi

# Date: 20 Jan 2020

# Usage: Python filesort.py <indir>

"""
The module is used to check if an experiment contains ChIP-Seq data and sort experiments with
ChIP-Seq data only, Mixed data and those without Chip-Seq data.
Outputs:
    Processed_Data/Cleaned_experiments - Experiments with ChIP-Seq data only
    Processed_Data/Mixed_experiments - Mixed data experiments which are cleaned to get only Samples with ChIP data
                                        which are then copied to Cleaned Experiments
    Processed_Data/Non-ChIP_experiments - Experiments that do not contain ChIP-Seq data

Written in Python v3.7.3
Prepared by Festus Nyasimi on 20 Dec 2019.

Usage: Python filesort.py <softfile>

"""

# import modules 
import os
import shutil
import sys


# Check all arguments are provided
if len(sys.argv) == 2:
    # Input file
    infile = os.getcwd() + "/" + sys.argv[1]
    
    # Check if the paths exist
    if os.path.isfile(infile):
        pass
    else:
        print("The file does not exist!!!")
        print(__doc__)
        exit()
else:
    print(__doc__)
    exit()

# Make all directories
if os.path.exists("Processed_Data/Cleaned_experiments"):
    pass
else:
    os.makedirs("Processed_Data/Cleaned_experiments")
    os.makedirs("Processed_Data/Mixed_experiments")
    os.makedirs("Processed_Data/Non-ChIP_experiments")

# Start check up process
chip = False # To check if an experiment contains ChIP data    
# Open the file for reading
with open(infile, "r") as myfile:
    for line in myfile:
        # Get individual sample name
        if line.startswith("^SAMPLE"):
            gsm_name = line[10:].rstrip()

        # Check if the experiment contains ChIP_seq data
        if line.startswith("!Sample_library_strategy"):
            expt_name = line[27:].rstrip()

            if expt_name == "ChIP-Seq":
                chip = True
myfile.close()

# Move if non chip experiments
if chip:
    pass
else:
    print("Moved to Non ChIP-Seq Expts")
    shutil.move(infile,"Processed_Data/Non-ChIP_experiments/"+infile.split('/')[-1])
    exit()
    
# Check if mixed chip or pure chip experiment
with open(infile, "r") as myfile:
    mixed_status =[] # a list to check if an experiment is mixed
    chip_seq_gsm = [] # a list containing samples ran for ChIP-Seq
    for line in myfile:
        # Get individual sample name
        if line.startswith("^SAMPLE"):
            gsm_name = line[10:].rstrip()

        # Check if the experiment contains ChIP_seq data
        if line.startswith("!Sample_library_strategy"):
            expt_name = line[27:].rstrip()

            if expt_name != "ChIP-Seq":
                mixed_status.append(gsm_name)
            else:
                chip_seq_gsm.append(gsm_name)

    # Separate pure ChIP-Seq expt and Clean Mixed experiments
    if len(mixed_status) >= 1:
        #print(mixed_status)
        # Clean the file
        newfile = open("Processed_Data/Cleaned_experiments/"+infile.split("/")[-1], "w") # Open new file for writing
        
        printing = False
        # Copy the header information
        myfile.seek(0)
        for line in myfile:
            if line.startswith("^DATABASE"):
                printing = True
            if line.startswith("^SAMPLE") or line.startswith("!Platform_data_row_count"):
                printing = False
            if printing:
                #print(line.rstrip())
                newfile.write(line)
        
        # Copy Sample information (GSM)
        for gsm in chip_seq_gsm:
            #print(gsm)
            myfile.seek(0)
            printing = False
            for line in myfile:
                if line.startswith("^SAMPLE"):
                    gsm_name = line[10:].rstrip()
                    printing = False
                    if gsm_name == gsm : 
                        printing = True
                    else:
                        printing = False
                if printing:
                    #print(line.rstrip())
                    newfile.write(line)
        newfile.close()
        # Move it to mixed files 
        shutil.move(infile,"Processed_Data/Mixed_experiments/"+infile.split('/')[-1])
        
    else:
        # Move it to cleaned files 
        shutil.move(infile,"Processed_Data/Cleaned_experiments/"+infile.split('/')[-1])
myfile.close()       
