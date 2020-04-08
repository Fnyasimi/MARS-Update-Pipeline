# Human Motif Databases

The following databases were updated with recent data

## HOCOMOCO v11
Data from Hocomoco database full collection was downloaded from [here](https://hocomoco11.autosome.ru/downloads_v11) in transfac format then converted to meme format on 02 Mar 2020.

`transfac2meme HOCOMOCOv11_full_HUMAN_mono_transfac_format.txt > HOCOMOCOv11_full_HUMAN_mono.meme`

## Human Smile-seq
Data from the Smile seq was downloaded from [here](http://floresta.eead.csic.es/footprintdb/index.php?database=20&type=motif&page=1) on 02 Mar 2020 in transfac format then converted to meme format.

`transfac2meme SMILE-seq-human.transfac > SMILE-seq-human.meme`

## TF2DNA Database
Matrices from TF2DNA database were downloaded from [here](http://www.fiserlab.org/tf2dna_db/downloads.html) on 27 Feb 2020. These matrices were converted to meme format using `tf2dnaconverter.sh` script.

```
tar -xzvf human_tf2dna_matrices_symbols.tar.gz
tf2dnaconverter.sh human_tf2dna_matrices_symbols TF2DNA-human-motifs.meme
```

## SwissRegulon
Data from Swiss regulon was downloaded from [here](http://swissregulon.unibas.ch/sr/downloads) on 27 Feb 2020 in a transfac like format and converted to meme format.

`transfac2meme hg19_weight_matrices_v2 > Swissregulon-motifs_v2.meme`

## Cis-BP 
Human motifs from Cis-BP were downloaded from [here](http://cisbp.ccbr.utoronto.ca/bulk.php) on 26 Feb 2020 and converted to meme format using a custom script `cisbpconverter.sh`

## humanC2H2ZF 
Data was downloaded from [here](http://floresta.eead.csic.es/footprintdb/index.php?database=22&type=motif&page=1) on 26 Feb 2020 in transfac format then converted to meme format.

## JASPAR 2020
Data was downloaded from [here](http://jaspar.genereg.net/downloads/) on 26 Feb 2020 in the meme format `JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt`.

## Imported databases
Edited homer collection to get TF name using the command below;

```
sed -i 's/MOTIF\s\+\([-_A-Za-z0-9]\+\)[-()A-Za-z0-9\/\?_.,:\|\+`]\+/\0  \1/g' Homer_human.meme
```
