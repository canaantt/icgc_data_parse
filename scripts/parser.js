const csv = require('csv-load-sync');
const fs = require('fs');
const { lstatSync, readdirSync } = require('fs');
const path = require('path');
const { join } = require('path')
const _ = require('underscore');
const jsonfile = require('jsonfile-promised');
const dirIn = '/Users/jennyzhang/Desktop/canaantt/DataPull_v3/ICGC/icgc-dataset-1513210261808';
const dirOut = '/Users/jennyzhang/Desktop/canaantt/DataPull_v3/ICGC/processed';

var isDirectory = lstatSync(dirOut).isDirectory()
var diseaseFolders = readdirSync(dirOut).filter(name => lstatSync(dirOut+'/'+name).isDirectory()).map(m => dirOut+'/'+m)

var clinicalFieldType = {
    'ID': 1,
    'REMOVE': 2,
    'NUMBER': 3,
    'STRING': 4
};
var clinicalField = {
    'donor': {
        'icgc_donor_id': clinicalFieldType.ID,
        'project_code': clinicalFieldType.STRING,
        'study_donor_involved_in': clinicalFieldType.STRING,
        'submitted_donor_id': clinicalFieldType.STRING,
        'donor_sex': clinicalFieldType.STRING,
        'donor_vital_status': clinicalFieldType.STRING,
        'disease_status_last_followup': clinicalFieldType.STRING,
        'donor_relapse_type': clinicalFieldType.STRING,
        'donor_age_at_diagnosis': clinicalFieldType.NUMBER,
        'donor_age_at_enrollment': clinicalFieldType.NUMBER,
        'donor_age_at_last_followup': clinicalFieldType.NUMBER,
        'donor_relapse_interval': clinicalFieldType.NUMBER,
        'donor_diagnosis_icd10': clinicalFieldType.STRING,
        'donor_tumour_staging_system_at_diagnosis': clinicalFieldType.STRING,
        'donor_tumour_stage_at_diagnosis': clinicalFieldType.STRING,
        'donor_tumour_stage_at_diagnosis_supplemental': clinicalFieldType.STRING,
        'donor_survival_time': clinicalFieldType.NUMBER,
        'donor_interval_of_last_followup': clinicalFieldType.NUMBER,
        'prior_malignancy': clinicalFieldType.STRING,
        'cancer_type_prior_malignancy': clinicalFieldType.STRING,
        'cancer_history_first_degree_relative': clinicalFieldType.STRING
    },
    'donor_exposure': {
        'icgc_donor_id': clinicalFieldType.STRING,                     
        'project_code': clinicalFieldType.STRING,
        'submitted_donor_id' : clinicalFieldType.STRING,               
        'exposure_type': clinicalFieldType.STRING,
        'exposure_intensity' : clinicalFieldType.STRING,             
        'tobacco_smoking_history_indicator': clinicalFieldType.STRING,
        'tobacco_smoking_intensity' : clinicalFieldType.NUMBER,        
        'alcohol_history': clinicalFieldType.STRING,
        'alcohol_history_intensity': clinicalFieldType.STRING
    },
    'donor_family': {
        'icgc_donor_id': clinicalFieldType.STRING,
        'project_code': clinicalFieldType.STRING,
        'submitted_donor_id': clinicalFieldType.STRING,
        'donor_has_relative_with_cancer_history': clinicalFieldType.STRING,
        'relationship_type': clinicalFieldType.STRING,
        'relationship_type_other': clinicalFieldType.STRING,
        'relationship_sex': clinicalFieldType.STRING,
        'relationship_age': clinicalFieldType.NUMBER,
        'relationship_disease_icd10': clinicalFieldType.STRING,
        'relationship_disease': clinicalFieldType.STRING
    },
    'donor_surgery': {
        'icgc_donor_id': clinicalFieldType.STRING,         
        'submitted_donor_id': clinicalFieldType.STRING,    
        'icgc_specimen_id': clinicalFieldType.STRING,
        'submitted_specimen_id' : clinicalFieldType.STRING,
        'project_code' : clinicalFieldType.STRING,         
        'procedure_interval': clinicalFieldType.NUMBER,
        'procedure_type' : clinicalFieldType.STRING,       
        'procedure_site' : clinicalFieldType.STRING,       
        'resection_status': clinicalFieldType.STRING
    },
    'donor_therapy':{
        'icgc_donor_id' : clinicalFieldType.STRING,                     
        'project_code': clinicalFieldType.STRING, 
        'submitted_donor_id' : clinicalFieldType.STRING,                
        'first_therapy_type': clinicalFieldType.STRING, 
        'first_therapy_therapeutic_intent' : clinicalFieldType.STRING,  
        'first_therapy_start_interval': clinicalFieldType.NUMBER, 
        'first_therapy_duration'  : clinicalFieldType.NUMBER,           
        'first_therapy_response': clinicalFieldType.STRING, 
        'second_therapy_type' : clinicalFieldType.STRING,               
        'second_therapy_therapeutic_intent': clinicalFieldType.STRING, 
        'second_therapy_start_interval' : clinicalFieldType.NUMBER,     
        'second_therapy_duration': clinicalFieldType.NUMBER, 
        'second_therapy_response' : clinicalFieldType.STRING,           
        'other_therapy': clinicalFieldType.STRING, 
        'other_therapy_response': clinicalFieldType.STRING
    }
    
};

diseaseFolders.forEach(diseaseFolder => {
    // console.log(diseaseFolder);
    fs.readdir(diseaseFolder, function(err, files) {
        if (err) { throw err; }
        var fileCoreNames = files.map(f => f.split('.')[0]);
        fileCoreNames.map(fileCoreName => {
            var data = csv(path.join(diseaseFolder, fileCoreName + '.csv'));
            console.log(fileCoreName);
            console.log(data[0]);
            // switch(fileCoreName) {
            //     case donor:
            //     case donor_exposure:
            //     case donor_family:
            //     case donor_surgery:
            //         var data = csv(path.join(diseaseFolder, fileCoreName, '.csv'));
            //         console.log(Object.keys(data));
            //     case donor_therapy:
            // }
            // fs.writeFileSync(, JSON.stringify(data));

        });
    });
});