#  Data from _ENCODE_ and _GGR_ 
The peak files  from GGR and ENCODE were downloaded from [ENCODE experiments](https://www.encodeproject.org/search/?type=Experiment)
using the filters below;

  | Filter | Selection |
  |--------|:---------:|
  |Assay Type  |DNA binding|
  |Assay Title |TF ChIP-seq|
  |Project | GGR/ENCODE|
  |Target category |transcription factor|
  |Organism |Homo sapiens|
  |file type |bed narrowpeak|
  
## Processing files
The links for the metadata and peak files for selected experiments were downloaded to;

  - modENCODE [`hg-ENCODE-files.txt`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/peak-files/hg/hg-ENCODE-files.txt)
  - modERN [`hg-GGR-files.txt`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/peak-files/hg/hg-GGR-files.txt)
  
## Download metadata files
The metadata file for the above experiments were downloaded as below;
  ```
  curl -L $(head -n1 hg-ENCODE-files.txt) -o hg-ENCODE-metadata.tsv
  curl -L $(head -n1 hg-GGR-files.txt) -o hg-GGR-metadata.tsv
  ```
## Extracting IDR peaks from the metadata files
IDR peaks called using __*GRCh38*__ reference were selected and if not availablr then __*Hg19*__ were selected.

The narrowpeak files from ENCODE were extracted using a custom script [`encode-get.sh`](https://github.com/Fnyasimi/Msc_Project/blob/master/Scripts/encode-get.sh).

Narrowpeak files from GGR are still being processed

## Download the peakfiles
Finally download the peak files to be used to extract the posneg as below;
- **_ENCODE_**
  ```
  mkdir ENCODE && cd ENCODE
  xargs -L 1 curl -O -L < ../hg-ENCODE-narrowpeaks.txt
  cd -
  ```
- **_GGR_**
  ```
  mkdir GGR && cd GGR
  xargs -L 1 curl -O -L < ../hg-GGR-narrowpeaks.txt
  cd -
  ```
