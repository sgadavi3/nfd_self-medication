#libaries
library(data.table)

#nspl
#clean nspl to england (downloaded form data.gov)
nspl <- fread('~/Dropbox/NSPL_MAY_2016_UK.csv', select = c(25,16,12))
nspl <- unique(nspl[substring(nspl$ctry, first = 1, last = 1) == 'E',])

#RUC
#rural urban classification 2011 (downloaded from nomis)
ruc <- fread('~/Dropbox/RUC11_LSOA11_EW.csv', select = c(1,3))
names(ruc) <- c('lsoa11', 'ruc')
df <- merge(nspl, ruc, 'lsoa11', all.x=T)

#IMD2015 
#index of multiple deprivation 2015 (downloaded from gov.uk)
imd <- fread('~/Dropbox/domains_of_index_of_multiple_deprivation.csv', select = c(1,6,8,10,12,14,16,18,20))
names(imd) <- c('lsoa11', 'imd_imd', 'imd_income', 'imd_employment', 'imd_education', 'imd_health', 'imd_crime', 'imd_housing', 'imd_environment')
df <- merge(df, imd, 'lsoa11')

#AHAH
#index of access to healthy assets and hazards domains (downloaded from data.cdrc.ac.uk)
#create dummy variable for decile 1 and 2 
ahd <- fread('~/Dropbox/ahahdomainsindex.csv', select = c(1:5))
names(ahd) <- c('lsoa11', 'ahah_retail', 'ahah_health', 'ahah_environ', 'ahah_ahah')
df <- merge(df, ahd, 'lsoa11', all.x=T)

#index of access to healthy assets and hazards individual measures
#create dummy variable for decile 9 and 10
ahi <- fread('~/Dropbox/ahahinputs.csv', select = c(2:16))
names(ahi) <- c('lsoa11', 'ahah_gamb', 'ahah_ffood', 'ahah_pubs', 'ahah_off', 'ahah_tobac', 'aha_gpp', 'ahah_ed', 'ahah_dent', 'ahah_pharm',
                'ahah_leis', 'ahah_no2', 'ahah_pm10', 'ahah_so2', 'ahah_green900')
df <- merge(df, ahi,'lsoa11',all.x=T)

#census2011
#ks102uk age structure
ks102uk <- fread('~/Dropbox/ks102uk_agestructure.csv')
ks102uk$ks102_age0to14 <- rowSums(ks102uk[,c(5:8)])
ks102uk$ks102_age14to64 <- rowSums(ks102uk[,c(9:16)]) 
ks102uk$ks102_age64plus <- rowSums(ks102uk[,c(17:20)]) 
ks102uk <- ks102uk[,c(3,23:25)]

#ks103uk marital status and civil partnership 
ks103uk <- fread('~/Dropbox/ks103uk_maritalstatusandcivilpartnershipstatus.csv', select = c(3,5:10))
names(ks103uk) <- c('geography code', 'ks103_single', 'ks103_married', 'ks103_samesexcp', 'ks103_separated', 'ks103_divorced', 'ks103_widowed')

#ks104uk living arrangements
ks104uk <- fread('~/Dropbox/ks104uk_livingarrangements.csv', select = c(3,5,8))
names(ks104uk) <- c('geography code', 'ks104_livingincoup', 'ks104_notlivingincoup')

#ks105 household composition 
ks105uk <- fread('~/Dropbox/ks105uk_householdcomposition.csv', select = c(3,5,8,21))
names(ks105uk) <- c('geography code', 'ks105_onepersonhouse', 'ks105_onefamilyhouse', 'ks105_otherhouse')

#ks105 household composition 
ks105uk <- fread('~/Dropbox/ks105uk_householdcomposition.csv', select = c(3,5,8,21))
names(ks105uk) <- c('geography code', 'ks105_onepersonhouse', 'ks105_onefamilyhouse', 'ks105_otherhouse')

#ks107uk lone parents households with dependent children 
ks107uk <- fread('~/Dropbox/ks107uk_loneparenthouseholdswithdependentchildren.csv', select = c(3,5:7))
names(ks107uk) <- c('geography code', 'ks107_loneparentemploypt', 'ks107_loneparentemployft', 'ks107_loneparentunemploy')

#ks201uk ethnic group 
ks201uk <- fread('~/Dropbox/ks201uk_ethnicgroup.csv', select = c(3,5:14))
names(ks201uk) <- c('geography code', 'ks201_white', 'ks201_gypsy', 'ks201_mixed', 'ks201_indian', 'ks201_pakistani', 'ks201_bangladeshi',
                    'ks201_chinese', 'ks201_otherasian', 'ks201_black', 'ks201_other')

#ks301uk health and provision of unpaid care 
ks301uk <- fread('~/Dropbox/ks301uk_healthandprovisionofunpaidcare.csv', select = c(3,5:7,11:19))
names(ks301uk) <- c('geography code', 'ks301_d2dlimitedlot', 'ks301_d2dlimitedlittle', 'ks301_d2dnotlimited', 'ks301_verygoodhealth', 
                    'ks301_goodhealth','ks301_fairhealth', 'ks301_badhealth', 'ks301_verybadhealth','ks301_noupcare', 'ks301_1to19upcare', 
                    'ks301_20to49upcare', 'ks301_50plusupcare') 

#ks401 dwelling household space and accomodation type
ks401uk <- fread('~/Dropbox/ks401uk_dwellingshouseholdspacesandaccomodationtype.csv', select = c(3,5:6,8:16))
names(ks401uk) <- c('geography code', 'ks401_unshared', 'ks401_shared', 'ks401_1usualres', 'ks401_0usualres', 'ks401_detached', 'ks401_semidetached',
                    'ks401_terraced', 'ks401_purposebuiltflats', 'ks401_convertedflats', 'ks401_commercialbuildingflats', 'ks401_caravan')

#ks402uk tenure
ks402uk <- fread('~/Dropbox/ks402uk_tenure.csv', select = c(3,6:8,10:11,13))
names(ks402uk) <- c('geography code', 'ks402_ownoutright', 'ks402_ownmortgage', 'ks402_rentcouncil', 'ks402_rentlandlord', 'ks401_rentother', 
                    'ks401_rentfree')

#ks404uk car or van availability 
ks404uk <- fread('~/Dropbox/ks404uk_carorvanavailability.csv', select = c(3,5:9))
names(ks404uk) <- c('geography code', 'ks404_nocars', 'ks404_1car', 'ks404_2car', 'ks404_3car', 'ks404_4carplus')

#ks405uk communal residents 
ks405uk <- fread('~/Dropbox/ks405uk_communalestablishresidents.csv', select = c(3,6:16))
names(ks405uk) <- c('geography code', 'ks405_nhshospital', 'ks405_nhsmentalhealth', 'ks405_nhsother', 'ks405_lachildrenshome', 'ks405_lacarehome',
                    'ks405_housingassociation', 'ks405_carehomewithnurse', 'ks405_carehomewithoutnurse', 'ks405_childrenshome', 'ks405_medicalother',
                    'ks405_other')

#ks501uk qualifications and students 
ks501uk <- fread('~/Dropbox/ks501uk_qualificationsandstudents.csv', select = c(3,5:11))
names(ks501uk) <- c('geography code', 'ks501_noqual', 'ks501_level1qual', 'ks501_level2qual', 'ks501_apprentqual', 'ks501_level3qual', 
                    'ks501_level4qual', 'ks501_otherqual')


#ks601uk economic activity
ks601uk <- fread('~/Dropbox/ks601uk_economicactivity.csv', select = c(3,7:11,13:17,20:21))
names(ks601uk) <- c('geography code', 'ks601_actptemp', 'ks601_actftemp', 'ks601_actsemp', 'ks601_actunemp', 'ks601_actftstu', 'ks601_inactret', 
                    'ks601_inactstu', 'ks601_inacthouse', 'ks601_inactlts', 'ks601_inactoth', 'ks601_unempnevwor', 'ks601_ltunemp')

#ks604uk hours worked 
ks604uk <- fread('~/Dropbox/ks604uk_hoursworked.csv', select = c(3,5:8))
names(ks604uk) <- c('geography code', 'ks604_pt15lessh', 'ks604_16to30h', 'ks604_31to48h', 'ks604_49plush')

#ks605 industry 
ks605uk <- fread('~/Dropbox/ks605uk_industry.csv', select = c(3,5:22))
names(ks605uk) <- c('geography code', 'ks605_agric', 'ks605_mining', 'ks605_manuf', 'ks605_energy', 'ks605_water', 'ks605_construct', 'ks605_whole',
                    'ks605_trans', 'ks605_accom', 'ks605_ict', 'ks605_finance', 'ks605_realest', 'ks605_profscien', 'ks605_admin', 'ks605_publicadmin',
                    'ks605_edu', 'ks605_health', 'ks605_other')

#ks608 occupation  
ks608uk <- fread('~/Dropbox/ks608uk_occupation.csv', select = c(3,5:13))
names(ks608uk) <- c('geography code', 'ks608_manager', 'ks608_prof', 'ks608_assprof', 'ks608_admin', 'ks608_skill', 'ks608_care', 'ks608_sales',
                    'ks608_process', 'ks608_element')

#ks611 nssec 
ks611uk <- fread('~/Dropbox/ks611uk_nssec.csv', select = c(3,5,8:17))
names(ks611uk) <- c('geography code', 'ks611_1', 'ks611_2', 'ks611_3', 'ks611_4', 'ks611_5', 'ks611_6', 'ks611_7', 'ks611_8', 'ks611_nevwork', 
                    'ks611_ltunemp', 'ks611_ftstud')

#create census data.table
census <- Reduce(function(...) merge(..., by = "geography code"), 
                 list(ks102uk, ks103uk, ks104uk, ks105uk, ks107uk, 
                      ks201uk, ks301uk, ks401uk, ks402uk, ks404uk, 
                      ks405uk, ks501uk, ks601uk, ks604uk, ks605uk, 
                      ks608uk, ks611uk))

#########COMPLETE DATA#########
df1 <- merge(df, census, by.x='lsoa11', by.y='geography code', all.x=T)
df1 <- df1[,c(1,4:163)]
for(i in c(1:14)) {df1[[i]] <-as.character(df1[[i]])}
for(i in c(1:14)) {df1[[i]] <-as.factor(df1[[i]])}
for(i in c(15:161)) {df1[[i]] <-as.numeric(df1[[i]])}

fwrite(df1, '~/Dropbox/census.csv', row.names=F)

