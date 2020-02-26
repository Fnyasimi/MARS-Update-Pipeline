# Raw motifs

This folder contains the raw motifs used to generate meme motifs

## Bergman's Lab
A motif collation from Bergmans lab downloaded from [here] on 21 Feb 2020.

The xml format `Bergman_lab_selexConsensus1.1.xms` was time consuming to convert it to MEME format 
and we sought to download the same motifs from the footprint database in the form of transfac format.

These motifs were downloaded to `DrosophilaTF` folder then concatenated to a single file `drosophilaTF_bergman.transfac`
then converted to MEME format `transfac2meme -use_acc`.

## Wolf's Lab
Motif collation from Wolf's Lab downloaded here in the cm format `Wolf_lab_84-hd-matrix-omega.txt` on 21 Feb 2020 
and converted to MEME format using a custom script `converter.sh`.

## Daniel Pollard
Motif collection was downloaded in the cm format `daniel_pollard_footprint_matrices.txt` and in matrices `footprint_matrices.tar` on 24 Feb 2020.

The matices were used in conversion to MEME format using `jaspar2meme -cm matrices`

## Smile-Seq
Motifs were downloaded from here in the transfac format into `smile-seq` folder on 24 Feb 2020.
The motifs were concatenated into a single file then converted into MEME format.

## Fly Vector
The motif collation was downloaded from here on 21 Feb 2020 in the form of CM format `Flyvector_survey_UmassPGFE_PWMfreq_PublicDatasetB_20200221.txt`.
Downloaded dataset B. The collation was converted to MEME format using a custom script `converter.sh`.

## Cis-PB
The motif collation from the database was downloaded from here on 25 Feb 2020 as `Drosophila_melanogaster_2020_02_25_9_06_am.zip` containing matrix files and TF information in a zip file.
The folder was unzipped and using a custom script `cisbp_converter.sh` the motifs were converted into a MEME format.

## Jaspar2020
Motif collation from the Jaspar database were downloaded in the meme format as a single file on 21 Feb 2020.
