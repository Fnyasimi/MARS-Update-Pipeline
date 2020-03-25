#  Data from _modENCODE_ and _modERN_ 
The peak files  from modERN and modENCODE were downloaded from [ENCODE experiments](https://www.encodeproject.org/search/?type=Experiment)
using the filters below;

  | Filter | Selection |
  |--------|:---------:|
  |Assay Type  |DNA binding|
  |Assay Title |TF ChIP-seq|
  |Project | modERN/modENCODE|
  |Target category |transcription factor|
  |Organism |Drosophila melanogaster|
  |file type |bed narrowpeak|
  
## Processing files
The links for the metadata and peak files for selected experiments were downloaded to;

  - modENCODE [`dm-modENCODE-files.txt`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/peak-files/dm/dm-modENCODE-files.txt)
  - modERN [`dm-modERN-files.txt`](https://github.com/Fnyasimi/MARS-Update-Pipeline/blob/master/peak-files/dm/dm-modERN-files.txt)
  
## Download metadata files
The metadata file for the above experiments were downloaded as below;
  ```
  curl -L $(head -n1 dm-modENCODE-files.txt) -o dm-modENCODE-metadata.tsv
  curl -L $(head -n1 dm-modERN-files.txt) -o dm-modERN-metadata.tsv
  ```
## Extracting IDR peaks from the metadata files
IDR peaks called using dm6 reference were selected. 
The metadata tsv and download links were extracted from the main metadata file using the commands below;
  ```
  IDR peaks metadata file...
  awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="dm6" ) {print$0}' dm-modENCODE-metadata.tsv > dm6-modENCODE-narrowpeaks-metadata.tsv
  awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="dm6" ) {print$0}' dm-modERN-metadata.tsv > dm6-modERN-narrowpeaks-metadata.tsv
  
  IDR peak file links...
  awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="dm6" ) {print$43}' dm-modENCODE-metadata.tsv > dm6-modENCODE-narrowpeaks.txt
  awk -F "\t" '( $3=="optimal IDR thresholded peaks" && $44=="dm6" ) {print$43}' dm-modERN-metadata.tsv > dm6-modERN-narrowpeaks.txt
  ```
## Download the peakfiles
Finally download the peak files to be used to extract the posneg as below;
- **_modENCODE_**
  ```
  mkdir modENCODE && cd modENCODE
  xargs -L 1 curl -O -L < ../dm6-modENCODE-narrowpeaks.txt
  cd -
  ```
- **_modERN_**
  ```
  mkdir modERN && cd modERN
  xargs -L 1 curl -O -L < ../dm6-modERN-narrowpeaks.txt
  cd -
  ```
