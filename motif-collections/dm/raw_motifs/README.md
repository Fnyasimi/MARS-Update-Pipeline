# Raw motifs

This folder contains the raw motifs used to generate meme motifs

## Bergman's Lab
A motif collation from Bergmans lab downloaded from [here](http://bergmanlab.genetics.uga.edu/?page_id=274) on 21 Feb 2020.

The xml format `Bergman_lab_selexConsensus1.1.xms` was time consuming to convert it to MEME format 
and we sought to download the same motifs from the [footprint DrosophilaTF database](http://floresta.eead.csic.es/footprintdb/index.php?database=7&type=motif&page=1) in the form of transfac format.

These motifs were downloaded to `DrosophilaTF` folder then concatenated to a single file `drosophilaTF_bergman.transfac`
then converted to MEME format `transfac2meme -use_acc`.

## Wolf's Lab
Motif collation from Wolf's Lab downloaded [here](https://www.umassmed.edu/wolfe-lab/binding-site-database/) in the cm format `Wolf_lab_84-hd-matrix-omega.txt` on 21 Feb 2020 
and converted to MEME format using a custom script `converter.sh`.

Edited using sed;

`sed -i 's/.mx//g' Wolf_lab_motifs.meme`

## Daniel Pollard
Motif collection was downloaded in the cm format `daniel_pollard_footprint_matrices.txt` and in matrices `footprint_matrices.tar` on 24 Feb 2020 from [here](http://www.danielpollard.com/matrices.html).

The matrices were converted to MEME format using `jaspar2meme -cm matrices`

## Smile-Seq
Motifs were downloaded from [here](http://floresta.eead.csic.es/footprintdb/index.php?database=20&type=motif&page=1) in the transfac format into `smile-seq` folder on 24 Feb 2020.
The motifs were concatenated into a single file `all_motifs.transfac` then converted into MEME format.

## Fly Factor
The motif collation was downloaded from [here](http://mccb.umassmed.edu/ffs/DownloadData.php) on 21 Feb 2020 in the form of CM format `Flyvector_survey_UmassPGFE_PWMfreq_PublicDatasetB_20200221.txt`.
Downloaded dataset B. The collation was converted to MEME format using a custom script `converter.sh`.

The meme file was using sed to extract the tf
```
sed -i 's/MOTIF\s\([-0-9A-Za-z.()]\+[_a-z]\+\?\)_\([-_.A-Za-z0-9]\+\)/\0 \1/g' Flyvector_survey_motifs.meme
```

## Cis-PB
The motif collation from the database was downloaded from [here](http://cisbp.ccbr.utoronto.ca/bulk.php) on 25 Feb 2020 as `Drosophila_melanogaster_2020_02_25_9_06_am.zip` containing matrix files and TF information in a zip file. File too large only metadata file `TF_Information.txt` added for future comparison when updating the MARS database.
The folder was unzipped and using a custom script `cisbp_converter.sh` the motifs were converted into a MEME format.

## Jaspar2020
Motif collation from the Jaspar database were downloaded in the meme format as a single file on 21 Feb 2020 from [here](http://jaspar.genereg.net/downloads/).
