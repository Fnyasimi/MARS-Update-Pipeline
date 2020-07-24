# Author: Caleb Kibet
# Modified by: Festus Nyasimi
# Date: 17 Apr 2020

"""
removemasked.py removes the sequences that have been repeat masked

Takes as input fasta sequence with repeat masks and writes out a fasta
withot repeat masked sequences.

Updated in Python v3.7.

Usage:
    python removemasked.py <input-fasta> <output-fasta>

"""
import sys

def removemasked(fa, out):
    '''
    Removes fasta sequences that have been repeatmasked in form of NNNs or acgt
    '''
    with open(fa) as fas:
        with open(out, "w") as faout:
            for line in fas:
                testset = []
                #print(len(line.strip().split("\t")))
                if len(line.strip().split("\t")) == 3: 
                    testset=set(line.strip().split("\t")[2])
                    if "N" in line or "a" in testset or "g" in testset or "c" in testset or "t" in testset:
                        continue
                    else:
                        faout.write(line)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    fa = sys.argv[1]
    out = sys.argv[2]
    removemasked(fa, out)
