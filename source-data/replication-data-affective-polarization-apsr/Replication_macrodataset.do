/* Replication code for Reiljan, A., Garzia, D., Ferreira da Silva, F. & Trechsel, A. H. (2023) Patterns of affective polarization in the democratic world: comparing the polarized feelings towards parties and leaders. American Political Science Review

This code replicates the procedure to create the macro-level dataset. For a replication code of the data analysis please see replication_analysis.do*/



***Add elections from CSES Module 5 to CSES IMD dataset***

*set cd*

use cses5.dta, clear

keep if E1004=="NOR_2017" | E1004=="DEU_2017" | E1004=="HUN_2018" | E1004=="NZL_2017" | E1004=="ISL_2016" | E1004=="ISL_2017" | E1004=="AUT_2017" | E1004=="USA_2016" | E1004=="IRL_2016" | E1004=="MNE_2016" | E1004=="LTU_2016" | E1004=="ITA_2018" | E1004=="AUS_2019" | E1004=="GRC_2015" | E1004=="KOR_2016" | E1004=="TUR_2018"

replace E1004="GRC_2015_2" if E1004=="GRC_2015"
replace E1003=30002016 if E1004=="GRC_2015_2"

rename E1003 IMD1003
rename E1004 IMD1004
rename E1005 IMD1005
rename E1006 IMD1006
rename E1006_VDEM IMD1006_VDem
rename E1006_NAM IMD1006_NAM
rename E1008 IMD1008_YEAR
rename E1010_1 IMD1010_1
rename E3013_LH_PL IMD3002_LH_PL
rename E3013_LH_DC IMD3002_LH_DC
rename E6000_PR_1 IMD3002_PR_1
rename E6000_PR_2 IMD3002_PR_2


rename E3017_A IMD3008_A
rename E3017_B IMD3008_B
rename E3017_C IMD3008_C
rename E3017_D IMD3008_D
rename E3017_E IMD3008_E
rename E3017_F IMD3008_F
rename E3017_G IMD3008_G
rename E3017_H IMD3008_H
rename E3017_I IMD3008_I

rename E3018_A IMD3009_A
rename E3018_B IMD3009_B
rename E3018_C IMD3009_C
rename E3018_D IMD3009_D
rename E3018_E IMD3009_E
rename E3018_F IMD3009_F
rename E3018_G IMD3009_G
rename E3018_H IMD3009_H
rename E3018_I IMD3009_I

rename E5000_A IMD5000_A
rename E5000_B IMD5000_B
rename E5000_C IMD5000_C
rename E5000_D IMD5000_D
rename E5000_E IMD5000_E
rename E5000_F IMD5000_F
rename E5000_G IMD5000_G
rename E5000_H IMD5000_H
rename E5000_I IMD5000_I

rename E5001_A IMD5001_A
rename E5001_B IMD5001_B
rename E5001_C IMD5001_C
rename E5001_D IMD5001_D
rename E5001_E IMD5001_E
rename E5001_F IMD5001_F
rename E5001_G IMD5001_G
rename E5001_H IMD5001_H
rename E5001_I IMD5001_I

rename E5003_A IMD5003_A
rename E5003_B IMD5003_B
rename E5003_C IMD5003_C
rename E5003_D IMD5003_D
rename E5003_E IMD5003_E
rename E5003_F IMD5003_F
rename E5003_G IMD5003_G
rename E5003_H IMD5003_H
rename E5003_I IMD5003_I

rename E3019_A IMD3007_A
rename E3019_B IMD3007_B
rename E3019_C IMD3007_C
rename E3019_D IMD3007_D
rename E3019_E IMD3007_E
rename E3019_F IMD3007_F
rename E3019_G IMD3007_G
rename E3019_H IMD3007_H
rename E3019_I IMD3007_I

rename E2020 IMD3006
rename E5078 IMD5058_1
rename E5050 IMD5049
rename E5051 IMD5048
rename E5090_1 IMD5050_1
rename E3024_1 IMD3005_1
rename E3024_3 IMD3005_3
rename E3024_4 IMD3005_4


rename E5026_1 IMD5025_1
rename E5026_3 IMD5025_3

recode IMD3002_LH_PL (999992/9999999=.) // missing values on vote choice lower house
recode IMD3002_LH_DC (999988/9999999=.) // missing values on vote choice lower house


save "cses5.dta", replace

***Add data from World Bank's Worldwide Governance Indicators (WGI) Dataset***
use wgidataset.dta, clear

generate IMD1006_NAM = countryname 
replace IMD1006_NAM = "United States of America" if IMD1006_NAM == "United States" 
replace IMD1006_NAM = "Republic of Korea" if IMD1006_NAM == "Korea, Rep." 
replace IMD1006_NAM = "Great Britain" if IMD1006_NAM == "United Kingdom" 
replace IMD1006_NAM = "Turkey" if IMD1006_NAM == "Türkiye" 
replace IMD1006_NAM = "Taiwan" if IMD1006_NAM == "Taiwan, China" 
replace IMD1006_NAM = "Slovakia" if IMD1006_NAM == "Slovak Republic" 
recode year (2000=2001) if IMD1006_NAM=="Bulgaria" |  IMD1006_NAM=="Denmark" | IMD1006_NAM=="Thailand"  | IMD1006_NAM=="Norway" | IMD1006_NAM=="Peru" | IMD1006_NAM=="Poland" | IMD1006_NAM=="Taiwan"
recode year (1996=1997) if IMD1006_NAM=="Canada" | IMD1006_NAM=="Lithuania" | IMD1006_NAM=="Mexico" | IMD1006_NAM=="Norway" | IMD1006_NAM=="Poland" | IMD1006_NAM=="Great Britain"
recode year (1998=1999) if IMD1006_NAM=="Chile" | IMD1006_NAM=="Iceland" | IMD1006_NAM=="Switzerland"
generate IMD1008_YEAR = year
save wgidataset.dta, replace

***Add Polity V data***
import excel "p5v2018.xls", sheet("p5v2018") firstrow clear
rename country IMD1006_NAM
rename year IMD1008_YEAR
replace IMD1006_NAM = "Great Britain" if IMD1006_NAM == "United Kingdom" 
replace IMD1006_NAM = "Republic of Korea" if IMD1006_NAM == "Korea South" 
replace IMD1006_NAM = "Slovakia" if IMD1006_NAM == "Slovak Republic" 
replace IMD1006_NAM = "United States of America" if IMD1006_NAM =="United States                   "
destring durable, gen(Age_of_democracy)
keep IMD* Age_of_democracy
save p5v2018.dta, replace

***Appending/merging with CSES IMD file***
use cses_imd.dta, clear
append using "cses5.dta", keep(IMD*)

merge m:m IMD1006_NAM IMD1008_YEAR using p5v2018.dta, keepusing(Age_of_democracy)
drop _merge
merge m:m IMD1006_NAM IMD1008_YEAR using wgidataset.dta, keepusing(gee)

rename gee Gov_effectiveness_0_5
replace Gov_effectiveness_0_5=Gov_effectiveness_0_5+2.5

*manually input data for most recent election years by adding one year to the previously available data entry
replace Age_of_democracy=151 if IMD1006_NAM == "United States of America" & IMD1008_YEAR==2016
replace Age_of_democracy=118 if IMD1006_NAM == "Australia" & IMD1008_YEAR==2019
*manually input data for Iceland, for which Polity 5 did not produce data
replace Age_of_democracy=55 if IMD1004=="ISL_1999"
replace Age_of_democracy=59 if IMD1004=="ISL_2003"
replace Age_of_democracy=63 if IMD1004=="ISL_2007"
replace Age_of_democracy=65 if IMD1004=="ISL_2009"
replace Age_of_democracy=69 if IMD1004=="ISL_2013"
replace Age_of_democracy=72 if IMD1004=="ISL_2016"
replace Age_of_democracy=73 if IMD1004=="ISL_2017"

gen Countryyear=subinstr(IMD1004, "_", "", .)
replace Countryyear="GRC2015_2" if IMD1004=="GRC_2015_2"

*keep only elections included in the study
keep if Countryyear=="AUS1996" | Countryyear=="AUS2004" | Countryyear=="AUS2007" | Countryyear=="AUS2013" | Countryyear=="AUS2019" | Countryyear=="AUT2013" | Countryyear=="AUT2017" | Countryyear=="BGR2014" | Countryyear=="CAN1997" | Countryyear=="CAN2008" | Countryyear=="HRV2007" | Countryyear=="CZE1996" | Countryyear=="CZE2006" | Countryyear=="CZE2010" | Countryyear=="CZE2013" | Countryyear=="DNK1998" | Countryyear=="DNK2007" | Countryyear=="EST2011" | Countryyear=="FIN2007" | Countryyear=="FIN2011" | Countryyear=="FIN2015" | Countryyear=="FRA2007" | Countryyear=="DEU1998" | Countryyear=="DEU2005" | Countryyear=="DEU2009" | Countryyear=="DEU2013" | Countryyear=="DEU2017" | Countryyear=="GBR1997" | Countryyear=="GBR2015" | Countryyear=="GRC2009" | Countryyear=="GRC2012" | Countryyear=="GRC2015_2" | Countryyear=="GRC2015" | Countryyear=="HUN1998" | Countryyear=="HUN2018" | Countryyear=="ISL1999" | Countryyear=="ISL2007" | Countryyear=="ISL2009" | Countryyear=="ISL2013" | Countryyear=="ISL2016" | Countryyear=="ISL2017" | Countryyear=="IRL2007" | Countryyear=="IRL2011" | Countryyear=="IRL2016" | Countryyear=="ISR1996" | Countryyear=="ISR2013" | Countryyear=="ITA2018" | Countryyear=="JPN1996" | Countryyear=="JPN2007" | Countryyear=="JPN2013" | Countryyear=="LVA2010" | Countryyear=="LVA2011" | Countryyear=="LVA2014" | Countryyear=="LTU2016" | Countryyear=="MEX1997" | Countryyear=="MEX2009" | Countryyear=="MEX2012" | Countryyear=="MNE2012" | Countryyear=="MNE2016" | Countryyear=="NLD1998" | Countryyear=="NLD2006" | Countryyear=="NLD2010" | Countryyear=="NZL1996" | Countryyear=="NZL2008" | Countryyear=="NZL2011" | Countryyear=="NZL2014" | Countryyear=="NZL2017" | Countryyear=="NOR1997" | Countryyear=="NOR2005" | Countryyear=="NOR2009" | Countryyear=="NOR2013" | Countryyear=="NOR2017" | Countryyear=="PER2011" | Countryyear=="PER2016" | Countryyear=="POL1997" | Countryyear=="POL2005" | Countryyear=="POL2007" | Countryyear=="POL2011" | Countryyear=="PRT2002" | Countryyear=="PRT2009" | Countryyear=="PRT2015" | Countryyear=="ROU2012" | Countryyear=="SRB2012" | Countryyear=="SVK2010" | Countryyear=="SVK2016" | Countryyear=="SVN1996" | Countryyear=="SVN2008" | Countryyear=="SVN2011" | Countryyear=="ZAF2009" | Countryyear=="ZAF2014" | Countryyear=="KOR2000" | Countryyear=="KOR2008" | Countryyear=="KOR2012" | Countryyear=="KOR2016" | Countryyear=="ESP1996" | Countryyear=="ESP2000" | Countryyear=="ESP2008" | Countryyear=="SWE1998" | Countryyear=="SWE2006" | Countryyear=="SWE2014" | Countryyear=="CHE1999" | Countryyear=="CHE2007" | Countryyear=="CHE2011" | Countryyear=="TWN1996" | Countryyear=="TWN2012" | Countryyear=="TUR2011" | Countryyear=="TUR2015" | Countryyear=="TUR2018" | Countryyear=="USA1996" | Countryyear=="USA2008" | Countryyear=="USA2012" | Countryyear=="USA2016" | Countryyear=="URY2009"

*drop unused variables
drop IMD1001 IMD1002_VER IMD1002_DOI IMD1005 IMD1006 IMD1006_UN IMD1006_UNAlpha2 IMD1006_REG IMD1006_OECD IMD1006_EU IMD1006_VDem IMD1007 IMD1008_MOD_1 IMD1008_MOD_2 IMD1008_MOD_3 IMD1008_MOD_4 IMD1008_RES IMD1009 IMD1010_2 IMD1010_3 IMD1011_M IMD1011_D IMD1011_Y IMD1011_1 IMD1011_2 IMD1012_M IMD1012_D IMD1012_Y IMD1012_1 IMD1012_2 IMD1013_M IMD1013_D IMD1013_Y IMD1014_1 IMD1014_2 IMD1015 IMD1016_1 IMD1016_2 IMD1016_3 IMD2001_1 IMD2001_2 IMD2001_GG IMD2001_GS IMD2001_GBB IMD2001_GX IMD2001_GY IMD2001_GZ IMD2002 IMD2003 IMD2004 IMD2005 IMD2005_1 IMD2005_2 IMD2006 IMD2007 IMD2008 IMD2010 IMD2011 IMD2012_1 IMD2012_2 IMD2013 IMD2014 IMD2015_ISCO_88 IMD2015_ISCO_08 IMD2016 IMD2017 IMD2018 IMD2019_1 IMD2019_2 IMD2020 IMD2021_ISCO_88 IMD2021_ISCO_08 IMD2022 IMD2023 IMD2024 IMD2025 IMD2026 IMD2027 IMD3001 IMD3001_PR_1 IMD3001_PR_2 IMD3001_LH IMD3001_UH IMD3001_TS IMD3002_PR_1 IMD3002_PR_2 IMD3002_UH_PL IMD3002_UH_DC_2 IMD3002_UH_DC_3 IMD3002_UH_DC_4 IMD3002_OUTGOV IMD3002_VS_1 IMD3002_LR_CSES IMD3002_LR_MARPOR IMD3002_IF_CSES IMD3003_PR_1 IMD3003_PR_2 IMD3003_LH IMD3003_UH IMD3004_PR_1 IMD3004_PR_2 IMD3004_LH_PL IMD3004_LH_DC IMD3004_UH_PL IMD3004_UH_DC_1 IMD3004_UH_DC_2 IMD3004_UH_DC_3 IMD3005_2 IMD3006 IMD3010 IMD3011 IMD3012 IMD3013_1 IMD3013_2 IMD3013_3 IMD3014 IMD3015_1 IMD3015_2 IMD3015_3 IMD3015_4 IMD3015_A IMD3015_B IMD3015_C IMD3015_D IMD3100_LR_CSES IMD3100_LR_MARPOR IMD3100_IF_CSES IMD5002_A IMD5002_B IMD5002_C IMD5002_D IMD5002_E IMD5002_F IMD5002_G IMD5002_H IMD5002_I IMD5004_A IMD5004_B IMD5004_C IMD5004_D IMD5004_E IMD5004_F IMD5004_G IMD5004_H IMD5004_I IMD5005_A IMD5005_B IMD5005_C IMD5005_D IMD5005_E IMD5005_F IMD5005_G IMD5005_H IMD5005_I IMD5006_1 IMD5006_2 IMD5007 IMD5008_1 IMD5008_2 IMD5009_1 IMD5009_2 IMD5011_A IMD5011_B IMD5011_C IMD5011_D IMD5011_E IMD5011_F IMD5011_G IMD5011_H IMD5011_I IMD5012_A IMD5012_B IMD5012_C IMD5012_D IMD5012_E IMD5012_F IMD5012_G IMD5012_H IMD5012_I IMD5013 IMD5014 IMD5016_1 IMD5016_2 IMD5016_3 IMD5016_4 IMD5017_1 IMD5017_2 IMD5017_3 IMD5017_4 IMD5018_1 IMD5018_2 IMD5018_3 IMD5018_4 IMD5021_1 IMD5021_2 IMD5021_3 IMD5021_4 IMD5022_1 IMD5022_2 IMD5022_3 IMD5022_4 IMD5024_1 IMD5024_2 IMD5024_3 IMD5025_1 IMD5025_2 IMD5025_3 IMD5026_1 IMD5026_2 IMD5027 IMD5028 IMD5029_A IMD5029_B IMD5029_C IMD5029_D IMD5029_E IMD5029_F IMD5029_G IMD5029_H IMD5029_I IMD5030 IMD5031_A IMD5031_B IMD5031_C IMD5031_D IMD5031_E IMD5031_F IMD5031_G IMD5031_H IMD5031_I IMD5032_1 IMD5032_2 IMD5032_3 IMD5032_4 IMD5033 IMD5034_1 IMD5034_2 IMD5034_3 IMD5035 IMD5036_1 IMD5036_2 IMD5036_3 IMD5038 IMD5040_1 IMD5040_2 IMD5041_1 IMD5041_2 IMD5042_1 IMD5042_2 IMD5044 IMD5045_1 IMD5045_2 IMD5045_3 IMD5046_1 IMD5046_2 IMD5046_3 IMD5046_4 IMD5048  IMD5050_2 IMD5050_3 IMD5051_1 IMD5051_2 IMD5051_3 IMD5052_1 IMD5052_2 IMD5052_3 IMD5053_1 IMD5053_2 IMD5053_3 IMD5054_1 IMD5054_2 IMD5054_3 IMD5055_1 IMD5055_2 IMD5055_3 IMD5056_1 IMD5056_2 IMD5056_3 IMD5057_1 IMD5057_2 IMD5057_3 IMD5058_2 IMD5059_1 IMD5059_2 IMD5061 IMD5100_A IMD5100_B IMD5100_C IMD5100_D IMD5100_E IMD5100_F IMD5100_G IMD5100_H IMD5100_I IMD5101_A IMD5101_B IMD5101_C IMD5101_D IMD5101_E IMD5101_F IMD5101_G IMD5101_H IMD5101_I IMD5102_A IMD5102_B IMD5102_C IMD5102_D IMD5102_E IMD5102_F IMD5102_G IMD5102_H IMD5102_I IMD5103_A IMD5103_B IMD5103_C IMD5103_D IMD5103_E IMD5103_F IMD5103_G IMD5103_H IMD5103_I

***# Data cleaning***
*recoding missing values
recode IMD5001_A-IMD5001_I (0=.) (70/.=.) // missing values lower house election vote shares
recode IMD3007_* (11/99=.) // missing values ideology variables
recode IMD3008_A-IMD3008_I (11/.=.) // missing values party like-dislike scores
recode IMD3009_A-IMD3009_I (11/.=.) // missing values leader like-dislike scores
recode IMD5003_A-IMD5003_I (0=.) (70/.=.) // missing values upper house vote shares
recode IMD3005_1 (7/9=.) // missing values on PID
recode IMD3005_3 (9999988/9999999=.) // missing values on PID
recode IMD3005_4 (7/9=.) // missing values on PID
replace IMD3002_LH_PL=IMD3002_UH_DC_1 if IMD1004=="JPN_2007"
replace IMD3002_LH_PL=IMD3002_UH_DC_1 if IMD1004=="JPN_2013"
recode IMD3002_LH_PL (9999988/9999999=.) // missing values on vote choice lower house
recode IMD3002_LH_DC (9999988/9999999=.) // missing values on vote choice lower house
recode IMD5058_1 (997/999=.) // missing values on ENEP

*recoding PID strength
recode IMD3005_4 (1=3) (3=1)

***Data preparation***
*manually input ENEP for TWN_1996
replace IMD5058_1=2.52 if IMD1004=="TWN_1996"

*manually input ENEP for USA_2016
replace IMD5058_1=2.12 if IMD1004=="USA_2016"

*remove weight for DK07 (see CSES codebook)*
replace IMD1010_1=1 if IMD1004=="DNK_2007"

****Handling cases where two parties that were both asked in the like-dislike item (IMD3008_) actually ran together in the election and were assigned a joint vote share (see CSES documentation): junior coalition partner's voters/partisans are treated as voters/partisans of the major coalition partner*** 

replace IMD3008_G=. if IMD1004=="HRV_2007"
replace IMD3009_G=. if IMD1004=="HRV_2007"
recode IMD3005_3 (1910008=.) if IMD1004=="HRV_2007"
recode IMD3002_LH_PL (1910019=1910007) if IMD1004=="HRV_2007"

recode IMD3005_3 (6200003=6200011) if IMD1004=="PRT_2015"

recode IMD3005_3 (4990001=4990011) if IMD1004=="MNE_2012"

recode IMD3005_3 (2760003=2760002) if IMD1003 == 27601998
recode IMD3005_3 (2760001=2760002) if IMD1003 == 27601998
recode IMD3002_LH_PL (2760001=2760002) if IMD1003 == 27601998
replace IMD3008_C=. if IMD1003 == 27601998
replace IMD5001_B=IMD5001_B+IMD5001_C if IMD1003 == 27601998
recode IMD3005_3 (2760003=2760002) if IMD1003 == 27602005
recode IMD3002_LH_PL (2760001=2760002) if IMD1003 == 27602005
replace IMD3008_F=. if IMD1003 == 27602005
replace IMD5001_B=IMD5001_B+IMD5001_F if IMD1003 == 27602005
recode IMD3005_3 (2760003=2760002) if IMD1003 == 27602009
recode IMD3002_LH_PL (2760001=2760002) if IMD1003 == 27602009
replace IMD3008_F=. if IMD1003 == 27602009
replace IMD5001_A=IMD5001_A+IMD5001_F if IMD1003 == 27602009
recode IMD3005_3 (2760003=2760002) if IMD1003 == 27602013
recode IMD3005_3 (2760001=2760002) if IMD1003 == 27602013
recode IMD3002_LH_PL (2760001=2760002) if IMD1003 == 27602013
replace IMD3008_E=. if IMD1003 == 27602013
replace IMD5001_A=IMD5001_A+IMD5001_E if IMD1003 == 27602013
recode IMD3005_3 (276007=276001) if IMD1003 == 27602017
replace IMD3008_G=. if IMD1003 == 27602017
replace IMD5001_A=IMD5001_A+IMD5001_G if IMD1003 == 27602017

*Fixing issues with party vote shares: inconsistencies between vote shares provided in CSES and official election results; missing vote shares in CSES*
replace IMD5001_G=1.58 if IMD1003 == 27602005

replace IMD5001_G=3.1 if IMD1004=="HUN_1998"

replace IMD5001_A = 40.21 if IMD1004=="PRT_2002"
replace IMD5001_B = 37.79 if IMD1004=="PRT_2002"
replace IMD5001_C = 8.72 if IMD1004=="PRT_2002"
replace IMD5001_D = 6.94 if IMD1004=="PRT_2002"
replace IMD5001_E = 2.74 if IMD1004=="PRT_2002"

replace IMD5001_A = 38.5 if IMD1004=="PRT_2015"
replace IMD5001_B = 32.31 if IMD1004=="PRT_2015"
replace IMD5001_C = 10.19 if IMD1004=="PRT_2015"
replace IMD5001_D = 8.25 if IMD1004=="PRT_2015"

replace IMD5001_A = 36.62 if IMD1004=="HRV_2007"
replace IMD5001_B = 31.33 if IMD1004=="HRV_2007"
replace IMD5001_C = 6.79 if IMD1004=="HRV_2007"
replace IMD5001_D = 6.53 if IMD1004=="HRV_2007"
replace IMD5001_E = 4.08 if IMD1004=="HRV_2007"
replace IMD5001_F = 3.5 if IMD1004=="HRV_2007"
replace IMD5001_H = 1.8 if IMD1004=="HRV_2007"
replace IMD5001_I = 1.54 if IMD1004=="HRV_2007"

replace IMD5001_A = 32.02 if IMD1004=="AUS_2013"
replace IMD5001_B = 33.38 if IMD1004=="AUS_2013"
replace IMD5001_C = 8.65 if IMD1004=="AUS_2013"
replace IMD5001_E = 13.21 if IMD1004=="AUS_2013"

replace IMD5001_G = 3.41 if IMD1004=="FRA_2007"

replace IMD5001_A = 32.2 if IMD1004=="HUN_1998"
replace IMD5001_B = 28.2 if IMD1004=="HUN_1998"
replace IMD5001_C = 13.8 if IMD1004=="HUN_1998"
replace IMD5001_D = 7.9 if IMD1004=="HUN_1998"
replace IMD5001_E = 5.5 if IMD1004=="HUN_1998"
replace IMD5001_F = . if IMD1004=="HUN_1998"
replace IMD5001_H = 3.1 if IMD1004=="HUN_1998"

replace IMD5001_A = 32.76 if IMD1004=="JPN_1996"
replace IMD5001_B = 28.04 if IMD1004=="JPN_1996"
replace IMD5001_C = 16.1 if IMD1004=="JPN_1996"
replace IMD5001_D = 13.08 if IMD1004=="JPN_1996"
replace IMD5001_E = 6.38 if IMD1004=="JPN_1996"
replace IMD5001_F = 1.05 if IMD1004=="JPN_1996"

replace IMD5001_A = 39.48 if IMD1004=="JPN_2007"
replace IMD5001_B = 28.08 if IMD1004=="JPN_2007"
replace IMD5001_C = 13.18 if IMD1004=="JPN_2007"
replace IMD5001_D = 7.48 if IMD1004=="JPN_2007"
replace IMD5001_E = 4.47 if IMD1004=="JPN_2007"

replace IMD5001_A = 34.68 if IMD1004=="JPN_2013"
replace IMD5001_B = 13.4 if IMD1004=="JPN_2013"
replace IMD5001_C = 9.68 if IMD1004=="JPN_2013"
replace IMD5001_D = 8.93 if IMD1004=="JPN_2013"
replace IMD5001_E = 11.94 if IMD1004=="JPN_2013"
replace IMD5001_F = 14.22 if IMD1004=="JPN_2013"
replace IMD5001_G = 1.77 if IMD1004=="JPN_2013"
replace IMD5001_H = 2.36 if IMD1004=="JPN_2013"

replace IMD5001_A = 40.93 if IMD1004=="DEU_1998"
replace IMD5001_B = 35.14 if IMD1004=="DEU_1998"
replace IMD5001_C = 6.7 if IMD1004=="DEU_1998"
replace IMD5001_D = 6.25 if IMD1004=="DEU_1998"
replace IMD5001_E = 5.1 if IMD1004=="DEU_1998"

replace IMD5001_G=3.2 if IMD1004=="SVN_1996"

replace IMD5001_A = 43.87 if IMD1004=="ESP_2008"
replace IMD5001_B = 39.94 if IMD1004=="ESP_2008"
replace IMD5001_C = 3.03 if IMD1004=="ESP_2008"
replace IMD5001_D = 1.19 if IMD1004=="ESP_2008"
replace IMD5001_E = 1.13 if IMD1004=="ESP_2008"
replace IMD5001_F = 3.77 if IMD1004=="ESP_2008"
replace IMD5001_G = 0.83 if IMD1004=="ESP_2008"
replace IMD5001_H = 0.68 if IMD1004=="ESP_2008"
replace IMD5001_I = 1.19 if IMD1004=="ESP_2008"

replace IMD5001_D=6.57 if IMD1004=="TUR_2011"

replace IMD5001_A = 48.03 if IMD1004=="USA_2016"
replace IMD5001_B = 49.11 if IMD1004=="USA_2016"


*Fixing issues with the set of parties/leaders included: excluding regional parties that were not included in the survey for all respondents; and (usually very small) parties for which no survey respondent reported to identify with/vote for*
replace IMD3008_E=. if IMD1004=="GBR_1997" 
replace IMD3008_E=. if IMD1004=="GBR_2015" 
replace IMD3009_D=. if IMD1004=="GBR_1997" 
replace IMD3009_G=. if IMD1004=="GBR_2015"

replace IMD3008_H=. if IMD1004=="PRT_2015"
replace IMD3008_E=. if IMD1004=="PRT_2015"
replace IMD3008_F=. if IMD1004=="PRT_2002"
replace IMD3008_F=. if IMD1004=="PRT_2015"
replace IMD3008_G=. if IMD1004=="PRT_2015"
replace IMD3009_H=. if IMD1004=="PRT_2015"
replace IMD3009_E=. if IMD1004=="PRT_2015"
replace IMD3009_F=. if IMD1004=="PRT_2015"
replace IMD3009_G=. if IMD1004=="PRT_2015"

replace IMD3008_I=. if IMD1004=="JPN_2013"

replace IMD3008_F=. if IMD1004=="MEX_2012"

recode IMD3002_LH_PL (3480006=.) if IMD1004=="HUN_1998"

replace IMD3008_E=. if IMD1004=="ZAF_2014"
replace IMD3008_F=. if IMD1004=="ZAF_2014"
replace IMD3008_G=. if IMD1004=="ZAF_2014"
replace IMD3009_H=. if IMD1004=="ZAF_2014"
replace IMD3008_I=. if IMD1004=="ZAF_2014"

recode IMD3005_3 (5280026=.) if IMD1004=="NLD_1998"

recode IMD3005_3 (6160051=.) if IMD1004=="POL_2005"
recode IMD3005_3 (6160003=.) if IMD1004=="POL_2005"
replace IMD3007_F=. if IMD1004=="POL_2005"
replace IMD3007_G=. if IMD1004=="POL_2005"

replace IMD3008_E=. if IMD1004=="AUT_2013"
replace IMD3008_F=. if IMD1004=="AUT_2013"
replace IMD3008_G=. if IMD1004=="AUT_2013"
replace IMD3008_H=. if IMD1004=="AUT_2013"
replace IMD3008_I=. if IMD1004=="AUT_2013"

replace IMD3008_E=. if IMD1004=="TUR_2011" | IMD1004=="TUR_2015"
replace IMD3008_F=. if IMD1004=="TUR_2011" | IMD1004=="TUR_2015"
replace IMD3008_G=. if IMD1004=="TUR_2011" | IMD1004=="TUR_2015"
replace IMD3009_H=. if IMD1004=="TUR_2011" | IMD1004=="TUR_2015"
replace IMD3008_I=. if IMD1004=="TUR_2011" | IMD1004=="TUR_2015"

replace IMD3009_H=. if IMD1004=="NZL_2008"

replace IMD3009_G=. if IMD1004=="NZL_2011"

replace IMD3008_F=. if IMD1004=="LVA_2010"
replace IMD3009_F=. if IMD1004=="LVA_2010"
replace IMD3009_F=. if IMD1004=="LVA_2011"

replace IMD3009_E=. if IMD1004=="MEX_2009"

replace IMD3008_G=. if IMD1004=="MNE_2012"
replace IMD3008_H=. if IMD1004=="MNE_2012"
replace IMD3008_I=. if IMD1004=="MNE_2012"

*Disregarding measures of PID strength for countries where IMD3005_2 was missing for all respondents (see CSES documentation)*
replace IMD3005_4=. if Countryyear=="AUT2013" | Countryyear=="CAN1997" | Countryyear=="DNK2007" | Countryyear=="ISL2013" | IMD1006_NAM=="Ireland" | IMD1006_NAM=="Israel" | Countryyear=="MEX2012" | Countryyear=="NZL1996" | Countryyear=="NOR2005" | Countryyear=="NOR2009" | Countryyear=="NOR2013" | Countryyear=="NOR2017" | Countryyear=="PER2016" | Countryyear=="ROU2012" | Countryyear=="CHE2007" | Countryyear=="TWN2012" | Countryyear=="KOR2016" | Countryyear=="SVN2008" | Countryyear=="SVN2011"

*Ensuring we only consider parties for which both party and leader thermometers are simultanously available*
global party A B C D E F G H I
foreach n of global party {
	bysort IMD1003: egen m_IMD3008_`n'=mean(IMD3008_`n')
	bysort IMD1003: egen m_IMD3009_`n'=mean(IMD3009_`n')
}

bysort IMD1003: gen completeA=(m_IMD3008_A!=.&m_IMD3009_A!=.)
bysort IMD1003: gen completeB=(m_IMD3008_B!=.&m_IMD3009_B!=.)
bysort IMD1003: gen completeC=(m_IMD3008_C!=.&m_IMD3009_C!=.)
bysort IMD1003: gen completeD=(m_IMD3008_D!=.&m_IMD3009_D!=.)
bysort IMD1003: gen completeE=(m_IMD3008_E!=.&m_IMD3009_E!=.)
bysort IMD1003: gen completeF=(m_IMD3008_F!=.&m_IMD3009_F!=.)
bysort IMD1003: gen completeG=(m_IMD3008_G!=.&m_IMD3009_G!=.)
bysort IMD1003: gen completeH=(m_IMD3008_H!=.&m_IMD3009_H!=.)
bysort IMD1003: gen completeI=(m_IMD3008_I!=.&m_IMD3009_I!=.)


***# PartisanAPI_Party***
global party A B C D E F G H I
foreach n of global party {
    gen PID_`n' = 1 if IMD3005_3==IMD5000_`n'
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_PID_`n'=wtmean(IMD3008_`n') if PID_`n'==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_1_`n'=wtmean(IMD3008_`n') if PID_A==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_2_`n'=wtmean(IMD3008_`n') if PID_B==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_3_`n'=wtmean(IMD3008_`n') if PID_C==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_4_`n'=wtmean(IMD3008_`n') if PID_D==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_5_`n'=wtmean(IMD3008_`n') if PID_E==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_6_`n'=wtmean(IMD3008_`n') if PID_F==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_7_`n'=wtmean(IMD3008_`n') if PID_G==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_8_`n'=wtmean(IMD3008_`n') if PID_H==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_9_`n'=wtmean(IMD3008_`n') if PID_I==1 & complete`n'==1, weight(IMD1010_1)
}


foreach n of global party {
	gen SHARE_`n'=IMD5001_`n'/100 if complete`n'==1
}

egen share_sum=rowtotal(SHARE_A-SHARE_I)

foreach n of global party {
	gen norm_`n'=SHARE_`n'/share_sum if complete`n'==1
}

gen SHARE_PID=.

foreach n of global party {
	replace SHARE_PID=SHARE_`n' if PID_`n'==1  & complete`n'==1
}

gen norm_PID=SHARE_PID/share_sum


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: egen m_tmp_1_`n' = wtmean(m_PARTY_PID_A-m_PARTY_1_`n') if PID_A==1, weight(IMD1010_1)
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: egen m_tmp_2_`n' = wtmean(m_PARTY_PID_B-m_PARTY_2_`n') if PID_B==1, weight(IMD1010_1)
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: egen m_tmp_3_`n' = wtmean(m_PARTY_PID_C-m_PARTY_3_`n') if PID_C==1, weight(IMD1010_1)
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: egen m_tmp_4_`n' = wtmean(m_PARTY_PID_D-m_PARTY_4_`n') if PID_D==1, weight(IMD1010_1)

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: egen m_tmp_5_`n' = wtmean(m_PARTY_PID_E-m_PARTY_5_`n') if PID_E==1, weight(IMD1010_1)

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: egen m_tmp_6_`n' = wtmean(m_PARTY_PID_F-m_PARTY_6_`n') if PID_F==1, weight(IMD1010_1)

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: egen m_tmp_7_`n' = wtmean(m_PARTY_PID_G-m_PARTY_7_`n') if PID_G==1, weight(IMD1010_1)

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: egen m_tmp_8_`n' = wtmean(m_PARTY_PID_H-m_PARTY_8_`n') if PID_H==1, weight(IMD1010_1)

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: egen m_tmp_9_`n' = wtmean(m_PARTY_PID_I-m_PARTY_9_`n') if PID_I==1, weight(IMD1010_1)

}


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: replace m_tmp_1_`n'=norm_`n'/(1-norm_PID)*m_tmp_1_`n'
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: replace m_tmp_2_`n'=norm_`n'/(1-norm_PID)*m_tmp_2_`n'
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: replace m_tmp_3_`n'=norm_`n'/(1-norm_PID)*m_tmp_3_`n'
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: replace m_tmp_4_`n'=norm_`n'/(1-norm_PID)*m_tmp_4_`n'

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: replace m_tmp_5_`n'=norm_`n'/(1-norm_PID)*m_tmp_5_`n'

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: replace m_tmp_6_`n'=norm_`n'/(1-norm_PID)*m_tmp_6_`n'

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: replace m_tmp_7_`n'=norm_`n'/(1-norm_PID)*m_tmp_7_`n'

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: replace m_tmp_8_`n'=norm_`n'/(1-norm_PID)*m_tmp_8_`n'

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: replace m_tmp_9_`n'=norm_`n'/(1-norm_PID)*m_tmp_9_`n'

}

foreach n of numlist 1/9 {
egen tmp_`n'=rowtotal(m_tmp_`n'_*)
recode tmp_`n' (0=.)
}

foreach n of numlist 1/9 {
    bysort IMD1003: gen api_`n' = (tmp_`n'*norm_PID)
}

egen api=rowtotal(api_*)
recode api (0=.)

*calculating in-party evaluations
foreach n of global party {
	replace m_PARTY_PID_`n'=m_PARTY_PID_`n'*norm_`n' if complete`n'==1
}

egen total_inparty =rowtotal(m_PARTY_PID_*)
recode total_inparty (0=.)
egen tag = tag(total_inparty)
bysort IMD1003: egen Average_inparty_partisans=total(total_inparty) if tag==1

drop m_tmp* m_PARTY_* tmp_* tag total_*

***# PartisanAPI_Leader***

foreach n of global party {
	bysort IMD1003: egen m_LEADER_PID_`n'=wtmean(IMD3009_`n') if PID_`n'==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_1_`n'=wtmean(IMD3009_`n') if PID_A==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_2_`n'=wtmean(IMD3009_`n') if PID_B==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_3_`n'=wtmean(IMD3009_`n') if PID_C==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_4_`n'=wtmean(IMD3009_`n') if PID_D==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_5_`n'=wtmean(IMD3009_`n') if PID_E==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_6_`n'=wtmean(IMD3009_`n') if PID_F==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_7_`n'=wtmean(IMD3009_`n') if PID_G==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_8_`n'=wtmean(IMD3009_`n') if PID_H==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_9_`n'=wtmean(IMD3009_`n') if PID_I==1 & complete`n'==1, weight(IMD1010_1)
}


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: egen m_tmp_1_`n' = wtmean(m_LEADER_PID_A-m_LEADER_1_`n') if PID_A==1, weight(IMD1010_1)
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: egen m_tmp_2_`n' = wtmean(m_LEADER_PID_B-m_LEADER_2_`n') if PID_B==1, weight(IMD1010_1)
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: egen m_tmp_3_`n' = wtmean(m_LEADER_PID_C-m_LEADER_3_`n') if PID_C==1, weight(IMD1010_1)
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: egen m_tmp_4_`n' = wtmean(m_LEADER_PID_D-m_LEADER_4_`n') if PID_D==1, weight(IMD1010_1)

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: egen m_tmp_5_`n' = wtmean(m_LEADER_PID_E-m_LEADER_5_`n') if PID_E==1, weight(IMD1010_1)

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: egen m_tmp_6_`n' = wtmean(m_LEADER_PID_F-m_LEADER_6_`n') if PID_F==1, weight(IMD1010_1)

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: egen m_tmp_7_`n' = wtmean(m_LEADER_PID_G-m_LEADER_7_`n') if PID_G==1, weight(IMD1010_1)

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: egen m_tmp_8_`n' = wtmean(m_LEADER_PID_H-m_LEADER_8_`n') if PID_H==1, weight(IMD1010_1)

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: egen m_tmp_9_`n' = wtmean(m_LEADER_PID_I-m_LEADER_9_`n') if PID_I==1, weight(IMD1010_1)

}


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: replace m_tmp_1_`n'=norm_`n'/(1-norm_PID)*m_tmp_1_`n'
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: replace m_tmp_2_`n'=norm_`n'/(1-norm_PID)*m_tmp_2_`n'
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: replace m_tmp_3_`n'=norm_`n'/(1-norm_PID)*m_tmp_3_`n'
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: replace m_tmp_4_`n'=norm_`n'/(1-norm_PID)*m_tmp_4_`n'

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: replace m_tmp_5_`n'=norm_`n'/(1-norm_PID)*m_tmp_5_`n'

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: replace m_tmp_6_`n'=norm_`n'/(1-norm_PID)*m_tmp_6_`n'

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: replace m_tmp_7_`n'=norm_`n'/(1-norm_PID)*m_tmp_7_`n'

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: replace m_tmp_8_`n'=norm_`n'/(1-norm_PID)*m_tmp_8_`n'

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: replace m_tmp_9_`n'=norm_`n'/(1-norm_PID)*m_tmp_9_`n'

}

foreach n of numlist 1/9 {
egen tmp_`n'=rowtotal(m_tmp_`n'_*)
recode tmp_`n' (0=.)
}

foreach n of numlist 1/9 {
    bysort IMD1003: gen apil_`n' = (tmp_`n'*norm_PID)
}

egen apil=rowtotal(apil_*)
recode apil (0=.)

*calculating in-party evaluations
foreach n of global party {
	replace m_LEADER_PID_`n'=m_LEADER_PID_`n'*norm_`n' if complete`n'==1
}

egen total_inleader =rowtotal(m_LEADER_PID_*)
recode total_inleader (0=.)
egen tag = tag(total_inleader)
bysort IMD1003: egen Average_inleader_partisans=total(total_inleader) if tag==1

drop m_LEADER_* m_tmp_* tmp_* SHARE_* share* norm* tag total_*

***# VoterAPI_Party***
global party A B C D E F G H I
foreach n of global party {
    gen VOTE_`n' = 1 if IMD3002_LH_PL==IMD5000_`n' 
	replace VOTE_`n' = 1 if IMD3002_LH_DC==IMD5000_`n' & IMD1006_NAM=="Australia" | IMD3002_LH_DC==IMD5000_`n' & IMD1006_NAM=="Canada" | IMD3002_LH_DC==IMD5000_`n' & IMD1006_NAM=="Ireland" | IMD3002_LH_DC==IMD5000_`n' & IMD1003==41002000 | IMD3002_LH_DC==IMD5000_`n' & IMD1006_NAM=="Great Britain" | IMD3002_LH_DC==IMD5000_`n' & IMD1006_NAM=="United States of America" | IMD3002_LH_DC==IMD5000_`n' & IMD1003==25002007 | IMD3002_LH_DC==IMD5000_`n' & IMD1004=="ROU_2012" | IMD3002_LH_DC==IMD5000_`n' & IMD1004=="TWN_1996" | IMD3002_LH_DC==IMD5000_`n' & IMD1006_NAM=="Mexico" 
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_VOTE_`n'=wtmean(IMD3008_`n') if VOTE_`n'==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_1_`n'=wtmean(IMD3008_`n') if VOTE_A==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_2_`n'=wtmean(IMD3008_`n') if VOTE_B==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_3_`n'=wtmean(IMD3008_`n') if VOTE_C==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_4_`n'=wtmean(IMD3008_`n') if VOTE_D==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_5_`n'=wtmean(IMD3008_`n') if VOTE_E==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_6_`n'=wtmean(IMD3008_`n') if VOTE_F==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_7_`n'=wtmean(IMD3008_`n') if VOTE_G==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_8_`n'=wtmean(IMD3008_`n') if VOTE_H==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_PARTY_9_`n'=wtmean(IMD3008_`n') if VOTE_I==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_VOTE_`n'=mean(VOTE_`n') if complete`n'==1
}

foreach n of global party {
	gen SHARE_`n'=IMD5001_`n'/100 if complete`n'==1 & m_VOTE_`n'!=.
}

egen share_sum=rowtotal(SHARE_A-SHARE_I)

foreach n of global party {
	gen norm_`n'=SHARE_`n'/share_sum if complete`n'==1
}

gen SHARE_VOTE=.

foreach n of global party {
	replace SHARE_VOTE=SHARE_`n' if VOTE_`n'==1  & complete`n'==1
}

gen norm_VOTE=SHARE_VOTE/share_sum


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: egen m_tmp_1_`n' = wtmean(m_PARTY_VOTE_A-m_PARTY_1_`n') if VOTE_A==1, weight(IMD1010_1)
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: egen m_tmp_2_`n' = wtmean(m_PARTY_VOTE_B-m_PARTY_2_`n') if VOTE_B==1, weight(IMD1010_1)
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: egen m_tmp_3_`n' = wtmean(m_PARTY_VOTE_C-m_PARTY_3_`n') if VOTE_C==1, weight(IMD1010_1)
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: egen m_tmp_4_`n' = wtmean(m_PARTY_VOTE_D-m_PARTY_4_`n') if VOTE_D==1, weight(IMD1010_1)

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: egen m_tmp_5_`n' = wtmean(m_PARTY_VOTE_E-m_PARTY_5_`n') if VOTE_E==1, weight(IMD1010_1)

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: egen m_tmp_6_`n' = wtmean(m_PARTY_VOTE_F-m_PARTY_6_`n') if VOTE_F==1, weight(IMD1010_1)

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: egen m_tmp_7_`n' = wtmean(m_PARTY_VOTE_G-m_PARTY_7_`n') if VOTE_G==1, weight(IMD1010_1)

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: egen m_tmp_8_`n' = wtmean(m_PARTY_VOTE_H-m_PARTY_8_`n') if VOTE_H==1, weight(IMD1010_1)

}

global pI A B C D E F G H 
foreach n of global pI {	
	
    bysort IMD1003: egen m_tmp_9_`n' = wtmean(m_PARTY_VOTE_I-m_PARTY_9_`n') if VOTE_I==1, weight(IMD1010_1)

}


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: replace m_tmp_1_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_1_`n'
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: replace m_tmp_2_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_2_`n'
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: replace m_tmp_3_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_3_`n'
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: replace m_tmp_4_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_4_`n'

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: replace m_tmp_5_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_5_`n'

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: replace m_tmp_6_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_6_`n'

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: replace m_tmp_7_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_7_`n'

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: replace m_tmp_8_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_8_`n'

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: replace m_tmp_9_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_9_`n'

}

foreach n of numlist 1/9 {
egen tmp_`n'=rowtotal(m_tmp_`n'_*)
recode tmp_`n' (0=.)
}

foreach n of numlist 1/9 {
    bysort IMD1003: gen apiv_`n' = (tmp_`n'*norm_VOTE)
}

egen apiv=rowtotal(apiv_*)
recode apiv (0=.)

foreach n of global party {
	replace m_PARTY_VOTE_`n'=m_PARTY_VOTE_`n'*norm_`n' if complete`n'==1
}

*calculating in-party evaluations
egen total_inparty =rowtotal(m_PARTY_VOTE_*)
recode total_inparty (0=.)
egen tag = tag(total_inparty)
bysort IMD1003: egen Average_inparty_voters=total(total_inparty) if tag==1

drop m_tmp_* tmp_* m_PARTY_* tag total_*

***# VoterAPI_Leader***
global party A B C D E F G H I

foreach n of global party {
	bysort IMD1003: egen m_LEADER_VOTE_`n'=wtmean(IMD3009_`n') if VOTE_`n'==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_1_`n'=wtmean(IMD3009_`n') if VOTE_A==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_2_`n'=wtmean(IMD3009_`n') if VOTE_B==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_3_`n'=wtmean(IMD3009_`n') if VOTE_C==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_4_`n'=wtmean(IMD3009_`n') if VOTE_D==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_5_`n'=wtmean(IMD3009_`n') if VOTE_E==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_6_`n'=wtmean(IMD3009_`n') if VOTE_F==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_7_`n'=wtmean(IMD3009_`n') if VOTE_G==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_8_`n'=wtmean(IMD3009_`n') if VOTE_H==1 & complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: egen m_LEADER_9_`n'=wtmean(IMD3009_`n') if VOTE_I==1 & complete`n'==1, weight(IMD1010_1)
}

global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: egen m_tmp_1_`n' = wtmean(m_LEADER_VOTE_A-m_LEADER_1_`n') if VOTE_A==1, weight(IMD1010_1)
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: egen m_tmp_2_`n' = wtmean(m_LEADER_VOTE_B-m_LEADER_2_`n') if VOTE_B==1, weight(IMD1010_1)
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: egen m_tmp_3_`n' = wtmean(m_LEADER_VOTE_C-m_LEADER_3_`n') if VOTE_C==1, weight(IMD1010_1)
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: egen m_tmp_4_`n' = wtmean(m_LEADER_VOTE_D-m_LEADER_4_`n') if VOTE_D==1, weight(IMD1010_1)

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: egen m_tmp_5_`n' = wtmean(m_LEADER_VOTE_E-m_LEADER_5_`n') if VOTE_E==1, weight(IMD1010_1)

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: egen m_tmp_6_`n' = wtmean(m_LEADER_VOTE_F-m_LEADER_6_`n') if VOTE_F==1, weight(IMD1010_1)

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: egen m_tmp_7_`n' = wtmean(m_LEADER_VOTE_G-m_LEADER_7_`n') if VOTE_G==1, weight(IMD1010_1)

}

global pH A B C D E F G I
foreach n of global pH {	
	
    bysort IMD1003: egen m_tmp_8_`n' = wtmean(m_LEADER_VOTE_H-m_LEADER_8_`n') if VOTE_H==1, weight(IMD1010_1)

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: egen m_tmp_9_`n' = wtmean(m_LEADER_VOTE_I-m_LEADER_9_`n') if VOTE_I==1, weight(IMD1010_1)

}


global pA B C D E F G H I
foreach n of global pA {
    bysort IMD1003: replace m_tmp_1_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_1_`n'
	
}

global pB A C D E F G H I
foreach n of global pB {
	
    bysort IMD1003: replace m_tmp_2_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_2_`n'
	
}

global pC A B D E F G H I
foreach n of global pC {
	
    bysort IMD1003: replace m_tmp_3_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_3_`n'
	
}

global pD A B C E F G H I
foreach n of global pD {
	
    bysort IMD1003: replace m_tmp_4_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_4_`n'

}

global pE A B C D F G H I
foreach n of global pE {
	
    bysort IMD1003: replace m_tmp_5_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_5_`n'

}

global pF A B C D E G H I
foreach n of global pF {	
	
    bysort IMD1003: replace m_tmp_6_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_6_`n'

}

global pG A B C D E F H I
foreach n of global pG {
		
    bysort IMD1003: replace m_tmp_7_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_7_`n'

}

global pH A B C D E F G I
foreach n of global pH {	
    bysort IMD1003: replace m_tmp_8_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_8_`n'

}

global pI A B C D E F G H
foreach n of global pI {	
	
    bysort IMD1003: replace m_tmp_9_`n'=norm_`n'/(1-norm_VOTE)*m_tmp_9_`n'

}

foreach n of numlist 1/9 {
egen tmp_`n'=rowtotal(m_tmp_`n'_*)
recode tmp_`n' (0=.)
}

foreach n of numlist 1/9 {
    bysort IMD1003: gen apivl_`n' = (tmp_`n'*norm_VOTE)
}

egen apivl=rowtotal(apivl_*)
recode apivl (0=.)

*calculating in-party evaluations
foreach n of global party {
	replace m_LEADER_VOTE_`n'=m_LEADER_VOTE_`n'*norm_`n' if complete`n'==1
}

egen total_inleader =rowtotal(m_LEADER_VOTE_*)
recode total_inleader (0=.)
egen tag = tag(total_inleader)
bysort IMD1003: egen Average_inleader_voters=total(total_inleader) if tag==1

drop m_tmp_* tmp_* m_LEADER_* tag total_*

***Perceived ideological polarization: LR_perceived***
global party A B C D E F G H I
foreach n of global party {
	bysort IMD1003: egen LR_`n'=wtmean(IMD3007_`n') if complete`n'==1, weight(IMD1010_1)
}

foreach n of global party {
	bysort IMD1003: gen LR_w`n'=LR_`n'*norm_`n' if complete`n'==1
}

egen m_LRw=rowtotal(LR_w*)
recode m_LRw (0=.)

foreach n of global party {
	bysort IMD1003: gen LRiLRa_`n'=LR_`n'-m_LRw if complete`n'==1
	replace LRiLRa_`n'=LRiLRa_`n'/5
	replace LRiLRa_`n'=LRiLRa_`n'*LRiLRa_`n'
}

foreach n of global party {
	bysort IMD1003: gen LR_Polarization_`n'=(norm_`n'*100)*LRiLRa_`n' if complete`n'==1
}

egen LR_Polarization_perceived=rowtotal(LR_Polarization_*)
replace LR_Polarization_perceived=sqrt(LR_Polarization_perceived)
recode LR_Polarization_perceived (0=.)

*collapsing into an aggregate dataset
collapse (mean) api_* apil_* apiv_* apivl_* Gov_effectiveness_0_5 LR_Polarization_perceived Age_of_democracy IMD1008_YEAR IMD3005_1 IMD3005_4 IMD5058_1 Average* (first) IMD1006_NAM Countryyear, by(IMD1003)
egen PartisanAPI_Party=rowtotal(api_*)
egen PartisanAPI_Leader=rowtotal(apil_*)
egen VoterAPI_Party=rowtotal(apiv_*)
egen VoterAPI_Leader=rowtotal(apivl_*)
recode PartisanAPI_Party PartisanAPI_Leader VoterAPI_Party VoterAPI_Leader (0=.)

*Removing cases where partisan identity follow-up question (IMD3005_2) was not asked, resulting in smaller partisan groups which are not directly comparable to the rest of the cases; and cases with other data inconsistencies with regard to partisanship variable, rendering the polarization scores unreliable*
replace PartisanAPI_Party=. if Countryyear=="AUT2013" | Countryyear=="CAN1997" | Countryyear=="CHE2007" | Countryyear=="IRL2007" | Countryyear=="IRL2011" | Countryyear=="ISL2013" | Countryyear=="ISR1996" | Countryyear=="ISR2013" | Countryyear=="MEX2012" | Countryyear=="NOR2005" | Countryyear=="NOR2009" | Countryyear=="NOR2013" | Countryyear=="NOR2017" | Countryyear=="NZL1996" | Countryyear=="PER2016" | Countryyear=="ROU2012" | Countryyear=="SVN1996" | Countryyear=="SVN2008" | Countryyear=="SVN2011" | Countryyear=="TWN2012"
replace PartisanAPI_Leader=. if Countryyear=="AUT2013" | Countryyear=="CAN1997" | Countryyear=="CHE2007" | Countryyear=="IRL2007" | Countryyear=="IRL2011" | Countryyear=="ISL2013" | Countryyear=="ISR1996" | Countryyear=="ISR2013" | Countryyear=="MEX2012" | Countryyear=="NOR2005" | Countryyear=="NOR2009" | Countryyear=="NOR2013" | Countryyear=="NOR2017" | Countryyear=="NZL1996" | Countryyear=="PER2016" | Countryyear=="ROU2012" | Countryyear=="SVN1996" | Countryyear=="SVN2008" | Countryyear=="SVN2011" | Countryyear=="TWN2012"

gen Average_outparty_partisans=Average_inparty_partisans-PartisanAPI_Party
gen Average_outleader_partisans=Average_inleader_partisans-PartisanAPI_Leader
gen Average_outparty_voters=Average_inparty_voters-VoterAPI_Party
gen Average_outleader_voters=Average_inleader_voters-VoterAPI_Leader

gen Leader_Party_APIratio_voters = VoterAPI_Leader/VoterAPI_Party
gen Leader_Party_APIratio_partisans = PartisanAPI_Leader/PartisanAPI_Party
rename IMD3005_1 PID_noleaners
rename IMD3005_4 PID_strength
rename IMD1006_NAM Country
rename IMD5058_1 EffectiveN_electoral
rename IMD1008_YEAR Year
gen Year_0=Year-1996
gen Countrycode=. 
replace Countrycode=24 if Country=="Australia"
replace Countrycode=1 if Country=="Austria"
replace Countrycode=2 if Country=="Bulgaria"
replace Countrycode=25 if Country=="Canada"
replace Countrycode=3 if Country=="Croatia"
replace Countrycode=4 if Country=="Czech Republic"
replace Countrycode=5 if Country=="Denmark"
replace Countrycode=6 if Country=="Estonia"
replace Countrycode=7 if Country=="Finland"
replace Countrycode=8 if Country=="France"
replace Countrycode=9 if Country=="Germany"
replace Countrycode=22 if Country=="Great Britain"
replace Countrycode=10 if Country=="Greece"
replace Countrycode=37 if Country=="Hungary"
replace Countrycode=11 if Country=="Iceland"
replace Countrycode=40 if Country=="Ireland"
replace Countrycode=43 if Country=="Israel"
replace Countrycode=41 if Country=="Italy"
replace Countrycode=28 if Country=="Japan"
replace Countrycode=12 if Country=="Latvia"
replace Countrycode=42 if Country=="Lithuania"
replace Countrycode=29 if Country=="Mexico"
replace Countrycode=13 if Country=="Montenegro"
replace Countrycode=21 if Country=="Netherlands"
replace Countrycode=30 if Country=="New Zealand"
replace Countrycode=38 if Country=="Norway"
replace Countrycode=31 if Country=="Peru"
replace Countrycode=14 if Country=="Poland"
replace Countrycode=15 if Country=="Portugal"
replace Countrycode=44 if Country=="Romania"
replace Countrycode=16 if Country=="Serbia"
replace Countrycode=17 if Country=="Slovakia"
replace Countrycode=45 if Country=="Slovenia"
replace Countrycode=32 if Country=="South Africa"
replace Countrycode=33 if Country=="Republic of Korea"
replace Countrycode=18 if Country=="Spain"
replace Countrycode=19 if Country=="Sweden"
replace Countrycode=20 if Country=="Switzerland"
replace Countrycode=39 if Country=="Taiwan"
replace Countrycode=34 if Country=="Turkey"
replace Countrycode=23 if Country=="United States of America"
replace Countrycode=35 if Country=="Uruguay"
gen Ageofdemocracy_5step = .
replace Ageofdemocracy_5step=1 if Age_of_democracy<26
replace Ageofdemocracy_5step=2 if Age_of_democracy>25 & Age_of_democracy<51
replace Ageofdemocracy_5step=3 if Age_of_democracy>50 & Age_of_democracy<76
replace Ageofdemocracy_5step=4 if Age_of_democracy>75
gen Region =""
replace Region="Oceania" if Countryyear=="AUS1996" | Countryyear=="AUS2004" | Countryyear=="AUS2007" | Countryyear=="AUS2013" | Countryyear=="AUS2019" | Countryyear=="NZL1996" | Countryyear=="NZL2008" | Countryyear=="NZL2011" | Countryyear=="NZL2014" | Countryyear=="NZL2017"
replace Region="NWE" if Country=="Austria" | Country=="Switzerland" | Country=="Germany" | Country=="Denmark" | Country=="Finland" | Country=="Great Britain" | Country=="Ireland" | Country=="Iceland" | Country=="Netherlands" | Country=="Norway" | Country=="Sweden"
replace Region="N-Am" if Country=="United States of America" | Country=="Canada"
replace Region="CEE" if Country=="Bulgaria" | Country=="Czech Republic" | Country=="Estonia" | Country=="Croatia" | Country=="Hungary" | Country=="Lithuania" | Country=="Latvia" | Country=="Montenegro" | Country=="Poland" | Country=="Romania" | Country=="Serbia" | Country=="Slovakia" | Country=="Slovenia"
replace Region="SE" if Country=="Portugal"  | Country=="Spain" | Country=="Italy"  | Country=="Greece" 
replace Region="SE-Asia" if Country=="Taiwan" | Country=="Republic of Korea" | Country=="Japan"
replace Region="L-Am" if Country=="Mexico" | Country=="Peru" | Country=="Uruguay"
replace Region="Africa" if Country=="South Africa"
gen Latestelection =0
replace Latestelection=1 if Countryyear=="AUS2019" | Countryyear=="AUT2017" | Countryyear=="BGR2014" | Countryyear=="CAN2008" | Countryyear=="HRV2007" | Countryyear=="CZE2013" | Countryyear=="DNK2007" | Countryyear=="EST2011" | Countryyear=="FIN2015" | Countryyear=="FRA2007" | Countryyear=="DEU2017" | Countryyear=="GBR2015" | Countryyear=="GRC2015" | Countryyear=="ISL2017" | Countryyear=="IRL2016" | Countryyear=="ISR2013" | Countryyear=="ITA2018" | Countryyear=="LVA2014" | Countryyear=="LTU2016" | Countryyear=="MEX2012" | Countryyear=="MNE2016" | Countryyear=="NLD2010" | Countryyear=="NZL2017" | Countryyear=="NOR2017" | Countryyear=="PER2016" | Countryyear=="POL2011" | Countryyear=="PRT2015" | Countryyear=="ROU2012" | Countryyear=="SRB2012" | Countryyear=="SVK2016" | Countryyear=="SVN2011" | Countryyear=="ZAF2014" | Countryyear=="ESP2008" | Countryyear=="SWE2014" | Countryyear=="CHE2011" | Countryyear=="TWN1996" | Countryyear=="TUR2018" | Countryyear=="USA2016" | Countryyear=="URY2009"
gen Last2elections =0
replace Last2elections= 1 if Countryyear=="AUS2019" | Countryyear=="AUT2017" | Countryyear=="CAN2008" | Countryyear=="CZE2013" | Countryyear=="DNK2007" | Countryyear=="FIN2015" | Countryyear=="DEU2017" | Countryyear=="GBR2015" | Countryyear=="GRC2015" | Countryyear=="ISL2017" | Countryyear=="IRL2016" | Countryyear=="ISR2013" | Countryyear=="LVA2014" | Countryyear=="MNE2016" | Countryyear=="NLD2010" | Countryyear=="NZL2017" | Countryyear=="NOR2017" | Countryyear=="PER2016" | Countryyear=="POL2011" | Countryyear=="PRT2015" | Countryyear=="SVK2016" | Countryyear=="SVN2011" | Countryyear=="ZAF2014" | Countryyear=="ESP2008" | Countryyear=="SWE2014" | Countryyear=="CHE2011" | Countryyear=="TUR2018" | Countryyear=="USA2016" | Countryyear=="AUS2013" | Countryyear=="AUT2013" | Countryyear=="CAN1997" | Countryyear=="CZE2010" | Countryyear=="DNK1998" | Countryyear=="FIN2011" | Countryyear=="DEU2013" | Countryyear=="GBR1997" | Countryyear=="GRC2015_2" | Countryyear=="HUN1998" | Countryyear=="ISL2016" | Countryyear=="IRL2011" | Countryyear=="ISR1996" | Countryyear=="LVA2011" | Countryyear=="MNE2012" | Countryyear=="NLD2006" | Countryyear=="NZL2014" | Countryyear=="NOR2013" | Countryyear=="PER2011" | Countryyear=="POL2007" | Countryyear=="PRT2009" | Countryyear=="SVN2008" | Countryyear=="SVK2010" | Countryyear=="ZAF2009" | Countryyear=="ESP2000" | Countryyear=="SWE2006" | Countryyear=="CHE2007" | Countryyear=="TUR2015" | Countryyear=="USA2012" | Countryyear=="HUN2018"
gen Secondaryelection =0
replace Secondaryelection=1 if Countryyear=="MEX1997" | Countryyear=="MEX2009" | Countryyear=="KOR2016"  | Countryyear=="KOR2012" | Countryyear=="KOR2008" | Countryyear=="KOR2000" | Countryyear=="JPN2013" | Countryyear=="JPN2007"
gen Finalmodel =1
replace Finalmodel=0 if Countryyear=="USA1996" | Countryyear=="TWN2012" | Countryyear=="MEX1997" | Countryyear=="MEX2009" | Countryyear=="KOR2016"  | Countryyear=="KOR2012" | Countryyear=="KOR2008" | Countryyear=="KOR2000" | Countryyear=="JPN2013" | Countryyear=="JPN2007" | Countryyear=="JPN1996"
gen Presidentialsystem=0
replace Presidentialsystem=1 if Country=="United States of America" | Country=="France" | Country=="Republic of Korea" | Country=="Peru" | Country=="Taiwan" | Country=="Uruguay" | Country=="Mexico" | IMD1003==79202018

drop api_* apiv_* apil_* apivl_* IMD1003
order Country Countrycode Year Year_0 Countryyear VoterAPI_Party VoterAPI_Leader Leader_Party_APIratio_voters PartisanAPI_Party PartisanAPI_Leader Leader_Party_APIratio_partisans Average_inparty_voter Average_outparty_voter Average_inleader_voter Average_outleader_voter Average_inparty_partisans Average_inleader_partisans Average_outparty_partisans Average_outleader_partisans LR_Polarization_perceived PID_noleaners PID_strength EffectiveN_electoral Presidentialsystem Gov_effectiveness_0_5 Region Age_of_democracy Ageofdemocracy_5step Latestelection Last2elections Secondaryelection Finalmodel

foreach var of varlist _all {
	label var `var' ""
}

save PAP_LAP_dataset.dta
