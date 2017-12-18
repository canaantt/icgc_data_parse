const csv = require('csv-load-sync');
const fs = require('fs');
const path = require("path");
const _ = require('underscore');
const jsonfile = require("jsonfile-promised");
const dirIn = '/Users/jennyzhang/Desktop/canaantt/DataPull_v3/ICGC/icgc-dataset-1513210261808';
const dirOut = '/Users/jennyzhang/Desktop/canaantt/DataPull_v3/ICGC/processed';
fs.readFile(dirIn + '/donor.tsv', function(err, value){
    if(err) console.log(err);
    console.log(value);
});

