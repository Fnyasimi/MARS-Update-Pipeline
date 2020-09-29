# Description
This dir contains the jupyter analysis notrbooks used for evaluation of the recently added data and the updated algorithms.


Recreate the conda environment and activate it before running the analysis.

*__NB:__* Gimmemotifs v0.4.14 uses meme version 5.0.5 hence this conflicts the environment above. You will need to set up a different environment for all the analysis involving gimmemotifs.

## Summary Notebook
This notebook is used to;
 - General information about the motif collection
 - Calculate the motif total and average information content and average length

## Evaluation Notebook
The notebook is used to test MARStools which have been ported to python3 for proper functioning

## Gimme Notebook
Used to run gimme analysis on a different conda environment because of the conflicting with the base environment.

The gimme tools uses meme v5.0.5 as a dependency but in our enviroment we are using v5.1.1.
It also requires the genome file.

## Analysis Notebook
The analysis notebook is used to assess *Drosophila* data in the following ways;
 - The general statistics of each scoring function for the selected TFs
 - Extract the motif information content (IC)
 - Get the correlation between the motifs and peak files
 - Get correlation between the different peal files
 - Test how the scoring functions affect the rankings
 - Test the effect of statistics on motif ranking
 - Test effect of scoring using AUC and MNCP
 - Correlation between Gimme roc scoring and Assess by score
 - Effect of motif length and IC on scoring functions
 - CB-MARS for the selected TFs
 - EB-MARS for the selected TFs


