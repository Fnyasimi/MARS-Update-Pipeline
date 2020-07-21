#! /usr/bin/env bash

# Author: Festus Nyasimi

# The scriot is used to remove duplicate peak files from encode metadata file 
# It selects only peaks called with the GRCh38 human genome if not available then uses hg19

# To do make the input part of cmd input arg
infile=hg-ENCODE-metadata.tsv

# get the ids
awk -F "\t" 'NR >= 2 {print$4}' ${infile} | uniq > expt-id.txt

[[ -f tmp.tsv ]] && rm tmp.tsv

# Get optimal peaks called with hg38
awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="GRCh38" ) {print$4}' ${infile} | uniq > hg38.txt
awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="GRCh38" ) {print$4}' ${infile} | uniq -d > dups-hg38.txt
awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="GRCh38" ) {print$0}' ${infile} > tmp.tsv
# get the ids of the remeinder
grep -v -f hg38.txt expt-id.txt > get19.txt

# Subset the data to only ois not found before
grep -f get19.txt ${infile} > holder.tsv
infile2=holder.tsv

echo "step1"

# get optimal peaks called with hg19
awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="hg19" ) {print$4}' ${infile2} | uniq > hg19.txt
awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="hg19" ) {print$4}' ${infile2} | uniq -d > dups-hg19.txt
awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="hg19" ) {print$0}' ${infile2} >> tmp.tsv
#get ids of the remainder
grep -v -f hg19.txt get19.txt > manualget.txt

#subset again
grep -f manualget.txt ${infile} > holder2.tsv
infile3=holder2.tsv

echo "step2"

#get pseudoreplicated idr with hg38
awk -F "\t" '( $3=="pseudoreplicated IDR thresholded peaks" && $44=="GRCh38" ) {print$4}' ${infile3} | uniq > m1.txt
awk -F "\t" '( $3=="pseudoreplicated IDR thresholded peaks" && $44=="GRCh38" ) {print$4}' ${infile3} | uniq -d > dups-m1.txt
awk -F "\t" '( $3=="pseudoreplicated IDR thresholded peaks" && $44=="GRCh38" ) {print$0}' ${infile3} >> tmp.tsv
#get remainder ids
grep -v -f m1.txt manualget.txt > m1further.txt

#Subset again
grep -f m1further.txt ${infile} > holder3.tsv
infile4=holder3.tsv

echo "step3"

# get dup and unique peaks
awk -F "\t" '{print$4}' ${infile4} | uniq > m2.txt
awk -F "\t" '{print$4}' ${infile4} | uniq -d > dups-m2.txt

grep -v -f dups-m2.txt ${infile4} >> tmp.tsv

# Work on the duplicates
cat dups-*.txt > adups.txt

# Get cleaned up peaks 
grep -v -f adups.txt tmp.tsv > hg-ENCODE-narrowpeaks-metadata.tsv
grep -f adups.txt tmp.tsv > duplicates.tsv
awk -F "\t" '( $48=="released") {print$0}' duplicates.tsv >> hg-ENCODE-narrowpeaks-metadata.tsv

echo "step4"

# Duplicated and archived
grep -f dups-m2.txt ${infile4} > duplicates.tsv

echo "Duplicated samples and archived samples are found in dups.tsv"

# clean up
rm *.txt
rm tmp.tsv
rm ${infile2} ${infile3} ${infile4}

awk -F "\t" '{print$43}' hg-ENCODE-narrowpeaks-metadata.tsv > hg-ENCODE-narrowpeaks.txt
