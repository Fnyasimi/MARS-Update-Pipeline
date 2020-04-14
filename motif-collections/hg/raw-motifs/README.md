# Human Motif Databases

The following databases were updated with recent data

## HOCOMOCO v11
Data from Hocomoco database full collection was downloaded from [here](https://hocomoco11.autosome.ru/downloads_v11) in transfac format then converted to meme format on 02 Mar 2020.

```
transfac2meme HOCOMOCOv11_full_HUMAN_mono_transfac_format.txt > HOCOMOCOv11_full_HUMAN_mono.meme
sed -i 's/\(MOTIF\s[0-Z]\+_HUMAN.H11MO.[0-9].[ABCD]\)\s\([0-Z]\+\)_HUMAN/\1 \2/g' HOCOMOCOv11_full_HUMAN_mono.meme
```

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

Information about the motifs can be found in `TF_Information-hg.txt`.

## humanC2H2ZF 
Data was downloaded from [here](http://floresta.eead.csic.es/footprintdb/index.php?database=22&type=motif&page=1) on 26 Feb 2020 in transfac format then converted to meme format.

## JASPAR 2020
Data was downloaded from [here](http://jaspar.genereg.net/downloads/) on 26 Feb 2020 in the meme format `JASPAR2020_CORE_vertebrates_non-redundant_pfms_meme.txt`.

## Imported databases
Imported collections were edited as below to extract transcription factor names

**Homer Collection**
```
sed -i 's/MOTIF\s\+\([-_A-Za-z0-9]\+\)[-()A-Za-z0-9\/\?_.,:\|\+`]\+/\0  \1/g' Homer_human.meme
```
**3Dfootprint Collection**
```
sed -i 's/MOTIF 3Dfootprint_PROTEIN FEV/MOTIF 3Dfootprint_PROTEIN_FEV/g' 3D-footprint.meme
sed -i 's/MOTIF 3Dfootprint_ESTROGEN RECEPTOR/MOTIF 3Dfootprint_ESTROGEN_RECEPTOR/g' 3D-footprint.meme
sed -i 's/MOTIF\s\+3Dfootprint_\(\(Wilms_\?tumor_\?[0-9]\?\/\?\)\?[-0-Z:]\+\(_FEV\|_RECEPTOR\|_D3\)\?\)\([-()_0-Z]\+\)\?/\0 \1/g' 3D-footprint.meme
```
**Zlab Collection**
```
sed -i 's/MOTIF\s\([-A-Za-z0-9]\+\).[-A-Za-z0-9_]\+/\0 \1/g' Zlab_chipseq.meme
```
**Transfac Collection**
```
sed -i 's/\(MOTIF\sTransfac_[-A-Za-z0-9_\/]\+\)\sM[0-9]\+_\([-A-Za-z0-9_\/]\+\)/\1 \2/g' Transfac.meme
```
**Zhao Collection**
```
sed -i 's/\(MOTIF [a-z0-9]\+\(\.[v0-9]\+\)\?_\([-.0-Z]\+\(_[HLHLINCNDM]\+[-0-9]\+\)\?\)[_0-Z]\+\)\s\([0-Z]\+\)\?/\1 \3 \5/g' zhao2011.meme
```
**Guertin Collection**
```
sed -i 's/MOTIF\sGuertin_\([0-Z]\+\(_\(GTF\|FAM\|SPI\)[0-Z]\+\)\?\)[_0-9]\+/\0 \1/g' Guertin.meme
```
**Jolma Collection**
```
sed -i 's/MOTIF\s\([-0-Z]\+\)[_0-Z]\+/\0 \1/g' jolma2013.meme
```
**Wei Collection**
```
sed -i 's/MOTIF\s\(m-\)\?\([0-Z]\+\)\([,_0-Z]\+\)\?/\0 \2/g' wei2010_mouse_pbm.meme
sed -i 's/MOTIF\s\(m-\)\?\([0-Z]\+\)/\0 \2/g' wei2010_mouse_mws.meme
sed -i 's/MOTIF\s\(h-\)\?\([0-Z]\+\)/\0 \2/g' wei2010_human_mws.meme
```
**macIsaac Collection**
```
sed -i 's/MOTIF\s\([0-Z]\+\(_\(head\|box\)\)\?\)\([_0-9]\+\)\?/\0 \1/g' macisaac_themev1.meme
```
**POUR Collection**
```
sed -i 's/MOTIF\s\(\([0-Z]\+\)_disc[0-9]\+\)\s\([-_.0-Z:#]\+\)/MOTIF \1 \2  \3/g' Kheradpour-2013.meme
```
**Uniprobe Collection**
```
sed -i 's/\(MOTIF\s[0-Z_]\+\)\s\(\([-0-Z.]\+\)_[0-Z.]\+\)/\1 \3 \2/g' uniprobe_mouse.meme
```
