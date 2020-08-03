#! /bin/python

"""The script contains functions used by different scripts in executing the programme"""

# Script Name: wrangle_functions.py 

# Author: Festus Nyasimi

# Date: 16 Jan 2020

def array_creator(chip_type, counter, ender, outfile):
    
    """The function takes in sample ID the replicate array number and the output of the script which checks the endedness of the sample"""
    import os
    # Create absolute path to reads
    path = os.path.abspath(os.getcwd()) + "/Data/Reads/"
    
    enderl = ender.rstrip().split("\n")
    endedness = enderl[0]
    slist = enderl[1:]
    if len(slist) == 1:
        if endedness == "single ended":
            st = slist[0]
            s = '"'+path+st+'_1.fastq.gz"'
            outfile.write('    "chip.%s_rep%i_R1" : ['%(chip_type, counter) + s + ' ],\n')
        elif endedness == "paired ended":
            st = slist[0]
            s = '"'+path+st+'_1.fastq.gz"'
            p = '"'+path+st+'_2.fastq.gz"'
            outfile.write('    "chip.%s_rep%i_R1" : ['%(chip_type, counter) + s + ' ],\n')
            outfile.write('    "chip.%s_rep%i_R2" : [ '%(chip_type, counter) + p + ' ],\n')
        else:
            pass
    else:
        if endedness == "single ended":
            se = []
            for s in slist:
                se.append( '"'+path+s+'_1.fastq.gz"')    
            outfile.write('    "chip.%s_rep%i_R1" : [ '%(chip_type, counter) + ', '.join(se) + ' ],\n')
        elif endedness == "paired ended":
            se = []
            pe =[]
            for s in slist:
                se.append( '"'+path+s+'_1.fastq.gz"')
                pe.append( '"'+path+s+'_2.fastq.gz"')
            outfile.write('    "chip.%s_rep%i_R1" : [ '%(chip_type, counter) + ', '.join(se) + ' ],\n')
            outfile.write('    "chip.%s_rep%i_R2" : [ '%(chip_type, counter) + ', '.join(pe) + ' ],\n')
        else:
            pass

        
def ends_array(ends_list, ender):
    """ Gets the endness of the array """
    
    if ender.rstrip().split("\n")[0] == "single ended":
        #print("false")
        ends_list.append("false")
    elif ender.rstrip().split("\n")[0] == "paired ended":
        #print("true")
        ends_list.append("true")
    else:
        pass
    

def ends_writer(ends_list, ch_type, outfile):
    """Takes a list of ends of samples and prints them"""
    
    if len(list(set(ends_list))) == 1:
        if ends_list[0] == "true":
            outfile.write('    "chip.%s_end" : true,'%(ch_type) + '\n')
        else:
            outfile.write('    "chip.%s_end" : false,'%(ch_type) + '\n')
    elif len(list(set(ends_list))) == 0:
        if ch_type == "ctl_paired":
            outfile.write('    "chip.peak_caller" : "macs2",\n')
        else:
            pass
    else:
        outfile.write('    "chip.%s_ends" : [ '%(ch_type) + ', '.join(ends_list) + ' ],\n')
