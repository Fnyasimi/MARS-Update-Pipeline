# import modules
import pandas as pd

def getover5chip(tf_table,chipseq,chipdata,taxa_id):
    """Get TF with atleast over 5 chipseq experiments"""
    # load the chip data
    headers = ["ch_data_id","chip_id", "raw", "at_100"]
    chipdata_table = pd.read_csv(chipdata, sep = "\t", header = None, names = headers)

    # Count the chip seq expts
    counts = chipdata_table['chip_id'].value_counts().rename_axis('chip_id').reset_index(name='counts')
    # Get TF with over 5 chip expt
    over5chip = counts[counts['counts'] >= 5]

    # Load the chip table
    chip_headers = ["chip_id","TF_name", "TF_id", "DB_collection"]
    chip_table = pd.read_csv(chipseq, sep = "\t", header = None, names = chip_headers)
    chip_table = chip_table[['chip_id','TF_id']]

    # merge the table
    over5chip = pd.merge(over5chip, chip_table, how = 'inner', left_on = ['chip_id'], right_on = ['chip_id'])

    # Load the TF table and merge
    taxa_id = int(taxa_id)
    # define column headers
    tf_headers = ["TF_id","TF_name", "Alt_TF_name","TF_class_id","Taxonomic_id"]
    tf_table = pd.read_csv(tf_table, sep = ";", header = None, names=tf_headers)
    select_df = tf_table[tf_table["Taxonomic_id"] == taxa_id]
    select_df = select_df[['TF_id','TF_name']]
    over5chip = pd.merge(select_df,over5chip, how = 'inner', left_on = ['TF_id'], right_on = ['TF_id'])
    over5chip['counts'] = over5chip.groupby(['TF_id', 'TF_name'])['counts'].transform('sum')
    over5chip = over5chip.drop_duplicates(subset=['TF_id', 'TF_name'])
    over5chip = over5chip.sort_values(by=['counts'],ascending=False)
    return over5chip

def getOver5mot(tf_table,mot_table,taxa_id):
    """Get transcription factors with over 5 motifs"""
    
    taxa_id = int(taxa_id)
    # define column headers
    tf_headers = ["TF_id","TF_name", "Alt_TF_name","TF_class_id","Taxonomic_id"]
    tf_table = pd.read_csv(tf_table, sep = ";", header = None, names=tf_headers)
    select_df = tf_table[tf_table["Taxonomic_id"] == taxa_id]
    
    # Load motifs
    mot_headers = ["id", "motif_name", "TF_name", "Collection_db", "TF_id" ]
    motif_table = pd.read_csv(mot_table, sep = "\t", header = None, names = mot_headers)
    motif_table = motif_table.dropna()
    
    # select the orgnamisms TFs
    motif_table = motif_table[motif_table.TF_id.isin(select_df.TF_id)]
    
    # Get the counts of each representation
    counts = motif_table['TF_id'].value_counts().rename_axis('TF_id').to_frame('counts') # Tf_id becomes the index
    counts = motif_table['TF_id'].value_counts().rename_axis('TF_id').reset_index(name='counts')

    # Get TF with over 5 motifs
    over5motifs = counts[counts['counts'] >= 5]
    
    tf_table = select_df[["TF_id", "TF_name"]]
    # Change the int64 type to string in Tf_id
    tf_table['TF_id'] = tf_table.TF_id.astype('str')

    # Merge the file
    over5motifs = pd.merge(over5motifs, tf_table, how = 'inner', left_on = ['TF_id'], right_on = ['TF_id'])
    over5motifs = over5motifs.reindex(columns=["TF_id", "TF_name", "counts"])
    
    return over5motifs

def getmotlist(tf_name,tf_table,mot_table,taxa_id):
    """Get the different tf identifiers used in motif names"""
    
    taxa_id = int(taxa_id)
    # define column headers
    tf_headers = ["TF_id","TF_name", "Alt_TF_name","TF_class_id","Taxonomic_id"]
    tf_table = pd.read_csv(tf_table, sep = ";", header = None, names=tf_headers)
    select_df = tf_table[tf_table["Taxonomic_id"] == taxa_id]

    #get the ID to extract motif names
    tf_id = select_df[select_df["TF_name"] == tf_name]
    tf_id = tf_id["TF_id"].values[0]
    #print(tf_id)

    # Load motifs
    mot_headers = ["id", "motif_name", "TF_name", "Collection_db", "TF_id" ]
    motif_table = pd.read_csv(mot_table, sep = "\t", header = None, names = mot_headers)
    motif_table = motif_table.dropna()

    get = motif_table[motif_table["TF_id"] == tf_id]
    # Put the names in a list and retain the unique ones
    motlist = get["TF_name"].tolist()
    motlist = list(set(motlist))
    return motlist, tf_id

def getchiplist(tf_id,chipseq,chipdata,prefix=""):
    """Get all chip seq experiments for a given TF using TF id"""
    
    chip_headers = ["chip_id","TF_name", "TF_id", "DB_collection"]
    chip_table = pd.read_csv(chipseq, sep = "\t", header = None, names = chip_headers)
    
    # Filter to select only the required TF from chipseq expts
    select_chip = chip_table[chip_table["TF_id"]== tf_id]
    select_chip = select_chip["chip_id"].values[0]
    
    # load the chip data
    headers = ["ch_data_id","chip_id", "raw", "at_100"]
    chipdata_table = pd.read_csv(chipdata, sep = "\t", header = None, names = headers)
    chipdata_table = chipdata_table[chipdata_table['chip_id'] == select_chip]

    chiplist = chipdata_table["at_100"].tolist()
    chiplist

    # set the path correctly
    chiplist = [prefix + x for x in chiplist]
    
    return chiplist
