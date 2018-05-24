# nfd_self-medication
Code for paper Using new forms of data to explore self-medication.

###var_cleaning.R 
Code for cleaning data to go into machine learning models.
Data are available: 
- Index of Access to Healthy Assets and Hazards: http://data.cdrc.ac.uk 
- Index of Multiple Deprivation: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
- Census 2011 and Rural Urban Classification: https://www.nomisweb.co.uk/census/2011/key_statistics

###randomForest_XGBoost.R
Code is applied to iris dataset as paper uses secure data. 
Code for:
- One hot coding
- repeated cross-validation 
- data partition using createdatapartition
- randomForest within 'Caret' R pacakage (method = 'rf') 
- XGBoost within 'Caret' R pacakage (method = 'xgbtree') 
- feature importantance using varImp function and rank comparison using ggalluvial (via ggplot2)
- partial dependency plots 
- testing model performance on unseen data
- summary statistics 
