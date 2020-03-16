Details on software used for paper 'Using loyalty card records and machine learning to understand how self-medication 
purchasing behaviours vary seasonally in England, 2012–2014'. The research also uses secure data which can be applied 
for via the Consumer Data Research Centre (cdrc.ac.uk). Contained here are the details of data and packages used. As 
secure data is used this documents only details the packages and functions used, as the exact code is protected by and NDA.

# Data 
Secure data can be applied for (and metadata is available): 
https://data.cdrc.ac.uk/product/high-street-retailer-data

Open license data are available: 
- National Statistics Postcode Lookup: https://data.gov.uk/dataset/7ec10db7-c8f4-4a40-8d82-8921935b4865/national-statistics-postcode-lookup-uk 
- Index of Access to Healthy Assets and Hazards: https://data.cdrc.ac.uk/dataset/access-to-healthy-assets-and-hazards-ahah
- Index of Multiple Deprivation: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
- Census Rural Urban Classification: https://www.nomisweb.co.uk/census/2011/key_statistics
- Output Area Classification: https://data.cdrc.ac.uk/dataset/cdrc-2x011-oac-geodata-pack-uk
- Climate, Hydrology and Ecology research Support System (CHESS) https://eip.ceh.ac.uk/chess/info#data
- Department for Environment Food & Rural Affairs (DEFRA) https://uk-air.defra.gov.uk/data/pcm-data 

# Analysis 
The software R was used to perform analysis https://www.r-project.org and the following packages (including their dependencies) were used: 
### data cleaning
readr, data.table, ncdf4, raster, rgdal, rgeos, sf, velox, matrixStats, corrplot, classInt, Matrix
### modelling 
caret, xgboost, pdp, ALEPlot, usdm 
### visualisation
ggplot2, ggalluvial, ggpubr
