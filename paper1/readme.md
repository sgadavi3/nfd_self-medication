# nfd_self-medication
Code for paper ‘Using machine learning to investigate self-medication purchasing in England via high street retailer loyalty card data’. The research uses secure data which can be applied for via the Consumer Data Research Centre (cdrc.ac.uk). Contained in this repository are descriptions for cleaning data that are used as features in machine learning models and code to run the machine learning models (randomForest_XGBoost.R). As secure data is used, the model code (randomForest_XGBoost.R) is applied on the iris dataset. We cannot share the exact code due to NDA, however the code replicates the code applied to example data. 

### Data cleaning
Secure data can be applied for (and metadata is available): 
https://data.cdrc.ac.uk/product/high-street-retailer-data

Open license data are available: 
- National Statistics Postcode Lookup: https://data.gov.uk/dataset/7ec10db7-c8f4-4a40-8d82-8921935b4865/national-statistics-postcode-lookup-uk 
- Index of Access to Healthy Assets and Hazards: https://data.cdrc.ac.uk/dataset/access-to-healthy-assets-and-hazards-ahah
- Index of Multiple Deprivation: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
- Census Rural Urban Classification: https://www.nomisweb.co.uk/census/2011/key_statistics
- Output Area Classification: https://data.cdrc.ac.uk/dataset/cdrc-2x011-oac-geodata-pack-uk

Citation/ Copyright: 
Contains National Statistics data © Crown copyright and database right 2015;
Contains OS data © Crown copyright and database right 2015,2017;
Contains Royal Mail data © Royal Mail copyright and database right 2015;
Data provided by the ESRC Consumer Data Research Centre;
Contains LDC data 2017;
Contains NHS data 2017; 
Contains DEFRA data 2017;
Contains OSM data 2017. 

After variable testing (including census data and different aggregation levels of OAC), data was reduced to the following features (where each row corresponds to 1 LSOA):

- LSOA code
- AHAH inputs: gambling, fast food, pubs, off licenses, tobacconists, gp practices, emergency departments, dentists, pharmacies, leisure, green-space, particulate matter 10, nitrogen dioxide, sulphur dioxide. 
- IMD score
- RUC groups: A1, B1, C1, C2, D1, D2, E1, E2, 
- OAC groups: 1a, 1b, 1c, 2a, 2b, 2c, 2d, 3a, 3b, 3c, 3d, 4a, 4b, 4c, 5a, 5b, 6a, 6b, 7a, 7b, 7c, 7d, 8a, 8b, 8c, 8d
- Median age per LSOA (from secure data).

The target variable was the proportion of people purchasing products per LSOA (number of accounts that purchased a product per LSOA / total number of accounts per LSOA). 

### randomForest_XGBoost.R
Code for:
- data partition
- randomForest 
- XGBoost (including parameter searching using cross-validation
- feature importantance 
- partial dependency plots 
- model performance metrics
