options(stringsAsFactors=F)
library(rjson)
library(jsonlite)
donor = read.delim('../icgc-dataset-1513210261808/donor.tsv', header=T, na.strings=c("", NULL))
donorIDs = unique(donor$submitted_donor_id)
# grep("TCGA-", donorIDs) 10163 patients are in TCGA cohorts

donor_biomarker = read.delim('../icgc-dataset-1513210261808/donor_biomarker.tsv', header=T, na.strings=c("",NULL))
donor_exposure = read.delim('../icgc-dataset-1513210261808/donor_exposure.tsv', header=T, na.strings=c("",NULL))
donor_family = read.delim('../icgc-dataset-1513210261808/donor_family.tsv', header=T, na.strings=c("",NULL))
donor_surgery = read.delim('../icgc-dataset-1513210261808/donor_surgery.tsv', header=T, na.strings=c("",NULL))
donor_therapy = read.delim('../icgc-dataset-1513210261808/donor_therapy.tsv', header=T, na.strings=c("",NULL))
sample = read.delim('../icgc-dataset-1513210261808/sample.tsv', header=T, na.strings=c("",NULL))
specimen = read.delim('../icgc-dataset-1513210261808/specimen.tsv', header=T, na.strings=c("",NULL))
protein_expression = read.delim('../icgc-dataset-1513210261808/protein_expression.tsv', header=T, na.strings=c("",NULL))

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
    write.csv(as.data.frame(subset(donor, oncoscape_disease==disease)), file = paste(disease,"/donor.csv",sep=""))
    # write.table(subset(donor_biomarker, submitted_donor_id==ID_by_disease[[disease]]), file = paste(disease,"/donor_biomarker.csv",sep=""))
    write.csv(as.data.frame(donor_exposure[which(donor_exposure$submitted_donor_id %in% ID_by_disease[[disease]]),]), file = paste(disease,"/donor_exposure.csv",sep=""))
    write.csv(as.data.frame(donor_family[which(donor_family$submitted_donor_id %in% ID_by_disease[[disease]]),]), file = paste(disease,"/donor_family.csv",sep=""))
    write.csv(as.data.frame(donor_surgery[which(donor_surgery$submitted_donor_id %in% ID_by_disease[[disease]]),]), file = paste(disease,"/donor_surgery.csv",sep=""))
    write.csv(as.data.frame(donor_therapy[which(donor_therapy$submitted_donor_id %in% ID_by_disease[[disease]]),]), file = paste(disease,"/donor_therapy.csv",sep=""))
}

for(disease in names(ID_by_disease)){  
    print(disease)
    # parse in each table
    donor_disease = read.csv(file = paste(disease,"/donor.csv",sep=""), header=T)
    ids = donor_disease$icgc_donor_id
    donor_disease = subset( donor_disease, select = -c(X, icgc_donor_id))
    cols = colnames(donor_disease)
    fields = lapply(cols, function(col){
        if(typeof(unlist(donor_disease[col])) == "integer"){
            data.frame('min'=min(donor_disease[col], na.rm=T), 'max'=max(donor_disease[col], na.rm=T))
        }else{
            unique(donor_disease[col])
        }  
    })
    donor_disease_o = donor_disease
    for (i in 1:length(cols)){ 
        if(typeof(unlist(donor_disease[cols[i]])) != "integer"){
            donor_disease[cols[i]][which(is.na(donor_disease[cols[i]])),] <- "HELLO" 
            donor_disease[cols[i]] = match(unlist(donor_disease[cols[i]]), unlist(fields[[i]]))-1
        }
    }
    res = {}
    new_fields = {}
    for (i in 1:length(fields)){
        new_fields[cols[i]] = fields[[i]]
    }
    res$ids = ids
    res$fields = new_fields
    res$values = donor_disease
    write_json(rjson:::toJSON(res), paste(disease,"/donor.json",sep=""))
    

    
}


