* Replication for Reiljan, A., Garzia, D., Ferreira da Silva, F. & Trechsel, A. H. (2023) Patterns of affective polarization in the democratic world: comparing the polarized feelings towards parties and leaders. American Political Science Review *

* Load dataset (adjust file path)
use "C:\...\PAP_LAP_dataset.dta"

* Figure 2

graph hbar (mean) VoterAPI_Leader if Finalmodel==1, over(Country, sort(VoterAPI_Leader) descending) 

* Figure 3

reg VoterAPI_Leader VoterAPI_Party if Finalmodel==1
local r2: display %5.4f e(r2)
twoway (lfitci VoterAPI_Leader VoterAPI_Party if Finalmodel==1, legend(off) lpattern(solid) lcolor(black) alp(dash) ciplot(rline)) (scatter VoterAPI_Leader VoterAPI_Party if Finalmodel==1, ytitle("Leader Affective Polarization") xtitle("Party Affective Polarization") ylabel(2/7) msymbol(O) mcolor(black) msize(vsmall)), note(R-squared=`r2')

* Figure 4

preserve
collapse (semean) se1=Average_inparty_voter se2=Average_inleader_voter se3=Average_outparty_voter se4=Average_outleader_voter (mean) m1=Average_inparty_voter m2=Average_inleader_voter m3=Average_outparty_voter m4=Average_outleader_voter
gen n=_n
reshape long se m, i(n) j(j, string)
replace n=_n
gen up=m+1.96*se
gen low=m-1.96*se
lab def n 1 "In-party" 2 "In-leader" 3 "Out-party" 4 "Out-leader"
lab val n n
twoway rcap up low n || scatter m n , legend(off) msymbol(O) mcolor(black) msize(vsmall) ylabel(0/8) xlabel(1 2 3 4, valuelabel) xtitle("") 

restore

* Figure 5

graph hbar (mean) Leader_Party_APIratio_voters if Finalmodel==1, over(Country, sort(Leader_Party_APIratio_voters) descending) ytitle("Leader/Party Affective Polarization Ratio")


*  Models in Table 2

reg VoterAPI_Party PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Finalmodel !=0, vce (cluster Country) 
est sto m1
reg VoterAPI_Leader PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Finalmodel !=0, vce (cluster Country) 
est sto m2
reg Leader_Party_APIratio_voters PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Finalmodel !=0, vce (cluster Country) 
est sto m3

outreg2 [m1 m2 m3] using "Table2", stats(coef se N) dec(2) see word 

***SUPPLEMENTARY MATERIALS***

* Table A1

bysort Country Year: sum Leader_Party_APIratio_voters if Finalmodel==1

* Table A2

sum VoterAPI_Leader VoterAPI_Party Leader_Party_APIratio_voters PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem if Finalmodel==1

* Table A3

corr VoterAPI_Leader VoterAPI_Party Leader_Party_APIratio_voters PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem if Finalmodel==1

* Table A4
mixed VoterAPI_Leader || Countrycode: if Finalmodel==1
estat icc
mixed VoterAPI_Party || Countrycode: if Finalmodel==1
estat icc
mixed Leader_Party_APIratio_voters || Countrycode: if Finalmodel==1
estat icc
mixed PID_noleaners || Countrycode: if Finalmodel==1
estat icc
mixed LR_Polarization_perceived || Countrycode: if Finalmodel==1
estat icc
mixed Gov_effectiveness_0_5 || Countrycode: if Finalmodel==1
estat icc
mixed EffectiveN_electoral || Countrycode: if Finalmodel==1
estat icc

* Table A5
preserve 
collapse VoterAPI_Party VoterAPI_Leader Leader_Party_APIratio_voters LR_Polarization_perceived PID_noleaners Presidentialsystem EffectiveN_electoral Gov_effectiveness_0_5 Year_0 if Finalmodel==1, by (Country)
reg VoterAPI_Party PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0
est sto m4
reg VoterAPI_Leader PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0
est sto m5
reg Leader_Party_APIratio_voters PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0
est sto m6
outreg2 [m4 m5 m6] using "TableA5", stats(coef se N) dec(2) see word 
restore


* Table A6

reg VoterAPI_Party PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Last2elections==1 , vce (cluster Country) 
est sto m7
reg VoterAPI_Leader PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Last2elections==1, vce (cluster Country)
est sto m8
reg Leader_Party_APIratio_voters PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Last2elections==1, vce (cluster Country)
est sto m9
outreg2 [m7 m8 m9] using "TableA6", stats(coef se N) dec(2) see word 


* Table A7

reg VoterAPI_Party PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 Ageofdemocracy_5step if Finalmodel !=0, vce (cluster Country) 
est sto m10
reg VoterAPI_Leader PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 Ageofdemocracy_5step if Finalmodel !=0, vce (cluster Country)
est sto m11
reg Leader_Party_APIratio_voters PID_noleaners LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 Ageofdemocracy_5step if Finalmodel !=0, vce (cluster Country)
est sto m12
outreg2 [m10 m11 m12] using "TableA7", stats(coef se N) dec(2) see word 


* Table A8

reg PartisanAPI_Party PID_strength LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Finalmodel !=0, vce (cluster Country) 
est sto m13
reg PartisanAPI_Leader PID_strength LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Finalmodel !=0, vce (cluster Country)
est sto m14
reg Leader_Party_APIratio_partisans  PID_strength LR_Polarization_perceived Gov_effectiveness_0_5 EffectiveN_electoral Presidentialsystem Year_0 if Finalmodel !=0, vce (cluster Country)
est sto m15
outreg2 [m13 m14 m15] using "TableA8", stats(coef se N) dec(2) see word 
