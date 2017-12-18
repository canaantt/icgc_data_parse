export ICGC_RAW_DIR="/Users/jennyzhang/Desktop/canaantt/DataPull_v3/ICGC/icgc-dataset-1513210261808/"
export ICGC_WORKING="/Users/jennyzhang/Desktop/canaantt/DataPull_v3/ICGC/scripts"
cd $ICGC_RAW_DIR
#region PCAWG vs. TCGA
sed -n '1p' donor.tsv > ../processed/PCAWG/donor.txt
awk '$3 =="\PCAWG" {print $1, $2, $3, $4,$5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21}' donor.tsv >> ../processed/PCAWG/donor.txt
#endregion
cd $ICGC_WORKING