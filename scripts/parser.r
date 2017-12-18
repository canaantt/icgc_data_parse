options(stringsAsFactors=F)
donor = read.delim('../icgc-dataset-1513210261808/donor.tsv', header=T)
donorIDs = unique(donor$submitted_donor_id)
grep("TCGA-", donorIDs)

donor_biomarker = read.delim('../icgc-dataset-1513210261808/donor_biomarker.tsv', header=T)
donor_exposure = read.delim('../icgc-dataset-1513210261808/donor_exposure.tsv', header=T)
donor_family = read.delim('../icgc-dataset-1513210261808/donor_family.tsv', header=T)
donor_surgery = read.delim('../icgc-dataset-1513210261808/donor_surgery.tsv', header=T)
donor_therapy = read.delim('../icgc-dataset-1513210261808/donor_therapy.tsv', header=T)
sample = read.delim('../icgc-dataset-1513210261808/sample.tsv', header=T)
specimen = read.delim('../icgc-dataset-1513210261808/specimen.tsv', header=T)
protein_expression = read.delim('../icgc-dataset-1513210261808/protein_expression.tsv', header=T)

# Check all the donor-related dataframes' submitted_donor_id overlapping 
unique(donor_biomarker$submitted_donor_id %in% donor$submitted_donor_id) # TRUE
unique(donor_exposure$submitted_donor_id %in% donor$submitted_donor_id) # TRUE
unique(donor_family$submitted_donor_id %in% donor$submitted_donor_id) # TRUE
unique(donor_surgery$submitted_donor_id %in% donor$submitted_donor_id) # TRUE
unique(donor_therapy$submitted_donor_id %in% donor$submitted_donor_id) # TRUE
unique(sample$submitted_donor_id %in% donor$submitted_donor_id) # TRUE
unique(specimen$submitted_donor_id %in% donor$submitted_donor_id) # TRUE

# Check molecular dataframe 
unique(protein_expression$submitted_sample_id %in% sample$submitted_sample_id) # TRUE

### segregate each table by disease ###
donor$oncoscape_disease = unlist(lapply(donor$project_code,  function(x) strsplit(x, "-")[[1]][1]));
donor$oncoscape_country = unlist(lapply(donor$project_code,  function(x) strsplit(x, "-")[[1]][2]));
ID_by_disease = list()
setwd("../processed")
for(disease in unique(donor$oncoscape_disease)){
    ID_by_disease[[disease]] = donor$submitted_donor_id[which(donor$oncoscape_disease==disease)]
    dir.create(disease, showWarnings = FALSE)
}
# setwd("../scripts")
for(disease in names(ID_by_disease)){
    write.table(subset(donor, oncoscape_disease==disease), file = paste(disease,"/donor.csv",sep=""))
    # write.table(subset(donor_biomarker, submitted_donor_id==ID_by_disease[[disease]]), file = paste(disease,"/donor_biomarker.csv",sep=""))
    write.table(donor_exposure[which(donor_exposure$submitted_donor_id %in% ID_by_disease[[disease]]),], file = paste(disease,"/donor_exposure.csv",sep=""))
    write.table(donor_family[which(donor_family$submitted_donor_id %in% ID_by_disease[[disease]]),], file = paste(disease,"/donor_family.csv",sep=""))
    write.table(donor_surgery[which(donor_surgery$submitted_donor_id %in% ID_by_disease[[disease]]),], file = paste(disease,"/donor_surgery.csv",sep=""))
    write.table(donor_therapy[which(donor_therapy$submitted_donor_id %in% ID_by_disease[[disease]]),], file = paste(disease,"/donor_therapy.csv",sep=""))
}

