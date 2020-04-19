## Wrangling

The individual databases were manipulated by an assortment of tools to fit into the database.

These tools include;
- Sed
- Grep	
- Awk
- csvtool


Some of the commands implemented are as below:
```
## Add motif table
echo "INSERT INTO Motif VALUES" >> ../MARS-update.sql
csvtool -t TAB format '\t("%1","%2","%3","%4","%5"),\n' motif-table.tsv >> ../MARS-update.sql

## Add Matrix data table
echo "INSERT INTO Matrix(Motif_ID,Col,Row,Val) VALUES" >> ../MARS-update.sql
csvtool -t TAB format '\t("%1","%2","%3","%4"),\n' matrixdata-table.tsv >> ../MARS-update.sql

## Add ChIP-Seq table
echo "INSERT INTO ChIP_Seq VALUES" >> ../MARS-update.sql
csvtool -t TAB format '\t("%1","%2","%3","%4"),\n' chipseq-tables.tsv >> ../MARS-update.sql

## Add ChIP_Data table
echo "INSERT INTO ChIP_Data VALUES" >> ../MARS-update.sql
csvtool -t TAB format '\t("%1","%2","%3","%4"),\n' chipdata-table.tsv >> ../MARS-update.sql

## Add PBM table
echo "INSERT INTO PBM VALUES" >> ../MARS-update.sql
csvtool -t TAB format '\t("%1","%2","%3"),\n' pbm-table.tsv >> ../MARS-update.sql

## Add PBM_Data table
echo "INSERT INTO PBM_Data VALUES" >> ../MARS-update.sql
csvtool -t TAB format '\t("%1","%2","%3","%4"),\n' pbmdata-table.tsv >> ../MARS-update.sql
```
*__NB:__* At the end of each insertion the `,` should be changed to `;`.
