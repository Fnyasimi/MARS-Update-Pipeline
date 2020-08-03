#! /bin/python

# Script Name: geosoft_extractor.py

# Author: Festus Nyasimi

# Date: 17 Jan 2020

""" 
The Script extracts metadata file a GEO soft file and creates a json file.

Written in Python 3.7

Usage: python geosoft_extractor.py <geosoft file>

"""

# import required modules
import shutil
import difflib
import subprocess
import os
import sys
import wrangle_functions

# Check of all arguments have been provided
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


# Make directories
if os.path.exists("Jsonfiles"):
    pass
else:
    os.makedirs("Processed_Data/Undownloadable_data")
    os.makedirs("Processed_Data/Undetermined_targets")
    os.makedirs("Jsonfiles")
    os.makedirs("links_tmp")
# Metadata header
if os.path.isfile("metadata.tsv"):
    pass
else:
    metafile = open("metadata.tsv", "w")
    metafile.write("Expt Accession\tTarget\tTissue\tCell line\tCell type\tGeneric peak name\n")
    metafile.close()
# Terms which define control samples
control_terms = ["none", "input", "igg", "genomic", "genomic DNA", "n/a"]

# Open the file for data  extraction
with open(infile, "r") as myfile:
    sample_name = ""
    sample_title = ""
    sample_target = ""
    targets = []
    controls = []
    All_samples = {} # A dict containing each sample GSM and title
    Control_samples = {} # A dict containing each control sample GSM and title
    for line in myfile:
        # Get samples
        if line.startswith("^SAMPLE"):
            sample_name = line[10:].rstrip()
            sample_target = ""
        if line.startswith("!Sample_title"):
            sample_title = line[16:].rstrip()
        
        # Search for transcription factor target antibodies
        if sample_target == "":
            if line.startswith("!Sample_characteristics_ch1 = chip antibody:") or line.startswith("!Sample_characteristics_ch1 = chip-antibody:") or line.startswith("!Sample_characteristics_ch1 = chip_antibody:"):
                sample_target = line[45:].rstrip()
            if line.startswith("!Sample_characteristics_ch1 = tchip antibody:"):
                sample_target = line[46:].rstrip()
            if line.startswith("!Sample_characteristics_ch1 = purification target:"):
                sample_target =  line[51:].rstrip()
            if line.startswith("!Sample_characteristics_ch1 = antibody:"):
                sample_target = line[40:].rstrip()
            if line.startswith("!Sample_characteristics_ch1 = factor:"):
                sample_target = line[38:].rstrip()
            if line.startswith("!Sample_characteristics_ch1 = ip"):
                sample_target = line[34:].split(":")[-1].strip()
            if line.startswith("!Sample_characteristics_ch1 = chip epitope:") or line.startswith("!Sample_characteristics_ch1 = factor chip:") or line.startswith("!Sample_characteristics_ch1 = ip antibody:") or line.startswith("!Sample_characteristics_ch1 = chip_epitope:") or line.startswith("!Sample_characteristics_ch1 = chip target:") or line.startswith("!Sample_characteristics_ch1 = chip antigen:"):
                sample_target = line[43:].strip()
            if line.startswith("!Sample_characteristics_ch1 = chip antibodies:") or line.startswith("!Sample_characteristics_ch1 = antibody target:") or line.startswith("!Sample_characteristics_ch1 = chip (antibody):"):
                sample_target = line[47:].strip()
            if line.startswith("!Sample_characteristics_ch1 = antibodies:"):
                sample_target = line[42:].strip()
            if line.startswith("!Sample_characteristics_ch1 = chip ab:") or line.startswith("!Sample_characteristics_ch1 = epitope:") or line.startswith("!Sample_characteristics_ch1 = target:") or line.startswith("!Sample_characteristics_ch1 = chip-ab:"):
                sample_target = line[38:].strip()
            if line.startswith("!Sample_characteristics_ch1 = chip antibody catalog") or line.startswith("!Sample_characteristics_ch1 = chip_antibody_catalog"):
                sample_target = line[53:].strip()
            if line.startswith("!Sample_characteristics_ch1 = antibody (catalog)"):
                sample_target = line[50:].strip()
            if line.startswith("!Sample_characteristics_ch1 = chip antibody:") or line.startswith("!Sample_characteristics_ch1 = chip  antibody:") or line.startswith("!Sample_characteristics_ch1 = chip anitbody:"):
                sample_target = line[45:].strip()
            if line.startswith("!Sample_characteristics_ch1 = chip-seq antibody:") or line.startswith("!Sample_characteristics_ch1 = chip seq antibody:"):
                sample_target = line[49:].strip()
            if line.startswith("!Sample_characteristics_ch1 = ChIP:"):
                sample_target = line[35:].strip()
            if line.startswith("!Sample_characteristics_ch1 = antibody used:") or line.startswith("!Sample_characteristics_ch1 = ChIP Antibody:") or line.startswith("!Sample_characteristics_ch1 = beads/antibody:"):
                sample_target = line[45:].strip()
            if line.startswith("!Sample_characteristics_ch1 = antibody/details:") or line.startswith("!Sample_characteristics_ch1 = antibody source") or line.startswith("!Sample_characteristics_ch1 = antibody/enzyme:") or line.startswith("!Sample_characteristics_ch1 = antibody/capture:"):
                sample_target = line[47:].strip()

            
        if line.startswith("!Sample_data_row_count"):
            # Append all samples and their titles
            All_samples[sample_name] = sample_title
            # Shorten the target name
            sample_target = sample_target.split("(")[0].strip()
            # Search for controls through chip target and title
            if sample_target.casefold() in control_terms:
                controls.append(sample_name)
                Control_samples[sample_name] = sample_title
            else:
                tag = []
                for word in control_terms:
                    # check if control terms exist in the target
                    if word in sample_target.casefold():
                        controls.append(sample_name)
                        Control_samples[sample_name] = sample_title
                    # check if control terms exist in the title
                    elif word in sample_title.casefold():
                        controls.append(sample_name)
                        Control_samples[sample_name] = sample_title
                    # if they dont exist  in both then append a false
                    else:
                        tag.append(False)
                if len(tag) == 6:
                    if "control" in sample_title.casefold() or "control".casefold() == sample_target or "control" == sample_target.casefold():
                        controls.append(sample_name)
                        Control_samples[sample_name] = sample_title
                    else:
                        pass
            
            # Finding all targets in the experiment            
            if sample_target.casefold() not in control_terms:
                if sample_target.casefold() != "." and sample_target.casefold() != "" and sample_target.casefold() != "no" and sample_target.casefold() != "na" and sample_target.casefold() != "-" and "n/a" not in sample_target.casefold() and "none" not in sample_target.casefold() and "igg" not in sample_target.casefold():
                    targets.append(sample_target)
    # Get unique targets only
    targets = list(set(targets))
    remove = [] #Remove more non targets
    for term in ["input","control", 'no antibody', 'genomic', 'immunoglobulin', 'igg']:
        for target in targets:
            if term.casefold() in target or term == target.casefold() or term in target.casefold():
                remove.append(target)

    remove = list(set(remove))
    for item in remove:
        targets.remove(item)
    #print(targets)
    
    # Remove controls from All samples
    for item in Control_samples:
        del All_samples[item]
    
    #print(All_samples)
    #print(Control_samples)
         
    ## MATCH SAMPLES AND CONTROLS
    matches = {}
    if len(Control_samples)== 0:
        pass
    elif len(controls) == 1:
        for sgsm,stitle in All_samples.items():
            #print(stitle + " : " + Control_samples.get(controls[0]))
            matches[sgsm]=controls[0]
    else:
        for sgsm,stitle in All_samples.items():
            n = difflib.SequenceMatcher(None, stitle, Control_samples.get(controls[0])).ratio()
            best = controls[0]
            for ctl in controls[1:]:
                # Use Sequence matcher to match header of sample and control
                test = difflib.SequenceMatcher(None, stitle, Control_samples.get(ctl)).ratio()
                if float(test) > float(n):
                    n = test
                    best = ctl
            #print(stitle + " : " + Control_samples.get(best))
            matches[sgsm]=best
        
    #print(matches)
    
    ## Loop through targets to create json files
    if len(targets) == 0:
        # Move file to another folder targets_undetermined
        myfile.close()
        shutil.move(infile,"Processed_Data/Undetermined_targets/"+infile.split('/')[-1])
        print("No target found")
        exit()
    else:
        stopper = False
        for target in targets:
            #print(infile.split('/')[-1].split('_')[0] + "_" +target.replace(" ","_").replace(",","") + ".json")
            outname = infile.split('/')[-1].split('_')[0] + "_" +target.replace(" ","_").replace(",","").replace("/","").replace("'", "").replace('"','').replace("&","").replace(".","_").replace("[","").replace("]","").replace(";","").replace(":","").replace("__","_")
            
            # Ensure the  links file is empty
            links = open("links_tmp/" + outname + ".txt", "w")
            links.close()
            outfile = open("Jsonfiles/" + outname + ".json", "w")
            outfile.write("{\n")
            
            expt_samples = []
            cell_line = "-"
            tissue = "-"
            cell_type = "-"

            # Extract GSM samples for that specific target
            myfile.seek(0)
            for line in myfile:
                # Get title and description
                # Get the title of the experiment
                if line.startswith("!Series_title"):
                    title = line[16:].rstrip()
                    description = ""
                # Get summary which will be used as description
                if line.startswith("!Series_summary"):
                    if description == "":
                        description = line[18:].rstrip()
                
                if line.startswith("^SAMPLE"):
                    sample_name = line[10:].rstrip()
                    sample_target = ""

                if line.startswith("!Sample_characteristics_ch1 = cell type:"):
                    cell_type = line[41:].rstrip()
                if line.startswith("!Sample_characteristics_ch1 = cell line:"):
                    cell_line = line[41:].rstrip()
                if line.startswith("!Sample_characteristics_ch1 = tissue:"):
                    tissue = line[38:].rstrip()
                
                # Search for transcription factor target antibodies
                if sample_target == "":
                    if line.startswith("!Sample_characteristics_ch1 = chip antibody:") or line.startswith("!Sample_characteristics_ch1 = chip-antibody:") or line.startswith("!Sample_characteristics_ch1 = chip_antibody:"):
                        sample_target = line[45:].rstrip()
                    if line.startswith("!Sample_characteristics_ch1 = tchip antibody:"):
                        sample_target = line[46:].rstrip()
                    if line.startswith("!Sample_characteristics_ch1 = purification target:"):
                        sample_target =  line[51:].rstrip()
                    if line.startswith("!Sample_characteristics_ch1 = antibody:"):
                        sample_target = line[40:].rstrip()
                    if line.startswith("!Sample_characteristics_ch1 = factor:"):
                        sample_target = line[38:].rstrip()
                    if line.startswith("!Sample_characteristics_ch1 = ip"):
                        sample_target = line[34:].split(":")[-1].strip()
                    if line.startswith("!Sample_characteristics_ch1 = chip epitope:") or line.startswith("!Sample_characteristics_ch1 = factor chip:") or line.startswith("!Sample_characteristics_ch1 = ip antibody:") or line.startswith("!Sample_characteristics_ch1 = chip_epitope:") or line.startswith("!Sample_characteristics_ch1 = chip target:") or line.startswith("!Sample_characteristics_ch1 = chip antigen:"):
                        sample_target = line[43:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = chip antibodies:") or line.startswith("!Sample_characteristics_ch1 = antibody target:") or line.startswith("!Sample_characteristics_ch1 = chip (antibody):"):
                        sample_target = line[47:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = antibodies:"):
                        sample_target = line[42:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = chip ab:") or line.startswith("!Sample_characteristics_ch1 = epitope:") or line.startswith("!Sample_characteristics_ch1 = target:") or line.startswith("!Sample_characteristics_ch1 = chip-ab:"):
                        sample_target = line[38:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = chip antibody catalog") or line.startswith("!Sample_characteristics_ch1 = chip_antibody_catalog"):
                        sample_target = line[53:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = antibody (catalog)"):
                        sample_target = line[50:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = chip antibody:") or line.startswith("!Sample_characteristics_ch1 = chip  antibody:") or line.startswith("!Sample_characteristics_ch1 = chip anitbody:"):
                        sample_target = line[45:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = chip-seq antibody:") or line.startswith("!Sample_characteristics_ch1 = chip seq antibody:"):
                        sample_target = line[49:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = ChIP:"):
                        sample_target = line[35:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = antibody used:") or line.startswith("!Sample_characteristics_ch1 = ChIP Antibody:") or line.startswith("!Sample_characteristics_ch1 = beads/antibody:"):
                        sample_target = line[45:].strip()
                    if line.startswith("!Sample_characteristics_ch1 = antibody/details:") or line.startswith("!Sample_characteristics_ch1 = antibody source") or line.startswith("!Sample_characteristics_ch1 = antibody/enzyme:") or line.startswith("!Sample_characteristics_ch1 = antibody/capture:"):
                        sample_target = line[47:].strip()


                if line.startswith("!Sample_data_row_count"):
                    sample_target = sample_target.split("(")[0].strip()
                    if target == sample_target:
                        expt_samples.append(sample_name)
                        #print(sample_name)
            genome_path = os.path.abspath(os.getcwd()) + "/Data/genome"
            # Print constant variables
            outfile.write('    "chip.title" : "' + title + '",\n\n')
            outfile.write('    "chip.description" : "' + description + '",\n\n')
            outfile.write('    "chip.pipeline_type" : "tf",\n')
            outfile.write('    "chip.aligner" : "bowtie2",\n')
            outfile.write('    "chip.align_only" : false,' + '\n\n')
            outfile.write('    "chip.genome_tsv" : "%s/hg38/hg38.tsv",'%(genome_path) + '\n\n')
            
            # Check the experiment samples are in controls and remove them
            for control in controls:
                if control in expt_samples:
                    expt_samples = list(filter(lambda x: x != control, expt_samples))
            
            # SAMPLES
            # Use only 10 samples due to memory constrains in the pipeline
            scounter = 0
            matched_controls = []
            samp_ends =[]
            for sample in expt_samples[:10]:
                if len(matches) != 0:
                    ctl = matches.get(sample)
                    matched_controls.append(ctl)
                scounter += 1
                #print(sample + "::::"+ ctl)
                
                # Get the endedness of the sample
                # Retry downloading if it fails on first instance
                ender = ""
                c = 0
                while ender == "" and c < 3:
                    ender = os.popen('check_endedness.sh ' + sample + " " + outname).read()
                    c += 1
                # Confirm data is available
                if ender == "":
                    stopper = True
                else:
                    pass
                #Break out of the loop if data is unavailable
                if stopper:
                    break
                
                # Use the output to create the fastqs arrays in json for replicates
                chip_type = "fastqs"
                wrangle_functions.array_creator(chip_type, scounter, ender, outfile)
                
                # Get the endness array
                wrangle_functions.ends_array(samp_ends, ender)
                
                # Download the data files
            outfile.write('\n')
            
            ### If Data is unavailable stop further execution
            if stopper:
                #Remove the file 
                # Move the soft file to undownloaded_data
                outfile.close()
                os.remove("Jsonfiles/"+ outname + ".json")
                shutil.move(infile,"Processed_Data/Undownloadable_data/"+infile.split('/')[-1])
                print("Unable to download file data")
                break
                
            # print the endedness
            s_type = "paired"
            wrangle_functions.ends_writer(samp_ends, s_type, outfile)
                
            # CONTROLS
            cont_ends =[]
            # Check if all experiments have different controls or same controls
            if len(expt_samples[:10]) == len(list(set(matched_controls))):
                outfile.write('    "chip.always_use_pooled_ctl" : false,' + '\n\n')
                
                ccounter = 0
                for contrl in matched_controls:
                    ccounter += 1
                    
                    # Retry downloading if it fails on first instance
                    ender = ""
                    c = 0
                    while ender == "" and c < 3:
                        ender = os.popen('check_endedness.sh ' + contrl + " " + outname).read()
                        c += 1   
                    chip_type = "ctl_fastqs"

                    if ender == "":
                        stopper = True
                    else:
                        pass
                    #Break out of the loop if data is unavailable
                    if stopper:
                        break
                    
                    # Use the Array creator function
                    wrangle_functions.array_creator(chip_type, ccounter, ender, outfile)
                    
                    # Get the endness array
                    wrangle_functions.ends_array(cont_ends, ender)
                    
                    # Download data
                    
            elif len(expt_samples[:10]) > len(list(set(matched_controls))) and len(list(set(matched_controls))) != 0:
                if len(list(set(matched_controls))) == 1:
                    outfile.write('    "chip.always_use_pooled_ctl" : false,' + '\n\n')  
                else:
                    outfile.write('    "chip.always_use_pooled_ctl" : true,' + '\n\n')
                ccounter = 0
                for contrl in list(set(matched_controls)):
                    ccounter += 1
                    
                    # Retry downloading if it fails on first instance
                    ender = ""
                    c = 0
                    while ender == "" and c < 3:
                        ender = os.popen('check_endedness.sh ' + contrl + " " + outname).read()
                        c += 1
                    chip_type = "ctl_fastqs"

                    if ender == "":
                        stopper = True
                    else:
                        pass
                    #Break out of the loop if data is unavailable
                    if stopper:
                        break
                    
                    # Use the Array creator function
                    wrangle_functions.array_creator(chip_type, ccounter, ender, outfile)
                    
                    # Get the endness array
                    wrangle_functions.ends_array(cont_ends, ender)
                    
                    # Download the data
            else:
                pass

            # if Data for controls unavailable
            if stopper:
                #Remove the file
                # Move the soft file to undownloaded_data
                outfile.close()
                os.remove("Jsonfiles/"+ outname + ".json")
                shutil.move(infile,"Processed_Data/Undownloadable_data/"+infile.split('/')[-1])
                print("Unable to download controls file data")
                break

            outfile.write('\n')
            # print the endedness
            c_type = "ctl_paired"
            wrangle_functions.ends_writer(cont_ends, c_type, outfile)
            outfile.write('\n')
            
            # Allocate more memory
            if len(expt_samples[:10]) <= 4:
                outfile.write('    "chip.align_mem_mb" : 40000,\n')
                outfile.write('    "chip.call_peak_mem_mb" : 32000\n')
            else:
                outfile.write('    "chip.align_mem_mb" : 80000,\n')
                outfile.write('    "chip.call_peak_mem_mb" : 64000\n')
                
            outfile.write('\n')
            outfile.write('}\n')
            outfile.close()
            
            # Confirm if metadata for expt exists and write out the metadata
            append_expt = True
            metafile = open("metadata.tsv", "a+")
            metafile.seek(0)
            for line in metafile:
                if line.split("\t")[5].strip() == outname:
                    append_expt = False
            if append_expt:
                metafile.write(infile.split('/')[-1].split('_')[0] + "\t" + target + "\t" + tissue + "\t" + cell_line + "\t" + cell_type + "\t" + outname + "\n")
            metafile.close()

myfile.close()
