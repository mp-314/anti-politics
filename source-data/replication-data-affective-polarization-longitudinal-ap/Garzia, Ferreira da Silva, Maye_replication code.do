* Replication code for Garzia, D., Ferreira da Silva, F. & Maye, S. (2023). Affective Polarization in Comparative and Longitudinal Perspective. Public Opinion Quarterly. *
* Code written in Stata/SE 17

*To replicate Table 1 please use Replication code for Table1.R"*

*Figure 2 - Trends in affective polarization among partisans*
twoway (lfit PAP_partisans YEAR if YEAR>1960 , ylabel(0(2)8) lpattern(dash) lcolor(gs8) by(COUNTRY)) (lfit AP_partisans YEAR if YEAR>1960 , ylabel(0(2)8) lpattern(solid) lcolor(red) by(COUNTRY, rows(3))) (scatter AP_partisans YEAR if YEAR>1960 & PAP_partisans==., mcolor(black) msymbol(Oh) by(COUNTRY)) (scatter PAP_partisans YEAR if YEAR>1960, legend(rows(1)) mcolor(black) msymbol(O) by(COUNTRY)) 

*Figure 3 - Trends in affective polarization among the electorate*
twoway (lfit PAP_electorate YEAR if YEAR>1960 , ylabel(0(2)8) lpattern(dash) lcolor(gs8) by(COUNTRY)) (lfit AP_electorate YEAR if YEAR>1960 , ylabel(0(2)8) legend(rows(1)) lpattern(solid) lcolor(red) by(COUNTRY, rows(3))) (scatter AP_electorate YEAR if YEAR>1960 & PAP_electorate==., mcolor(black) msymbol(Oh) by(COUNTRY)) (scatter PAP_electorate YEAR if YEAR>1960, mcolor(black) msymbol(O) by(COUNTRY)) 


* SUPPLEMENTARY MATERIALS *

*Table S1*
ttest PAP_partisans == LAP_partisans
ttest PAP_partisans == LAP_partisans if COUNTRY==1
ttest PAP_partisans == LAP_partisans if COUNTRY==3
ttest PAP_partisans == LAP_partisans if COUNTRY==5
ttest PAP_partisans == LAP_partisans if COUNTRY==7
ttest PAP_partisans == LAP_partisans if COUNTRY==8
ttest PAP_partisans == LAP_partisans if COUNTRY==9
ttest PAP_partisans == LAP_partisans if COUNTRY==10
ttest PAP_partisans == LAP_partisans if COUNTRY==17
ttest PAP_partisans == LAP_partisans if COUNTRY==18
ttest PAP_partisans == LAP_partisans if COUNTRY==19
ttest PAP_partisans == LAP_partisans if COUNTRY==20
ttest PAP_partisans == LAP_partisans if COUNTRY==25
ttest PAP_partisans == LAP_partisans if COUNTRY==26
ttest PAP_partisans == LAP_partisans if COUNTRY==27
ttest PAP_partisans == LAP_partisans if COUNTRY==28

corr PAP_partisans LAP_partisans
corr PAP_partisans LAP_partisans if COUNTRY==1
corr PAP_partisans LAP_partisans if COUNTRY==3
corr PAP_partisans LAP_partisans if COUNTRY==5
corr PAP_partisans LAP_partisans if COUNTRY==7
corr PAP_partisans LAP_partisans if COUNTRY==8
corr PAP_partisans LAP_partisans if COUNTRY==9
corr PAP_partisans LAP_partisans if COUNTRY==10
corr PAP_partisans LAP_partisans if COUNTRY==17
corr PAP_partisans LAP_partisans if COUNTRY==18
corr PAP_partisans LAP_partisans if COUNTRY==19
corr PAP_partisans LAP_partisans if COUNTRY==20
corr PAP_partisans LAP_partisans if COUNTRY==25
corr PAP_partisans LAP_partisans if COUNTRY==26
corr PAP_partisans LAP_partisans if COUNTRY==27
corr PAP_partisans LAP_partisans if COUNTRY==28

ttest PAP_electorate == LAP_electorate
ttest PAP_electorate == LAP_electorate if COUNTRY==1
ttest PAP_electorate == LAP_electorate if COUNTRY==3
ttest PAP_electorate == LAP_electorate if COUNTRY==5
ttest PAP_electorate == LAP_electorate if COUNTRY==7
ttest PAP_electorate == LAP_electorate if COUNTRY==8
ttest PAP_electorate == LAP_electorate if COUNTRY==9
ttest PAP_electorate == LAP_electorate if COUNTRY==10
ttest PAP_electorate == LAP_electorate if COUNTRY==14
ttest PAP_electorate == LAP_electorate if COUNTRY==17
ttest PAP_electorate == LAP_electorate if COUNTRY==18
ttest PAP_electorate == LAP_electorate if COUNTRY==19
ttest PAP_electorate == LAP_electorate if COUNTRY==20
ttest PAP_electorate == LAP_electorate if COUNTRY==24
ttest PAP_electorate == LAP_electorate if COUNTRY==25
ttest PAP_electorate == LAP_electorate if COUNTRY==26
ttest PAP_electorate == LAP_electorate if COUNTRY==27
ttest PAP_electorate == LAP_electorate if COUNTRY==28

corr PAP_electorate LAP_electorate
corr PAP_electorate LAP_electorate if COUNTRY==1
corr PAP_electorate LAP_electorate if COUNTRY==3
corr PAP_electorate LAP_electorate if COUNTRY==5
corr PAP_electorate LAP_electorate if COUNTRY==7
corr PAP_electorate LAP_electorate if COUNTRY==8
corr PAP_electorate LAP_electorate if COUNTRY==9
corr PAP_electorate LAP_electorate if COUNTRY==10
corr PAP_electorate LAP_electorate if COUNTRY==17
corr PAP_electorate LAP_electorate if COUNTRY==18
corr PAP_electorate LAP_electorate if COUNTRY==19
corr PAP_electorate LAP_electorate if COUNTRY==20
corr PAP_electorate LAP_electorate if COUNTRY==24
corr PAP_electorate LAP_electorate if COUNTRY==25
corr PAP_electorate LAP_electorate if COUNTRY==26
corr PAP_electorate LAP_electorate if COUNTRY==27
corr PAP_electorate LAP_electorate if COUNTRY==28

*Table S2*


corr PAP_partisans PAP_partisans_alt partisan_affect_polarization

corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==1
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==3
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==5
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==8
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==18
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==19
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==25
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==26
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==27
corr PAP_partisans PAP_partisans_alt partisan_affect_polarization if COUNTRY==28

*Figure S1*
gen COUNTRY2=COUNTRY
replace COUNTRY2=. if COUNTRY==2
replace COUNTRY2=. if COUNTRY==7
replace COUNTRY2=. if COUNTRY==9
replace COUNTRY2=. if COUNTRY==10
replace COUNTRY2=. if COUNTRY==14
replace COUNTRY2=. if COUNTRY==17
replace COUNTRY2=. if COUNTRY==20
replace COUNTRY2=. if COUNTRY==24

lab val COUNTRY2 COUNTRY

gen partisan_affect_polarization2=partisan_affect_polarization/10

twoway (lfit AP_partisans YEAR if YEAR>1960, ylabel(0(2)8) lpattern(solid) lcolor(black) by(COUNTRY2)) (lfit partisan_affect_polarization2 YEAR if YEAR>1960, ylabel(0(2)8) legend(rows(1)) lpattern(dash) lcolor(black) by(COUNTRY2, rows(2)))

*Figure S2*
twoway (lfit AP_partisans YEAR if YEAR>1960 & partisan_affect_polarization2!=., ylabel(0(2)8) lpattern(solid) lcolor(black) by(COUNTRY2)) (lfit partisan_affect_polarization2 YEAR if YEAR>1960 & AP_partisans!=., ylabel(0(2)8) legend(rows(1)) lpattern(dash) lcolor(black) by(COUNTRY2, rows(2)))

*Figure S3*
gen AP_partisans_alt=PAP_partisans_alt
replace AP_partisans_alt=LAP_partisans_alt if PAP_partisans_alt==.

twoway (lfit AP_partisans_alt YEAR if YEAR>1960 & partisan_affect_polarization2!=., ylabel(0(2)8) lpattern(solid) lcolor(black) by(COUNTRY2)) (lfit partisan_affect_polarization2 YEAR if YEAR>1960 & AP_partisans_alt!=., ylabel(0(2)8) legend(rows(1)) lpattern(dash) lcolor(black) by(COUNTRY2, rows(2)))

*Figure S4*
twoway (scatter AP_partisans AP_electorate, msymbol(O) mcolor(black)) (lfit AP_partisans AP_electorate, lpattern(solid) lcolor(black)), legend(off)

*Table S3*
ttest AP_partisans == AP_electorate
ttest AP_partisans == AP_electorate if COUNTRY==1
ttest AP_partisans == AP_electorate if COUNTRY==3
ttest AP_partisans == AP_electorate if COUNTRY==5
ttest AP_partisans == AP_electorate if COUNTRY==7
ttest AP_partisans == AP_electorate if COUNTRY==8
ttest AP_partisans == AP_electorate if COUNTRY==9
ttest AP_partisans == AP_electorate if COUNTRY==10
ttest AP_partisans == AP_electorate if COUNTRY==14
ttest AP_partisans == AP_electorate if COUNTRY==17
ttest AP_partisans == AP_electorate if COUNTRY==18
ttest AP_partisans == AP_electorate if COUNTRY==19
ttest AP_partisans == AP_electorate if COUNTRY==20
ttest AP_partisans == AP_electorate if COUNTRY==24
ttest AP_partisans == AP_electorate if COUNTRY==25
ttest AP_partisans == AP_electorate if COUNTRY==26
ttest AP_partisans == AP_electorate if COUNTRY==27
ttest AP_partisans == AP_electorate if COUNTRY==28

corr AP_partisans  AP_electorate
corr AP_partisans  AP_electorate if COUNTRY==1
corr AP_partisans  AP_electorate if COUNTRY==3
corr AP_partisans  AP_electorate if COUNTRY==5
corr AP_partisans  AP_electorate if COUNTRY==7
corr AP_partisans  AP_electorate if COUNTRY==8
corr AP_partisans  AP_electorate if COUNTRY==9
corr AP_partisans  AP_electorate if COUNTRY==10
corr AP_partisans  AP_electorate if COUNTRY==14
corr AP_partisans  AP_electorate if COUNTRY==17
corr AP_partisans  AP_electorate if COUNTRY==18
corr AP_partisans  AP_electorate if COUNTRY==19
corr AP_partisans  AP_electorate if COUNTRY==20
corr AP_partisans  AP_electorate if COUNTRY==24
corr AP_partisans  AP_electorate if COUNTRY==25
corr AP_partisans  AP_electorate if COUNTRY==26
corr AP_partisans  AP_electorate if COUNTRY==27
corr AP_partisans  AP_electorate if COUNTRY==28

*Figure S5*
twoway (scatter PAP_electorate YEAR if COUNTRY==9 & YEAR>1979, ylabel(0(2)8) msymbol(oh)) (lfit PAP_electorate YEAR if COUNTRY==9 & YEAR>1979, xlabel(1980(10)2020) lpattern(dash) lcolor(black)) (scatter Polit_AP YEAR if COUNTRY==9 & YEAR>1979, msymbol(O) mcolor(black)) (lfit Polit_AP YEAR if COUNTRY==9  & YEAR>1979, lpattern(solid) lcolor(black))

*Figure S6*
twoway (scatter GLES_AP YEAR if COUNTRY==9 & YEAR>1979, ylabel(0(2)8) msymbol(oh)) (lfit GLES_AP YEAR if COUNTRY==9 & YEAR>1979, xlabel(1980(10)2020) lpattern(dash) lcolor(black)) (scatter Polit_AP YEAR if COUNTRY==9 & YEAR>1979, msymbol(O) mcolor(black)) (lfit Polit_AP YEAR if COUNTRY==9  & YEAR>1979, lpattern(solid) lcolor(black))

*To replicate Table S5 please use Replication code for TableS5.R*

