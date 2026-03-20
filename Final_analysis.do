***************************************************************************
***************************************************************************
*																		  *
*                          		 DO FILE                                  *
*                              										      *
*                 		TITLE                                             * 
*             	      												      *
*						      										      *
***************************************************************************
***************************************************************************


***************************************************************************
* Author: Dr. Micha Kaiser												  *
***************************************************************************

* LAST UPDATE: 20 March 2026

*Note copy data file to your folder
set scheme tufte
set scheme white_tableau
clear
* Set working directory (replace with your path)
cd "[YOUR_DIRECTORY]"
* Load final data
use "final"

* Generate a new binary variable 'emp_ind' for employment status
gen emp_ind=.
label var emp_ind "Employed"
replace emp_ind=1 if unemployed==0 & homemaker==0 & student==0 & retired==0
replace emp_ind=0 if unemployed!=0 | homemaker!=0 | student!=0 | retired!=0

// Relabel values of income and wealth
*label define deci 1 "Poorest 10% (D1)" 2 "D2" 3  "D3" 4 "D4" 5 "D5" 6 "D6" 7 "D7" 8  "D8" 9 "D9" 10 "Top 10% (D10)" 12 "Prefer not to say" 13 "Prefer not to say"
label define deci 1 "D1" 2 "D2" 3  "D3" 4 "D4" 5 "D5" 6 "D6" 7 "D7" 8  "D8" 9 "D9" 10 "D10" 12 "Prefer not to say" 13 "Prefer not to say"
label values hhwealth deci
label values hhinc deci



// reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9, vce(robust)

* https://academic.oup.com/heapol/article/21/6/459/612115
* Conduct principal component analysis (PCA) for socio-economic status variables
pca hhinc hhwealth educ moneyleft unemployed homemaker student retired occ_score  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4
screeplot, ci(asympt level(95) table)
cd "[YOUR_DIRECTORY]/Figures"
graph export screeplot.png, width(4000) replace
loadingplot, factors(2) xline(0) yline(0)
graph export loadingplot.png, width(4000) replace
predict econ_stat if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 , score
label var econ_stat "Socio Economic Status"

glo demo i.country i.gender i.age i.rltshp i.kids i.native i.polact 
glo psych efinv_fuel_indpd efinv_comfort efinv_financial efinv_efficacy suffort biov c.pnorm  clmt_prt_imp
glo airt attitude_airtr pbc_airtr efficacy_airtr
glo house attitude_housing pbc_housing efficacy_housing
glo car attitude_car pbc_car efficacy_car
glo healthwellbeing health lsat
glo travel work_trvl_car work_trvl_plane
glo econ i.moneyleft i.hhinc i.hhwealth i.educ homemaker student retired emp_ind unemployed occ_score  
glo econ_1  econ_stat   


// Standardize coefficients

egen efinv_fuel_indpd_sd=std(efinv_fuel_indpd)   if flag==0,
egen efinv_comfort_sd=std(efinv_comfort) if flag==0
egen efinv_financial_sd= std(efinv_financial) if flag==0
egen efinv_efficacy_sd = std(efinv_efficacy) if flag==0


egen suffort_sd =std(suffort) if flag==0
egen suffort_own_little_sd=std(suffort_own_little)
egen suffort_resrc_sd=std(suffort_resrc) 
egen suffort_huge_waste_sd=std(suffort_huge_waste) 
egen suffort_superflu_sd=std(suffort_superflu) 
egen suffort_grow_sd=std(suffort_grow)

egen biov_sd =std(biov) if flag==0
egen  bio_env_sd=std(bio_env)
egen bio_nature_sd=std(bio_nature) 
egen bio_earth_sd=std(bio_earth)

egen pnorm_sd =std(pnorm)  if flag==0

egen pnorm_reduce_sd=std(pnorm_reduce)
egen pnorm_little_sd=std(pnorm_little) 
egen pnorm_imprt_sd=std(pnorm_imprt)

egen clmt_prt_imp_sd=std(clmt_prt_imp) if flag==0

glo psych_sd efinv_fuel_indpd_sd efinv_comfort_sd efinv_financial_sd efinv_efficacy_sd suffort_sd biov_sd pnorm_sd clmt_prt_imp_sd

egen attitude_airtr_sd=std(attitude_airtr) if flag==0
egen  pbc_airtr_sd =std(pbc_airtr) if flag==0
egen efficacy_airtr_sd=std(efficacy_airtr) if flag==0

glo airt_sd attitude_airtr_sd pbc_airtr_sd efficacy_airtr_sd

egen attitude_housing_sd=std(attitude_housing) if flag==0
egen  pbc_housing_sd =std(pbc_housing) if flag==0
egen efficacy_housing_sd=std(efficacy_housing) if flag==0


glo house_sd attitude_housing_sd pbc_housing_sd efficacy_housing_sd

egen attitude_car_sd=std(attitude_car) if flag==0
egen  pbc_car_sd =std(pbc_car) if flag==0
egen efficacy_car_sd=std(efficacy_car) if flag==0


glo car_sd attitude_car_sd pbc_car_sd efficacy_car_sd

egen  health_sd =std(health) if flag==0
egen lsat_sd=std(lsat) if flag==0

glo healthwellbeing_sd health_sd lsat_sd

egen  work_trvl_car_sd =std(work_trvl_car) if flag==0
egen work_trvl_plane_sd=std(work_trvl_plane) if flag==0

glo travel_sd work_trvl_car_sd work_trvl_plane_sd

egen econ_stat_sd=std(econ_stat) if flag==0
egen occ_score_sd=std(occ_score) if flag==0
glo econ_sd i.moneyleft i.hhinc i.hhwealth i.educ homemaker student retired emp_ind unemployed occ_score_sd  
glo econ_1_sd  econ_stat_sd

egen total_sd=std(total)  if flag==0
egen food_sd=std(food) if flag==0
egen goods_sd=std(goods) if flag==0
egen transport_sd=std(transport) if flag==0
egen services_sd=std(services) if flag==0
egen housing_sd=std(housing) if flag==0
egen moneyleft_sd=std(moneyleft) if flag==0
egen hhinc_sd=std(hhinc) if flag==0 & hhinc<12
egen hhwealth_sd=std(hhwealth) if flag==0 & hhwealth<12
egen educ_sd=std(educ) if flag==0 & educ<9
********************************************************************************
*					DESCRIPTIVE STATISTICS 								       *
********************************************************************************

// Table 
cd "[YOUR_DIRECTORY]/Tables"

dtable $demo $psych $airt $house $car $healthwellbeing $travel $econ total  food goods housing services transport if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, novarlabel export(Full_Sample.docx, replace)

dtable i.gender i.age i.rltshp i.kids i.educ i.native i.polact $psych $airt $house $car $healthwellbeing $travel $econ total  food goods housing services transport if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4,  by(country) novarlabel export(country_sample.docx, replace)

// One Hot Encoding for correlation analysis
tab country, gen(country_oh) 
rename country_oh1 germany
rename country_oh2 france
rename country_oh3 italy
rename country_oh4 canada
rename country_oh5 usa
rename country_oh6 uk

tab gender, gen(genn)
rename genn1 male
rename genn2 female
rename genn3 non_binary
rename genn4 prefer_not_say

tab rltshp, gen(relation) 
rename relation1 married
rename relation2 long_term_relation
rename relation3 single
rename relation4 divorced
rename relation5 widowed
rename relation6 other

tab kids, gen(kid)
rename kid1 child_no
rename kid2 child_1
rename kid3 child_2
rename kid4 child_3
rename kid5 child_more
rename kid6 child_not_house

tab polact, gen(polit)
rename polit1 not_engaged_polit
rename polit2 engaged_polit
rename polit3 no_info_polit

tab age, gen(agen)
rename agen1 age_18_24
rename agen2 age_25_34
rename agen3 age_35_44
rename agen4 age_45_54
rename agen5 age_55

tab native, gen(nat)
rename nat1 no_native
rename nat2 yes_native
glo demo_d france italy canada usa uk female non_binary age_25_34 age_35_44 age_45_54 age_55 long_term_relation single divorced widowed other child_1 child_2 child_3 child_more child_not_house yes_native engaged_polit no_info_polit 
* Generate correlation matrices and heatplots
cd "[YOUR_DIRECTORY]/Figures"
corr  efinv_fuel_indpd efinv_comfort efinv_financial efinv_efficacy suffort biov pnorm attitude_airtr pbc_airtr efficacy_airtr attitude_housing pbc_housing efficacy_housing attitude_car pbc_car efficacy_car  clmt_prt_imp  total  food goods housing services transport if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4

corr $demo_d efinv_fuel_indpd efinv_comfort efinv_financial efinv_efficacy suffort biov pnorm attitude_airtr pbc_airtr efficacy_airtr attitude_housing pbc_housing efficacy_housing attitude_car pbc_car efficacy_car health lsat work_trvl_car work_trvl_plane moneyleft hhinc hhwealth  emp_ind  total if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4
matrix corrmatrix=r(C)
heatplot corrmatrix, values(format(%4.3f) size(half_tiny)) color(,  intensity(.7)) aspectratio(1) xlabel(, labsize(tiny) angle(45)) ylabel(,labsize(tiny)) 
graph export corrmat_0.png, width(4000) replace
heatplot corrmatrix, color(`=blue' `=cyan' `=green' `=yellow' `=orange' `=red' `=darkred', intensity(.7)) aspectratio(1) xlabel(, labsize(tiny) angle(45)) ylabel(, labsize(tiny)) cut(-1 -0.75 -0.5 -0.25 0.25 0.5 0.75 1) 
graph export corrmat_1.png, width(4000) replace



********************************************************************************
*					OLS REGRESSIONS - FULL SAMPLE							   *
********************************************************************************

// OLS Regressions for total and specific domains
set scheme tufte

* Total domain - sequential model building
cd "[YOUR_DIRECTORY]/Figures"


reg  total $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store r1
reg  total $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store r2
reg  total $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store r3
reg  total $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store r4
reg  total $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store r5


reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store r6

* Predicted marginal effects for key variables
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean 
marginsplot , recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Household income (deciles)", size(small)) xlabel(, labsize(vsmall)) ylabel(,labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") name(fig1c, replace) title("", size(small))
graph export OLS_hhinc_prediction.png, width(4000) replace

qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean 
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Household wealth (deciles)", size(small)) xlabel(,labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") ylabel(,labsize(vsmall)) name(fig1a, replace) title("", size(small))
graph export OLS_hhwealth_prediction.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Sufficency orientation", size(small)) xlabel(,  labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") ylabel(,labsize(vsmall))  title("", size(small)) name(fig2c, replace) 
graph export OLS_suffort_prediction.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Biospheric values", size(small)) xlabel(,  labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") ylabel(,labsize(vsmall)) name(fig2a, replace) 
graph export OLS_biov_prediction.png, width(4000) replace
 
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Attitudes air travel", size(medium)) xlabel(,  labsize(mdium)) ytitle("Predicted gha", size(medium)) title("") ylabel(,labsize(medium))
graph export OLS_attairttrvl_prediction.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Efficiency - comfort", size(medium)) xlabel(,  labsize(medium)) ytitle("Predicted gha", size(medium)) title("") ylabel(,labsize(medium))
graph export OLS_effinv_comfor_prediction.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Personal norms", size(small)) xlabel(,  labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") ylabel(,labsize(vsmall)) name(fig2g, replace) 
graph export OLS_pnorm_prediction.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(clmt_prt_imp=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Climate concern", size(small)) xlabel(,  labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") ylabel(,labsize(vsmall)) name(fig2e, replace) 
graph export OLS_clmtimp_prediction.png, width(4000) replace

* Model with PCA-based SES index
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9, vce(robust)
est store r7
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ_stat=(-4(1)4)) 
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Socio economic status", size(small)) xlabel(, labsize(vsmall)) ytitle("Predicted gha", size(small)) title("")  ylabel(,labsize(vsmall)) name(fig1e, replace)
graph export OLS_ses_prediction.png, width(4000) replace


* Non-parametric local polynomial plots for key predictors
twoway lpolyci total econ_stat  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, ciplot(rline) xtitle("Socio economic status", size(medium)) ylabel(,labsize(medium)) ytitle("(Predicted) gha", size(medium)) xlabel(, labsize(medium)) || scatter total econ_stat if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4,  xlabel(, labsize(medium)) mcolor(grey%10) below legend(off) yline(2, lpattern(dash) lcolor(red))
graph export Unconditional_ses_prediction_boundaries_nonloniear.png, width(4000) replace

twoway lpolyci total biov  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, ciplot(rline) xtitle("Biospheric values", size(medium)) ylabel(,labsize(medium)) ytitle("(Predicted) gha", size(medium)) xlabel(, labsize(medium)) || scatter total biov if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & educ<9 & gender<4,  xlabel(, labsize(medium)) mcolor(grey%10) below legend(off) yline(2, lpattern(dash) lcolor(red))
graph export Unconditional_biov_prediction_boundaries_nonloniear.png, width(4000) replace

twoway lpolyci total suffort  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, ciplot(rline)  ylabel(,labsize(medium)) xtitle("Sufficiency orientation", size(medium)) ytitle("(Predicted) gha", size(medium)) xlabel(, labsize(medium)) || scatter total suffort if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & educ<9 & gender<4,  xlabel(, labsize(medium)) mcolor(grey%10) below legend(off) yline(2, lpattern(dash) lcolor(red))
graph export Unconditional_suffort_prediction_boundaries_nonloniear.png, width(4000) replace

twoway lpolyci total pnorm  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, ciplot(rline) ylabel(,labsize(medium)) xtitle("Personal norms", size(medium)) ytitle("(Predicted) gha", size(medium)) xlabel(, labsize(medium)) || scatter total pnorm if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & educ<9 & gender<4,  xlabel(, labsize(medium)) mcolor(grey%10) below legend(off) yline(2, lpattern(dash) lcolor(red))
graph export Unconditional_pnorm_prediction_boundaries_nonloniear.png, width(4000) replace



* Export main OLS table
cd "[YOUR_DIRECTORY]/Tables"
esttab   r1 r2 r3 r4 r5 r6 r7 using "Table_OLS_FULL.rtf" , title(Full Sample)   se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons)  replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )
* indicate("Attitudes, Perceptions, Costs=att_tow_en perc_ben econ_cost trust_tech trust_util trust_ind trust_auth per_risk" "Values=bio_val altr_val hed_val ego_va" "Regional Climate=indic_nrgcdd_nuts32022 indic_nrghdd_nuts32022" "Regional Economic Indicators=estat_tgs00005nuts22021    ris2021nuts2 primarysectornuts3 secondarysector"  "Socio-Demographics=age *.gender *.education income" "Hydrogen knowledge=knowl_hydro")




* Domain-specific regressions (food, housing, services, transport, goods)
cd "[YOUR_DIRECTORY]/Tables"

// Food
reg  food $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g1
reg  food $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g2
reg  food $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g3
reg  food $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g4
reg  food $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g5
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g6

qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(wlth_fd, replace)
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(inc_fd, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7)) saving(effinvcomfo_fd, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35)) saving(suffort_fd, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21)) saving(biov_fd, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7)) saving(airt_fd, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7)) saving(pnorm_fd, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(clmt_prt_imp=(1(1)7)) saving(clmt_imp_fd, replace)
reg  food $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g7
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ=(-4(1)4)) saving(econ_fd, replace)
esttab   g1 g2 g3 g4 g5 g6 g7 using "Table_OLS_food.rtf" , title(Food) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )


// Housing
reg  housing $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store h1
reg  housing $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store h2
reg  housing $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store h3
reg  housing $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store h4
reg  housing $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store h5
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store h6
qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(wlth_hs, replace)
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(inc_hs, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7)) saving(effinvcomfo_hs, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35)) saving(suffort_hs, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21)) saving(biov_hs, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7)) saving(airt_hs, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7)) saving(pnorm_hs, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(clmt_prt_imp=(1(1)7)) saving(clmt_imp_hs, replace)

reg  housing $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9, vce(robust)
est store h7
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ=(-4(1)4)) saving(econ_hs, replace)
esttab   h1 h2 h3 h4 h5 h6 h7 using "Table_OLS_housing.rtf" , title(housing) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

// Services
reg  services $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store s1
reg  services $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store s2
reg  services $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store s3
reg  services $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store s4
reg  services $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store s5
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store s6
qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(wlth_srv, replace)
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(inc_srv, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7)) saving(effinvcomfo_srv, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35)) saving(suffort_srv, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21)) saving(biov_srv, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7)) saving(airt_srv, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7)) saving(pnorm_srv, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(clmt_prt_imp=(1(1)7)) saving(clmt_imp_srv, replace)
reg  services $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9, vce(robust)
est store s7
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ=(-4(1)4)) saving(econ_srv, replace)
esttab   s1 s2 s3 s4 s5 s6 s7 using "Table_OLS_services.rtf" , title(housing) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

// Transport
reg  transport $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t1
reg  transport $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t2
reg  transport $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t3
reg  transport $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t4
reg  transport $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t5
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t6
qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(wlth_tr, replace)
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(inc_tr, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7)) saving(effinvcomfo_tr, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35)) saving(suffort_tr, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21)) saving(biov_tr, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7)) saving(airt_tr, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7)) saving(pnorm_tr, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(clmt_prt_imp=(1(1)7)) saving(clmt_imp_tr, replace)


reg  transport $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store t7
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ=(-4(1)4)) saving(econ_tr, replace)

esttab   t1 t2 t3 t4 t5 t6 t7 using "Table_OLS_transport.rtf" , title(housing) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

// Goods
reg  goods $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g1
reg  goods $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g2
reg  goods $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g3
reg  goods $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g4
reg  goods $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g6
qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(wlth_gds, replace)
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean saving(inc_gds,replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7)) saving(effinvcomfo_gds, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35)) saving(suffort_gds, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21)) saving(biov_gds, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7)) saving(airt_gds, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7)) saving(pnorm_gds, replace)
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(clmt_prt_imp=(1(1)7)) saving(clmt_imp_gds, replace)

reg  goods $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store g7
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ=(-4(1)4)) saving(econ_gds, replace)
esttab   g1 g2 g3 g4 g5 g6 g7  using "Table_OLS_goods.rtf" , title(housing) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )


* Marginsplot combining all footprint domains per predictor (combomarginsplot)

set scheme cblind1 
cd "[YOUR_DIRECTORY]/Tables"
combomarginsplot wlth_fd wlth_hs wlth_srv wlth_tr wlth_gds,  title("") xtitle("Household wealth (deciles)", size(small)) xlabel(, labsize(vsmall)) ylabel(, labsize(vsmall)) ytitle("Predicted gha", size(small))  labels("Food" "Housing" "Services" "Transport" "Goods") legend(off) name(fig1b, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_hhwealth_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"combomarginsplot inc_fd inc_hs inc_srv inc_tr inc_gds,  xtitle("Household income (deciles)", size(small)) ylabel(, labsize(vsmall)) xlabel(,  labsize(vsmall)) ytitle("Predicted gha", size(small)) title("", size(small)) labels("Food" "Housing" "Services" "Transport" "Goods") legend(off) name(fig1d, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_hhinc_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"combomarginsplot econ_fd econ_hs econ_srv econ_tr econ_gds,  xtitle("Socio economic status",size(small)) ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle("Predicted gha", size(small)) title("", size(small)) labels("Food" "Housing" "Services" "Transport" "Goods") legend(position(11) ring(0) rows(2) cols(3) size(tiny)) name(fig1f, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_ses_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"combomarginsplot effinvcomfo_fd effinvcomfo_hs effinvcomfo_srv effinvcomfo_tr effinvcomfo_gds,  xtitle("Efficiency - comfort",size(medium)) ylabel(, labsize(medium)) xlabel(, labsize(medium)) ytitle("Predicted gha", size(medium)) title("") labels("Food" "Housing" "Services" "Transport" "Goods") legend(position(1) ring(0) rows(1) cols(5) size(small))
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_efficencycomfort_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
combomarginsplot suffort_fd suffort_hs suffort_srv suffort_tr suffort_gds,  xtitle("Sufficiency orientation",size(small)) ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") labels("Food" "Housing" "Services" "Transport" "Goods")  legend(off) name(fig2d, replace) 
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_suffort_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
combomarginsplot biov_fd biov_hs biov_srv biov_tr biov_gds,  xtitle("Biospheric values",size(small)) xlabel(, labsize(vsmall)) ylabel(, labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") labels("Food" "Housing" "Services" "Transport" "Goods") legend(off) name(fig2b, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_biov_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
combomarginsplot airt_fd airt_hs airt_srv airt_tr airt_gds,  xtitle("Attitudes - air travel",size(medium)) ylabel(, labsize(medium)) xlabel(, labsize(medium)) ytitle("Predicted gha", size(medium)) title("") labels("Food" "Housing" "Services" "Transport" "Goods") legend(position(1) ring(0) rows(1) cols(5) size(small))
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_airtr_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
combomarginsplot pnorm_fd pnorm_hs pnorm_srv pnorm_tr pnorm_gds,  xtitle("Personal norms",size(small)) ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") labels("Food" "Housing" "Services" "Transport" "Goods", size(large)) legend(position(6) ring(0) rows(1) cols(5) size(tiny))  name(fig2h, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_pnorm_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
combomarginsplot clmt_imp_fd clmt_imp_hs clmt_imp_srv clmt_imp_tr clmt_imp_gds,  xtitle("Climate concern",size(small)) legend(off) ylabel(, labsize(vsmall)) xlabel(, labsize(vsmall)) ytitle("Predicted gha", size(small)) title("") labels("Food" "Housing" "Services" "Transport" "Goods") legend(position(6) ring(0) rows(1) cols(5) size(small)) name(fig2f, replace)
cd "[YOUR_DIRECTORY]/Figures"
graph export OLS_clmtimp_prediction_sections.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Figures"

* Combine panels into Figure 1 and Figure 2

graph combine fig1a fig1b ///
              fig1c fig1d ///
              fig1e fig1f, ///
    cols(2) ///
    imargin(1 1 1 1) ///
    graphregion(margin(0.5 0.5 0.5 0.5) color(white)) ///
    name(Figure1, replace)
graph export "Figure1.tif", replace width(4000)	

graph combine fig1a fig1b ///
              fig1c fig1d ///
              fig1e fig1f, ///
    cols(3) ///
    imargin(1 1 1 1) ///
    graphregion(margin(0.5 0.5 0.5 0.5) color(white)) ///
    name(Figure1_v2, replace)
graph export "Figure1_v2.tif", replace width(4000)	



graph combine fig2a fig2b ///
              fig2c fig2d ///
              fig2e fig2f ///
			  fig2g fig2h, ///
    cols(2) ///
    imargin(1 1 1 1 1) ///
    graphregion(margin(0.5 0.5 0.5 0.5) color(white)) ///
    name(Figure2, replace)
graph export "Figure2.tif", replace width(4000)		

graph combine fig2a fig2b ///
              fig2c fig2d ///
              fig2e fig2f ///
			  fig2g fig2h, ///
    cols(3) ///
    imargin(1 1 1 1 1) ///
    graphregion(margin(0.5 0.5 0.5 0.5) color(white)) ///
    name(Figure2_v2, replace)
graph export "Figure2_v2.tif", replace width(4000)		


********************************************************************************
*				INTERACTION EFFECTS - PERSONAL NORMS						   *
********************************************************************************
// Interaction effects with personal norms
cd "[YOUR_DIRECTORY]/Tables"

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10)  & gender<4, atmean at(pnorm=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Personal norms") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_pnorms_income.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.pnorm) nolabel coeflabels(8.hhinc#c.pnorm="D8 x Personal norms" 9.hhinc#c.pnorm="D9 x Personal norms" 7.hhinc#c.pnorm="D7 x Personal norms" 6.hhinc#c.pnorm="D6 x Personal norms" 5.hhinc#c.pnorm="D5 x Personal norms" 4.hhinc#c.pnorm="D4 x Personal norms" 3.hhinc#c.pnorm="D3 x Personal norms" 2.hhinc#c.pnorm="D2 x Personal norms" 1.hhinc#c.pnorm="D1 x Personal norms" 10.hhinc#c.pnorm="D10 x Personal norms") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_pnorm_inc.png, width(4000) replace


cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa6
esttab   aa1 aa2 aa3 aa4 aa5 aa6  using "Table_Interaction_pnorm_income.rtf" , title(Interaction Income pnorm) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )


reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(pnorm=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Personal norms") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_pnorms_hhwealth.png, width(4000) replace
// Coefplot
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.pnorm) nolabel coeflabels(8.hhwealth#c.pnorm="D8 x Personal norms" 9.hhwealth#c.pnorm="D9 x Personal norms" 7.hhwealth#c.pnorm="D7 x Personal norms" 6.hhwealth#c.pnorm="D6 x Personal norms" 5.hhwealth#c.pnorm="D5 x Personal norms" 4.hhwealth#c.pnorm="D4 x Personal norms" 3.hhwealth#c.pnorm="D3 x Personal norms" 2.hhwealth#c.pnorm="D2 x Personal norms" 1.hhwealth#c.pnorm="D1 x Personal norms" 10.hhwealth#c.pnorm="D10 x Personal norms") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_pnorm_wealth.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab6

esttab   ab1 ab2 ab3 ab4 ab5 ab6  using "Table_Interaction_pnorm_wealth.rtf" , title(Interaction hhwealth pnorm) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

* SES x personal norms interaction and contour plot data
cd "[YOUR_DIRECTORY]/ContPlots"
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac1
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, at(econ=(-4(1)4) pnorm=(3(2)21)) saving(total_econ_pnorm, replace)
reg  food $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac2
reg  housing $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac3
reg  services $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac4
reg  transport $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac5
reg  goods $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac6

cd "[YOUR_DIRECTORY]/Tables"
esttab   ac1 ac2 ac3 ac4 ac5 ac6  using "Table_Interaction_pnorm_ses.rtf" , title(Interaction econ pnorm) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )



********************************************************************************
*				INTERACTION EFFECTS - BIOSPHERIC VALUES						   *
********************************************************************************

// Interaction effects with bio values

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10) & gender<4, atmean at(biov=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Biospheric values") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_biov_income.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.biov) nolabel coeflabels(8.hhinc#c.biov="D8 x Biospheric values" 9.hhinc#c.biov="D9 x Biospheric values" 7.hhinc#c.biov="D7 x Biospheric valuess" 6.hhinc#c.biov="D6 xBiospheric values" 5.hhinc#c.biov="D5 x Biospheric values" 4.hhinc#c.biov="D4 x Biospheric values" 3.hhinc#c.biov="D3 x Biospheric values" 2.hhinc#c.biov="D2 x Biospheric values" 1.hhinc#c.biov="D1 x Biospheric values" 10.hhinc#c.biov="D10 x Biospheric values") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_biov_inc.png, width(4000) replace


cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa6
esttab   aa1 aa2 aa3 aa4 aa5 aa6  using "Table_Interaction_biov_income.rtf" , title(Interaction Income Biov) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )



reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(biov=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Biospheric values") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_biov_wealth.png, width(4000) replace
// Coefplot
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.biov) nolabel coeflabels(8.hhwealth#c.biov="D8 x Biospheric values" 9.hhwealth#c.biov="D9 x Biospheric values" 7.hhwealth#c.biov="D7 x Biospheric values" 6.hhwealth#c.biov="D6 x Biospheric values" 5.hhwealth#c.biov="D5 x Biospheric values" 4.hhwealth#c.biov="D4 x Biospheric values" 3.hhwealth#c.biov="D3 x Biospheric values" 2.hhwealth#c.biov="D2 x Biospheric values" 1.hhwealth#c.biov="D1 x Biospheric values" 10.hhwealth#c.biov="D10 x Biospheric values") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_biov_wealth.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab6

esttab   ab1 ab2 ab3 ab4 ab5 ab6  using "Table_Interaction_biov_wealth.rtf" , title(Interaction Wealth Biov) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

* SES x biospheric values interaction and contour plot data
cd "[YOUR_DIRECTORY]/ContPlots"
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac1
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9, at(econ=(-4(1)4) biov=(3(2)21)) saving(total_econ_biov, replace)
reg  food $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac2
reg  housing $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac3
reg  services $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac4
reg  transport $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac5
reg  goods $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac6


cd "[YOUR_DIRECTORY]/Tables"
esttab   ac1 ac2 ac3 ac4 ac5 ac6  using "Table_Interaction_biov_ses.rtf" , title(Interaction SES Biov) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )


********************************************************************************
*				INTERACTION EFFECTS - SUFFICIENCY ORIENTATION				   *
********************************************************************************

// Interaction effects with suffort

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10) & gender<4, atmean at(suffort=(5(5)35))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Sufficiency orientation") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_suffort_income.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.suffort) nolabel coeflabels(8.hhinc#c.suffort="D8 x Sufficiency orientation" 9.hhinc#c.suffort="D9 x Sufficiency orientation" 7.hhinc#c.suffort="D7 x Sufficiency orientation" 6.hhinc#c.suffort="D6 x Sufficiency orientation" 5.hhinc#c.suffort="D5 x Sufficiency orientation" 4.hhinc#c.suffort="D4 x Sufficiency orientation" 3.hhinc#c.suffort="D3 x Sufficiency orientation" 2.hhinc#c.suffort="D2 x Sufficiency orientation" 1.hhinc#c.suffort="D1 x Sufficiency orientation" 10.hhinc#c.suffort="D10 x Sufficiency orientation") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_suffort_inc.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa6

esttab   aa1 aa2 aa3 aa4 aa5 aa6  using "Table_Interaction_suffort_income.rtf" , title(Interaction hhinc suffort) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(suffort=(5(5)35))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Sufficiency orientation") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_suffort_wealth.png, width(4000) replace
// Coefplot 
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.suffort) nolabel coeflabels(8.hhwealth#c.suffort="D8 x Sufficiency orientation" 9.hhwealth#c.suffort="D9 x Sufficiency orientation" 7.hhwealth#c.suffort="D7 x Sufficiency orientation" 6.hhwealth#c.suffort="D6 x Sufficiency orientation" 5.hhwealth#c.suffort="D5 x Sufficiency orientation" 4.hhwealth#c.suffort="D4 x Sufficiency orientation" 3.hhwealth#c.suffort="D3 x Sufficiency orientation" 2.hhwealth#c.suffort="D2 x Sufficiency orientation" 1.hhwealth#c.suffort="D1 x Sufficiency orientation" 10.hhwealth#c.suffort="D10 x Sufficiency orientation") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_suffort_hhwealth.png, width(4000) replace


cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab6

esttab   ab1 ab2 ab3 ab4 ab5 ab6  using "Table_Interaction_suffort_wealth.rtf" , title(Interaction hhwealth suffort) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

* SES x sufficiency orientation interaction and contour plot data
cd "[YOUR_DIRECTORY]/ContPlots"
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac1
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9, at(econ=(-4(1)4) suffort=(5(2)35)) saving(total_econ_suffort, replace)
reg  food $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac2
reg  housing $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac3
reg  services $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac4
reg  transport $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac5
reg  goods $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ac6
cd "[YOUR_DIRECTORY]/Tables"

esttab   ac1 ac2 ac3 ac4 ac5 ac6  using "Table_Interaction_suffort_ses.rtf" , title(Interaction SES suffort) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )




********************************************************************************
*				INTERACTION EFFECTS - CLIMATE CHANGE IMPORTANCE				   *
********************************************************************************

// Interaction effects with climate importance


reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ca1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10) & gender<4, atmean at(clmt_prt_imp=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Climate change importance") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_clmtimp_income.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot ca1, sort(1, descending) keep(*.hhinc#c.clmt_prt_imp) nolabel coeflabels(8.hhinc#c.clmt_prt_imp="D8 x Climate change importance" 9.hhinc#c.clmt_prt_imp="D9 x Climate change importance" 7.hhinc#c.clmt_prt_imp="D7 x Climate change importance" 6.hhinc#c.clmt_prt_imp="D6 x Climate change importance" 5.hhinc#c.clmt_prt_imp="D5 x Climate change importance" 4.hhinc#c.clmt_prt_imp="D4 x Climate change importance" 3.hhinc#c.clmt_prt_imp="D3 x Climate change importance" 2.hhinc#c.clmt_prt_imp="D2 x Climate change importance" 1.hhinc#c.clmt_prt_imp="D1 x Climate change importance" 10.hhinc#c.clmt_prt_imp="D10 x Climate change importance") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_clmtimp_inc.png, width(4000) replace

cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ca2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ca3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ca4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ca5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ca6

esttab   ca1 ca2 ca3 ca4 ca5 ca6  using "Table_Interaction_clmtimp_income.rtf" , title(Interaction hhinc clmt_imp) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cb1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(clmt_prt_imp=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Climate change importance") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_clmtimp_wealth.png, width(4000) replace
// Coefplot 
coefplot cb1, sort(1, descending) keep(*.hhwealth#c.clmt_prt_imp) nolabel coeflabels(8.hhwealth#c.clmt_prt_imp="D8 x Climate change importance" 9.hhwealth#c.clmt_prt_imp="D9 x Climate change importance" 7.hhwealth#c.clmt_prt_imp="D7 x Climate change importance" 6.hhwealth#c.clmt_prt_imp="D6 x Climate change importance" 5.hhwealth#c.clmt_prt_imp="D5 x Climate change importance" 4.hhwealth#c.clmt_prt_imp="D4 x Climate change importance" 3.hhwealth#c.clmt_prt_imp="D3 x Climate change importance" 2.hhwealth#c.clmt_prt_imp="D2 x Climate change importance" 1.hhwealth#c.clmt_prt_imp="D1 x Climate change importance" 10.hhwealth#c.clmt_prt_imp="D10 x Climate change importance") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_clmtimp_hhwealth.png, width(4000) replace


cd "[YOUR_DIRECTORY]/Tables"
reg  food $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cb2
reg  housing $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cb3
reg  services $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cb4
reg  transport $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cb5
reg  goods $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cb6

esttab   cb1 cb2 cb3 cb4 cb5 cb6  using "Table_Interaction_clmtimpt_wealth.rtf" , title(Interaction hhwealth climate_imp) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

* SES x climate importance interaction and contour plot data
cd "[YOUR_DIRECTORY]/ContPlots"
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cc1
label var  clmt_prt_imp clmt_imp
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9, at(econ=(-4(1)4) clmt_prt_imp=(1(1)7)) saving(total_econ_clmtimp, replace)
reg  food $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cc2
reg  housing $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cc3
reg  services $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cc4
reg  transport $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cc5
reg  goods $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store cc6
cd "[YOUR_DIRECTORY]/Tables"

esttab   cc1 cc2 cc3 cc4 cc5 cc6  using "Table_Interaction_clmtimp_ses.rtf" , title(Interaction SES cimate_imp) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )






********************************************************************************
*				STANDARDIZED EFFECT SIZES									   *
********************************************************************************
reg  total_sd $demo $econ_1_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_total
reg  food_sd $demo $econ_1_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_food
reg  housing_sd $demo $econ_1_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_housing
reg  services_sd $demo $econ_1_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_services
reg  transport_sd $demo $econ_1_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_transport
reg  goods_sd $demo $econ_1_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_goods

cd "[YOUR_DIRECTORY]/Tables"
esttab   sd_total sd_food sd_housing sd_services sd_transport sd_goods  using "Table_ols_standardized_econ.rtf" , title(Standardized OLS) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )


* Coefplot - standardized full model (SES index specification)
// Coefplot - Full model
coefplot sd_total, sort(1, descending) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) 
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_full_model.png, width(4000) replace


// Coefplot - food
coefplot sd_food, sort(1, descending) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) 
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_food_model.png, width(4000) replace


// Coefplot - housing
coefplot sd_housing, sort(1, descending) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) 
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_housing_model.png, width(4000) replace
// Coefplot - services
coefplot sd_services, sort(1, descending) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) 
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_services_model.png, width(4000) replace
// Coefplot - transport
coefplot sd_transport, sort(1, descending) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) 
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_transport_model.png, width(4000) replace
// Coefplot - goods
coefplot sd_goods, sort(1, descending) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) 
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_goods_model.png, width(4000) replace




// Standardized effect sizes with all variables
reg  total_sd $demo $econ_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_total
reg  food_sd $demo $econ_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_food
reg  housing_sd $demo $econ_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_housing
reg  services_sd $demo $econ_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_services
reg  transport_sd $demo $econ_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_transport
reg  goods_sd $demo $econ_sd $travel_sd $healthwellbeing_sd $psych_sd $airt_sd $house_sd $car_sd  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store sd_goods

cd "[YOUR_DIRECTORY]/Tables"

esttab   sd_total sd_food sd_housing sd_services sd_transport sd_goods  using "Table_ols_standardized_full.rtf" , title(Standardized OLS) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )


// Coefplot - Full model
coefplot sd_total, sort(1, descending) keep(*.moneyleft unemployed homemaker student retired *.hhwealth *.hhinc occ_score_sd 6.educ 8.educ attitude_airtr_sd efinv_comfort_sd suffort_sd efficacy_housing_sd pbc_housing_sd efinv_financial_sd attitude_car_sd pbc_car_sd efinv_fuel_indpd_sd efficacy_car_sd efficacy_airtr_sd clmt_prt_imp_sd efinv_efficacy_sd biov_sd ) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" occ_score_sd="Occupational prestige" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship" 2.hhwealth="D2 wealth" 3.hhwealth="D3 wealth" 4.hhwealth="D4 wealth" 5.hhwealth="D5 wealth" 6.hhwealth="D6 wealth" 7.hhwealth="D7 wealth" 8.hhwealth="D8 wealth" 9.hhwealth="D9 wealth" 10.hhwealth="Top 10% wealth" 2.hhinc="D2 income" 3.hhinc="D3 income" 4.hhinc="D4 income" 5.hhinc="D5 income" 6.hhinc="D6 income" 7.hhinc="D7 income" 8.hhinc="D8 income" 9.hhinc="D9 income" 10.hhinc="Top 10% income" 8.educ="Graduate or professional degree" 2.moneyleft="Moneyleft: Below £200" 3.moneyleft="Moneyleft: £201 to £400" 4.moneyleft="Moneyleft: £401 to £600" 5.moneyleft="Moneyleft: £601 to £800" 6.moneyleft="Moneyleft: More than £800") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons)  xscale(range(-0.5 0.5))
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_full_model_econ_psych.png, width(4000) replace
 

// Coefplot - food
coefplot sd_food, sort(1, descending) keep(*.moneyleft unemployed homemaker student retired *.hhwealth *.hhinc occ_score_sd 6.educ 8.educ attitude_airtr_sd efinv_comfort_sd suffort_sd efficacy_housing_sd pbc_housing_sd efinv_financial_sd attitude_car_sd pbc_car_sd efinv_fuel_indpd_sd efficacy_car_sd efficacy_airtr_sd clmt_prt_imp_sd efinv_efficacy_sd biov_sd ) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" occ_score_sd="Occupational prestige" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship" 2.hhwealth="D2 wealth" 3.hhwealth="D3 wealth" 4.hhwealth="D4 wealth" 5.hhwealth="D5 wealth" 6.hhwealth="D6 wealth" 7.hhwealth="D7 wealth" 8.hhwealth="D8 wealth" 9.hhwealth="D9 wealth" 10.hhwealth="Top 10% wealth" 2.hhinc="D2 income" 3.hhinc="D3 income" 4.hhinc="D4 income" 5.hhinc="D5 income" 6.hhinc="D6 income" 7.hhinc="D7 income" 8.hhinc="D8 income" 9.hhinc="D9 income" 10.hhinc="Top 10% income" 8.educ="Graduate or professional degree" 2.moneyleft="Moneyleft: Below £200" 3.moneyleft="Moneyleft: £201 to £400" 4.moneyleft="Moneyleft: £401 to £600" 5.moneyleft="Moneyleft: £601 to £800" 6.moneyleft="Moneyleft: More than £800") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons)  xscale(range(-0.5 0.5))
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_food_model_econ_psych.png, width(4000) replace


// Coefplot - housing
coefplot sd_housing, sort(1, descending) keep(*.moneyleft unemployed homemaker student retired *.hhwealth *.hhinc occ_score_sd 6.educ 8.educ attitude_airtr_sd efinv_comfort_sd suffort_sd efficacy_housing_sd pbc_housing_sd efinv_financial_sd attitude_car_sd pbc_car_sd efinv_fuel_indpd_sd efficacy_car_sd efficacy_airtr_sd clmt_prt_imp_sd efinv_efficacy_sd biov_sd ) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" occ_score_sd="Occupational prestige" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship" 2.hhwealth="D2 wealth" 3.hhwealth="D3 wealth" 4.hhwealth="D4 wealth" 5.hhwealth="D5 wealth" 6.hhwealth="D6 wealth" 7.hhwealth="D7 wealth" 8.hhwealth="D8 wealth" 9.hhwealth="D9 wealth" 10.hhwealth="Top 10% wealth" 2.hhinc="D2 income" 3.hhinc="D3 income" 4.hhinc="D4 income" 5.hhinc="D5 income" 6.hhinc="D6 income" 7.hhinc="D7 income" 8.hhinc="D8 income" 9.hhinc="D9 income" 10.hhinc="Top 10% income" 8.educ="Graduate or professional degree" 2.moneyleft="Moneyleft: Below £200" 3.moneyleft="Moneyleft: £201 to £400" 4.moneyleft="Moneyleft: £401 to £600" 5.moneyleft="Moneyleft: £601 to £800" 6.moneyleft="Moneyleft: More than £800") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons)  xscale(range(-0.5 0.5))
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_housing_model_econ_psych.png, width(4000) replace
// Coefplot - services
coefplot sd_services, sort(1, descending) keep(*.moneyleft unemployed homemaker student retired *.hhwealth *.hhinc occ_score_sd 6.educ 8.educ attitude_airtr_sd efinv_comfort_sd suffort_sd efficacy_housing_sd pbc_housing_sd efinv_financial_sd attitude_car_sd pbc_car_sd efinv_fuel_indpd_sd efficacy_car_sd efficacy_airtr_sd clmt_prt_imp_sd efinv_efficacy_sd biov_sd ) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" occ_score_sd="Occupational prestige" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship" 2.hhwealth="D2 wealth" 3.hhwealth="D3 wealth" 4.hhwealth="D4 wealth" 5.hhwealth="D5 wealth" 6.hhwealth="D6 wealth" 7.hhwealth="D7 wealth" 8.hhwealth="D8 wealth" 9.hhwealth="D9 wealth" 10.hhwealth="Top 10% wealth" 2.hhinc="D2 income" 3.hhinc="D3 income" 4.hhinc="D4 income" 5.hhinc="D5 income" 6.hhinc="D6 income" 7.hhinc="D7 income" 8.hhinc="D8 income" 9.hhinc="D9 income" 10.hhinc="Top 10% income" 8.educ="Graduate or professional degree" 2.moneyleft="Moneyleft: Below £200" 3.moneyleft="Moneyleft: £201 to £400" 4.moneyleft="Moneyleft: £401 to £600" 5.moneyleft="Moneyleft: £601 to £800" 6.moneyleft="Moneyleft: More than £800") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons) xscale(range(-0.5 0.5))
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_services_model_econ_psych.png, width(4000) replace
// Coefplot - transport
coefplot sd_transport, sort(1, descending) keep(*.moneyleft unemployed homemaker student retired *.hhwealth *.hhinc occ_score_sd 6.educ 8.educ attitude_airtr_sd efinv_comfort_sd suffort_sd efficacy_housing_sd pbc_housing_sd efinv_financial_sd attitude_car_sd pbc_car_sd efinv_fuel_indpd_sd efficacy_car_sd efficacy_airtr_sd clmt_prt_imp_sd efinv_efficacy_sd biov_sd ) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" occ_score_sd="Occupational prestige" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship" 2.hhwealth="D2 wealth" 3.hhwealth="D3 wealth" 4.hhwealth="D4 wealth" 5.hhwealth="D5 wealth" 6.hhwealth="D6 wealth" 7.hhwealth="D7 wealth" 8.hhwealth="D8 wealth" 9.hhwealth="D9 wealth" 10.hhwealth="Top 10% wealth" 2.hhinc="D2 income" 3.hhinc="D3 income" 4.hhinc="D4 income" 5.hhinc="D5 income" 6.hhinc="D6 income" 7.hhinc="D7 income" 8.hhinc="D8 income" 9.hhinc="D9 income" 10.hhinc="Top 10% income" 8.educ="Graduate or professional degree" 2.moneyleft="Moneyleft: Below £200" 3.moneyleft="Moneyleft: £201 to £400" 4.moneyleft="Moneyleft: £401 to £600" 5.moneyleft="Moneyleft: £601 to £800" 6.moneyleft="Moneyleft: More than £800") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons)  xscale(range(-0.5 0.5))
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_transport_model_econ_psych.png, width(4000) replace
// Coefplot - goods
coefplot sd_goods, sort(1, descending) keep(*.moneyleft unemployed homemaker student retired *.hhwealth *.hhinc occ_score_sd 6.educ 8.educ attitude_airtr_sd efinv_comfort_sd suffort_sd efficacy_housing_sd pbc_housing_sd efinv_financial_sd attitude_car_sd pbc_car_sd efinv_fuel_indpd_sd efficacy_car_sd efficacy_airtr_sd clmt_prt_imp_sd efinv_efficacy_sd biov_sd ) coeflabels( 2.polact="Politically active (Yes)" 3.polact="Politically active (Do not know)" 4.gender="Gender (Prefer not to say)" econ_stat_sd="Socio Economic Status" attitude_airtr_sd="Air-travel attitudes" efinv_comfort_sd="Efficiency - comfort" suffort_sd="Sufficency orientation" efficacy_housing_sd="Housing efficacy beliefs" pbc_housing_sd="Housing pbc" efinv_financial_sd="Efficiency - financial" attitude_car_sd="Car attitudes" pbc_car_sd="Car pbc" efinv_fuel_indpd_sd="Efficiency - fuel" attitude_housing_sd="Housing attitudes" pbc_airtr_sd="Air-travel pbc" lsat_sd="Life satisfaction" health_sd="Health status" pnorm_sd="Personal norms" efficacy_car_sd="Car efficacy beliefs" efficacy_airtr_sd="Air-travel efficacy beliefs" work_trvl_car_sd="Work travel car" work_trvl_plane_sd="Work travel plane" occ_score_sd="Occupational prestige" clmt_prt_imp_sd="Climate change importance" efinv_efficacy_sd="Environment" biov_sd="Biopsheric values" 3.gender="Non-binary / third gender" 2.native="Native (non-migrant)" 6.rltshp="Other relationship" 2.hhwealth="D2 wealth" 3.hhwealth="D3 wealth" 4.hhwealth="D4 wealth" 5.hhwealth="D5 wealth" 6.hhwealth="D6 wealth" 7.hhwealth="D7 wealth" 8.hhwealth="D8 wealth" 9.hhwealth="D9 wealth" 10.hhwealth="Top 10% wealth" 2.hhinc="D2 income" 3.hhinc="D3 income" 4.hhinc="D4 income" 5.hhinc="D5 income" 6.hhinc="D6 income" 7.hhinc="D7 income" 8.hhinc="D8 income" 9.hhinc="D9 income" 10.hhinc="Top 10% income" 8.educ="Graduate or professional degree" 2.moneyleft="Moneyleft: Below £200" 3.moneyleft="Moneyleft: £201 to £400" 4.moneyleft="Moneyleft: £401 to £600" 5.moneyleft="Moneyleft: £601 to £800" 6.moneyleft="Moneyleft: More than £800") xline(0) ylabel(,labsize(tiny)) msize(vsmall)  drop(_cons)  xscale(range(-0.5 0.5))
cd "[YOUR_DIRECTORY]/Figures"
graph export coefplot_goods_model_econ_psych.png, width(4000) replace









* Kernel density plots comparing bottom vs. top SES decile footprint distributions



cd "[YOUR_DIRECTORY]/Figures"

twoway (kdensity total if econ_stat_sd < -1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(solid) bwidth(1)) ///
       (kdensity total if econ_stat_sd > 1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(dash) bwidth(1)), ///
       title("") xtitle("gha") ytitle("Density") ///
       legend(order(1 "Lowest decile SES" 2 "Highest decile SES") position(3) ring(0) cols(1) size(small) region(lstyle(none)))


graph export density_plot_ses_total.png, width(4000) replace

twoway (kdensity food if econ_stat_sd < -1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(solid) bwidth(1)) ///
       (kdensity food if econ_stat_sd > 1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(dash) bwidth(1)) , ///
       title("") xtitle("gha") ytitle("Density") ///
       legend(order(1 "Lowest decile SES" 2 "Highest decile SES") position(5) ring(0) cols(1) size(small) region(lstyle(none)))
graph export density_plot_ses_food.png, width(4000) replace


twoway (kdensity goods if econ_stat_sd < -1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(solid) bwidth(1)) ///
       (kdensity goods if econ_stat_sd > 1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(dash) bwidth(1)), ///
       title("") xtitle("gha") ytitle("Density") ///
       legend(order(1 "Lowest decile SES" 2 "Highest decile SES") position(8) ring(0) cols(1) size(small) region(lstyle(none)))
graph export density_plot_ses_goods.png, width(4000) replace


twoway (kdensity housing if econ_stat_sd < -1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(solid)) ///
       (kdensity housing if econ_stat_sd > 1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(dash)), ///
       title("") xtitle("gha") ytitle("Density") ///
       legend(order(1 "Lowest decile SES" 2 "Highest decile SES") position(3) ring(0) cols(1) size(small) region(lstyle(none)))
graph export density_plot_ses_housing.png, width(4000) replace

twoway (kdensity services if econ_stat_sd < -1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(solid) bwidth(1)) ///
       (kdensity services if econ_stat_sd > 1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(dash) bwidth(1)), ///
       title("") xtitle("gha") ytitle("Density") ///
       legend(order(1 "Lowest decile SES" 2 "Highest decile SES") position(3) ring(0) cols(1) size(small) region(lstyle(none)))
graph export density_plot_ses_services.png, width(4000) replace

twoway (kdensity transport if econ_stat_sd < -1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(solid) bwidth(1)) ///
       (kdensity transport if econ_stat_sd > 1.35 & hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, lcolor(grey) lpattern(dash) bwidth(1)), ///
       title("") xtitle("gha") ytitle("Density") ///
       legend(order(1 "Lowest decile SES" 2 "Highest decile SES") position(3) ring(0) cols(1) size(small) region(lstyle(none)))
graph export density_plot_ses_transport.png, width(4000) replace

********************************************************************************
*			ROBUSTNESS: OLS WITHOUT TRANSPORT DOMAIN						   *
********************************************************************************
gen total_wo_t=total-transport


cd "[YOUR_DIRECTORY]/Figures"

reg  total_wo $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if  hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store wo1
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(econ_stat=(-4(1)4))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Socio economic status") xlabel(, labsize(small)) ytitle("Predicted gha") title("") 
graph export OLS_ses_prediction_no_transport.png, width(4000) replace


reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store wo2
qui margins hhwealth if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean 
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Household wealth") xlabel(, labsize(small) angle(45)) ytitle("Predicted gha") title("") 
graph export OLS_wealth_prediction_no_transport.png, width(4000) replace

reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store wo3
qui margins hhinc if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean 
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Household income") xlabel(, labsize(small) angle(45)) ytitle("Predicted gha") title("") 
graph export OLS_income_prediction_no_transport.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(suffort=(5(5)35))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Sufficency orientation") xlabel(,  labsize(small)) ytitle("Predicted gha") title("")
graph export OLS_suffort_prediction_no_transport.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(biov=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Biospheric values") xlabel(,  labsize(small)) ytitle("Predicted gha") title("")
graph export OLS_biov_prediction_no_transport.png, width(4000) replace
 
qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(attitude_airtr=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Attitudes air travel") xlabel(,  labsize(small)) ytitle("Predicted gha") title("")
graph export OLS_attairttrvl_prediction_no_transport.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(efinv_comfort=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Efficiency - comfort") xlabel(,  labsize(small)) ytitle("Predicted gha") title("")
graph export OLS_effinv_comfor_prediction_no_transport.png, width(4000) replace

qui margins  if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, atmean at(pnorm=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Personal norms") xlabel(,  labsize(small)) ytitle("Predicted gha") title("")
graph export OLS_pnorm_prediction_no_transport.png, width(4000) replace



// Estimation without transport
reg  total_wo $demo      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ra1
reg  total_wo $demo $econ       if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ra2
reg  total_wo $demo $econ $travel      if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ra3
reg  total_wo $demo $econ $travel $healthwellbeing    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ra4
reg  total_wo $demo $econ $travel $healthwellbeing $psych    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ra5
reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ra6
reg  total_wo $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9, vce(robust)
est store ra7
cd "[YOUR_DIRECTORY]/Tables"
esttab   ra1 ra2 ra3 ra4 ra5 ra6 ra7 using "Table_OLS_FULL_no_transport.rtf" , title(Full Sample)   se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons)  replace varwidth(20)  ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )





* Interaction effects without transport - personal norms
// Interaction effects with personal norms


cd "[YOUR_DIRECTORY]/Tables"

reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10)  & gender<4, atmean at(pnorm=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Personal norms") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_pnorms_income_wotrans.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.pnorm) nolabel coeflabels(8.hhinc#c.pnorm="D8 x Personal norms" 9.hhinc#c.pnorm="D9 x Personal norms" 7.hhinc#c.pnorm="D7 x Personal norms" 6.hhinc#c.pnorm="D6 x Personal norms" 5.hhinc#c.pnorm="D5 x Personal norms" 4.hhinc#c.pnorm="D4 x Personal norms" 3.hhinc#c.pnorm="D3 x Personal norms" 2.hhinc#c.pnorm="D2 x Personal norms" 1.hhinc#c.pnorm="D1 x Personal norms" 10.hhinc#c.pnorm="D10 x Personal norms") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_pnorm_inc_wotrans.png, width(4000) replace


reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(pnorm=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Personal norms") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_pnorms_hhwealth_wotrans.png, width(4000) replace
// Coefplot
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.pnorm) nolabel coeflabels(8.hhwealth#c.pnorm="D8 x Personal norms" 9.hhwealth#c.pnorm="D9 x Personal norms" 7.hhwealth#c.pnorm="D7 x Personal norms" 6.hhwealth#c.pnorm="D6 x Personal norms" 5.hhwealth#c.pnorm="D5 x Personal norms" 4.hhwealth#c.pnorm="D4 x Personal norms" 3.hhwealth#c.pnorm="D3 x Personal norms" 2.hhwealth#c.pnorm="D2 x Personal norms" 1.hhwealth#c.pnorm="D1 x Personal norms" 10.hhwealth#c.pnorm="D10 x Personal norms") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_pnorm_wealth_wotrans.png, width(4000) replace


cd "[YOUR_DIRECTORY]/ContPlots"
reg  total_wo $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aaa1
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, at(econ=(-4(1)4) pnorm=(3(2)21)) saving(total_econ_pnorm_wotrans, replace)


* Interaction effects without transport - biospheric values
// Interaction effects with bio values


reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10) & gender<4, atmean at(biov=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Biospheric values") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_biov_income_wotrans.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.biov) nolabel coeflabels(8.hhinc#c.biov="D8 x Biospheric values" 9.hhinc#c.biov="D9 x Biospheric values" 7.hhinc#c.biov="D7 x Biospheric valuess" 6.hhinc#c.biov="D6 xBiospheric values" 5.hhinc#c.biov="D5 x Biospheric values" 4.hhinc#c.biov="D4 x Biospheric values" 3.hhinc#c.biov="D3 x Biospheric values" 2.hhinc#c.biov="D2 x Biospheric values" 1.hhinc#c.biov="D1 x Biospheric values" 10.hhinc#c.biov="D10 x Biospheric values") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_biov_inc_wotrans.png, width(4000) replace


reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(biov=(3(3)21))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Biospheric values") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_biov_wealth_wotrans.png, width(4000) replace
// Coefplot
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.biov) nolabel coeflabels(8.hhwealth#c.biov="D8 x Biospheric values" 9.hhwealth#c.biov="D9 x Biospheric values" 7.hhwealth#c.biov="D7 x Biospheric values" 6.hhwealth#c.biov="D6 x Biospheric values" 5.hhwealth#c.biov="D5 x Biospheric values" 4.hhwealth#c.biov="D4 x Biospheric values" 3.hhwealth#c.biov="D3 x Biospheric values" 2.hhwealth#c.biov="D2 x Biospheric values" 1.hhwealth#c.biov="D1 x Biospheric values" 10.hhwealth#c.biov="D10 x Biospheric values") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_biov_wealth_wotrans.png, width(4000) replace


cd "[YOUR_DIRECTORY]/ContPlots"
reg  total_wo $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aaa2
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9, at(econ=(-4(1)4) biov=(3(2)21)) saving(total_econ_biov_wotrans, replace)

* Interaction effects without transport - sufficiency orientation
// Interaction effects with suffort


reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10) & gender<4, atmean at(suffort=(5(5)35))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Sufficiency orientation") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_suffort_income_wotrans.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.suffort) nolabel coeflabels(8.hhinc#c.suffort="D8 x Sufficiency orientation" 9.hhinc#c.suffort="D9 x Sufficiency orientation" 7.hhinc#c.suffort="D7 x Sufficiency orientation" 6.hhinc#c.suffort="D6 x Sufficiency orientation" 5.hhinc#c.suffort="D5 x Sufficiency orientation" 4.hhinc#c.suffort="D4 x Sufficiency orientation" 3.hhinc#c.suffort="D3 x Sufficiency orientation" 2.hhinc#c.suffort="D2 x Sufficiency orientation" 1.hhinc#c.suffort="D1 x Sufficiency orientation" 10.hhinc#c.suffort="D10 x Sufficiency orientation") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_suffort_inc_wotrans.png, width(4000) replace

reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(suffort=(5(5)35))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Sufficiency orientation") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_suffort_wealth_wotrans.png, width(4000) replace
// Coefplot 
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.suffort) nolabel coeflabels(8.hhwealth#c.suffort="D8 x Sufficiency orientation" 9.hhwealth#c.suffort="D9 x Sufficiency orientation" 7.hhwealth#c.suffort="D7 x Sufficiency orientation" 6.hhwealth#c.suffort="D6 x Sufficiency orientation" 5.hhwealth#c.suffort="D5 x Sufficiency orientation" 4.hhwealth#c.suffort="D4 x Sufficiency orientation" 3.hhwealth#c.suffort="D3 x Sufficiency orientation" 2.hhwealth#c.suffort="D2 x Sufficiency orientation" 1.hhwealth#c.suffort="D1 x Sufficiency orientation" 10.hhwealth#c.suffort="D10 x Sufficiency orientation") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_suffort_hhwealth_wotrans.png, width(4000) replace


cd "[YOUR_DIRECTORY]/ContPlots"
reg  total_wo $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aaa3
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, at(econ=(-4(1)4) suffort=(5(2)35)) saving(total_econ_suffort_wotrans, replace)





* Interaction effects without transport - climate change importance
// Interaction effects with climate change importance


reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aa1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhinc if  hhwealth<12 & flag==0 & educ<9 & (hhinc==1 | hhinc==10) & gender<4, atmean at(clmt_prt_imp=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Climate change importance") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_clmtimp_income_wotrans.png, width(4000) replace
// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"
coefplot aa1, sort(1, descending) keep(*.hhinc#c.clmt_prt_imp) nolabel coeflabels(8.hhinc#c.clmt_prt_imp="D8 x Climate change importance" 9.hhinc#c.clmt_prt_imp="D9 x Climate change importance" 7.hhinc#c.clmt_prt_imp="D7 x Climate change importance" 6.hhinc#c.clmt_prt_imp="D6 x Climate change importance" 5.hhinc#c.clmt_prt_imp="D5 x Climate change importance" 4.hhinc#c.clmt_prt_imp="D4 x Climate change importance" 3.hhinc#c.clmt_prt_imp="D3 x Climate change importance" 2.hhinc#c.clmt_prt_imp="D2 x Climate change importance" 1.hhinc#c.clmt_prt_imp="D1 x Climate change importance" 10.hhinc#c.clmt_prt_imp="D10 x Climate change importance") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_clmtimp_inc_wotrans.png, width(4000) replace

reg  total_wo $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store ab1
cd "[YOUR_DIRECTORY]/Figures"
qui margins hhwealth if  hhwealth<12 & flag==0 & educ<9 & (hhwealth==1 | hhwealth==10) & gender<4, atmean at(clmt_prt_imp=(1(1)7))
marginsplot, recast(line) recastci(rarea) ciopt(color(black%20)) xtitle("Climate change importance") xlabel(, labsize(small)) ytitle("Predicted gha") title("") legend(position(1) ring(0) rows(3) cols(2)) plot1opts(lpattern(dash)) 
graph export Interaction_clmtimp_wealth_wotrans.png, width(4000) replace
// Coefplot 
coefplot ab1, sort(1, descending) keep(*.hhwealth#c.clmt_prt_imp) nolabel coeflabels(8.hhwealth#c.clmt_prt_imp="D8 x Climate change importance" 9.hhwealth#c.clmt_prt_imp="D9 x Climate change importance" 7.hhwealth#c.clmt_prt_imp="D7 x Climate change importance" 6.hhwealth#c.clmt_prt_imp="D6 x Climate change importance" 5.hhwealth#c.clmt_prt_imp="D5 x Climate change importance" 4.hhwealth#c.clmt_prt_imp="D4 x Climate change importance" 3.hhwealth#c.clmt_prt_imp="D3 x Climate change importance" 2.hhwealth#c.clmt_prt_imp="D2 x Climate change importance" 1.hhwealth#c.clmt_prt_imp="D1 x Climate change importance" 10.hhwealth#c.clmt_prt_imp="D10 x Climate change importance") xline(0) ylabel(,labsize(small))
graph export coefplot_interact_clmtimp_hhwealth_wotrans.png, width(4000) replace


cd "[YOUR_DIRECTORY]/ContPlots"
reg  total_wo $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.clmt_prt_imp   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, vce(robust)
est store aaa4
qui margins if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, at(econ=(-4(1)4) clmt_prt_imp=(1(1)7)) saving(total_econ_clmtimp_wotrans, replace)
cd "[YOUR_DIRECTORY]/Figures"
esttab   aaa1 aaa2 aaa3 aaa4 using "Table_ols_interaction_wotrans_psych_full.rtf" , title(Standardized OLS) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  r2 ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )




********************************************************************************
*						LORENZ CURVES										   *
********************************************************************************

* Lorenz curve estimation
*https://journals.sagepub.com/doi/pdf/10.1177/1536867X1601600403

* Generate binary income and wealth variables for top/bottom decile comparisons
gen inc=hhinc
recode inc (1=0) (2 3 4 5 6 7 8 9 13=.) (10=1)
label def inco 0 "Income: poorest 10%" 1 "Income: top 10%"
label values inc inco

gen wealth=hhwealth
recode wealth (1=0) (2 3 4 5 6 7 8 9 12=.) (10=1)
label def wealtho 0 "Wealth: poorest 10%" 1 "Wealth: top 10%"
label values wealth wealtho

cd "[YOUR_DIRECTORY]/Figures"



lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(econ_stat)
lorenz graph, ciopts(recast(rline) lpattern(dash)) overlay title("") legend(position(11) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by socioeconomic status") ytitle("Cumulative outcome gha")
graph export lorenz_all_econ.png, width(4000) replace
lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(econ_stat)
lorenz contrast
lorenz graph, ciopts(recast(rline) lpattern(dash))  title("") legend(position(2) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by socioeconomic status") ytitle("Difference in L(p)") 
graph export lorenz_all_econ_contrast.png, width(4000) replace


lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(biov)
lorenz graph, ciopts(recast(rline) lpattern(dash)) overlay title("") legend(position(11) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by biospheric values") ytitle("Cumulative outcome gha")
graph export lorenz_all_biov.png, width(4000) replace
lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(biov)
lorenz contrast
lorenz graph, ciopts(recast(rline) lpattern(dash))  title("") legend(position(2) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by biospheric values") ytitle("Difference in L(p)") 
graph export lorenz_all_biov_contrast.png, width(4000) replace

lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(suffort)
lorenz graph, ciopts(recast(rline) lpattern(dash)) overlay title("") legend(position(11) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by sufficiency orientation") ytitle("Cumulative outcome gha")
graph export lorenz_all_suffort.png, width(4000) replace
lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(suffort)
lorenz contrast
lorenz graph, ciopts(recast(rline) lpattern(dash))  title("") legend(position(2) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by sufficiency orientation") ytitle("Difference in L(p)") 
graph export lorenz_all_suffort_contrast.png, width(4000) replace

lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(pnorm)
lorenz graph, ciopts(recast(rline) lpattern(dash)) overlay title("") legend(position(11) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by personal norms") ytitle("Cumulative outcome gha")
graph export lorenz_all_pnorm.png, width(4000) replace
lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(pnorm)
lorenz contrast
lorenz graph, ciopts(recast(rline) lpattern(dash))  title("") legend(position(2) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by personal norms") ytitle("Difference in L(p)") 
graph export lorenz_all_pnorm_contrast.png, width(4000) replace

lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(clmt_prt_imp)
lorenz graph, ciopts(recast(rline) lpattern(dash)) overlay title("") legend(position(11) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by climate importance") ytitle("Cumulative outcome gha")
graph export lorenz_all_clmtimp.png, width(4000) replace
lorenz estimate total transport services housing goods food if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4, pvar(clmt_prt_imp)
lorenz contrast
lorenz graph, ciopts(recast(rline) lpattern(dash))  title("") legend(position(2) ring(0) rows(3) cols(2)) xtitle("Population percentage ordered by climate importance") ytitle("Difference in L(p)") 
graph export lorenz_all_clmtimp_contrast.png, width(4000) replace



********************************************************************************
*				COUNTRY-SPECIFIC REGRESSIONS								   *
********************************************************************************

// Country specific baseline regression
cd "[YOUR_DIRECTORY]/Tables"


reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est stor abi1
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est stor abi2
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est stor abi3
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est stor abi4
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est stor abi5
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est stor abi6


esttab   abi1 abi2 abi3 abi4 abi5 abi6  using "Table_ols_country_full_1.rtf" , title(Standardized OLS) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  r2 ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )

reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est stor abi1
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est stor abi2
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est stor abi3
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est stor abi4
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est stor abi5
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car    if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est stor abi6

esttab   abi1 abi2 abi3 abi4 abi5 abi6  using "Table_ols_country_econ_1.rtf" , title(Standardized OLS) label  se(3) star(* 0.1 ** 0.05 *** 0.01) b(%9.3f) noomitted nobaselevels nogaps drop(_cons) replace varwidth(20)  r2 ar2 aic note("Robust standard errors in parentheses. * p < 0.1, ** p < 0.05, *** p < 0.01." )



// Countryspecific interactions
cd "[YOUR_DIRECTORY]/Tables"

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"


coefplot Ger Fra Ita Can USA UK, keep(*hhinc#c.pnorm) nolabel ///
coeflabels(8.hhinc#c.pnorm="D8 x Personal norms" ///
           9.hhinc#c.pnorm="D9 x Personal norms" ///
           7.hhinc#c.pnorm="D7 x Personal norms" ///
           6.hhinc#c.pnorm="D6 x Personal norms" ///
           5.hhinc#c.pnorm="D5 x Personal norms" ///
           4.hhinc#c.pnorm="D4 x Personal norms" ///
           3.hhinc#c.pnorm="D3 x Personal norms" ///
           2.hhinc#c.pnorm="D2 x Personal norms" ///
           1.hhinc#c.pnorm="D1 x Personal norms" ///
           10.hhinc#c.pnorm="D10 x Personal norms") ///
xline(0) ylabel(,labsize(small)) legend(position(1) ring(0) cols(1)) msize(small)

graph export coefplot_interact_pnorm_inc_country.png, width(4000) replace

* Country-specific interaction: wealth x personal norms

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

cd "[YOUR_DIRECTORY]/Figures"


// Coefplot
* Country-specific interaction: SES x personal norms
coefplot Ger Fra Ita Can USA UK, keep(*hhwealth#c.pnorm) nolabel ///
coeflabels(8.hhwealth#c.pnorm="D8 x Personal norms" ///
           9.hhwealth#c.pnorm="D9 x Personal norms" ///
           7.hhwealth#c.pnorm="D7 x Personal norms" ///
           6.hhwealth#c.pnorm="D6 x Personal norms" ///
           5.hhwealth#c.pnorm="D5 x Personal norms" ///
           4.hhwealth#c.pnorm="D4 x Personal norms" ///
           3.hhwealth#c.pnorm="D3 x Personal norms" ///
           2.hhwealth#c.pnorm="D2 x Personal norms" ///
           1.hhwealth#c.pnorm="D1 x Personal norms" ///
           10.hhwealth#c.pnorm="D10 x Personal norms") ///
xline(0) ylabel(,labsize(small)) legend(position(1) ring(0) cols(1)) msize(small)

graph export coefplot_interact_pnorm_wealth_country.png, width(4000) replace


reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.pnorm   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

cd "[YOUR_DIRECTORY]/Figures"
coefplot Ger Fra Ita Can USA UK, keep(c.econ_stat#c.pnorm) asequation swapnames nolabel ///
coeflabels(c.econ_stat#c.pnorm="SES x Personal norms") ///
xline(0) ylabel(,labsize(small)) legend(off) msize(small)

graph export coefplot_interact_pnorm_ses_country.png, width(4000) replace



// Suffort
* Country-specific interaction: income x sufficiency orientation

cd "[YOUR_DIRECTORY]/Tables"

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"


coefplot Ger Fra Ita Can USA UK, keep(*hhinc#c.suffort) nolabel ///
coeflabels(8.hhinc#c.suffort="D8 x Sufficiency orientation" ///
           9.hhinc#c.suffort="D9 x Sufficiency orientation" ///
           7.hhinc#c.suffort="D7 x Sufficiency orientation" ///
           6.hhinc#c.suffort="D6 x Sufficiency orientation" ///
           5.hhinc#c.suffort="D5 x Sufficiency orientation" ///
           4.hhinc#c.suffort="D4 x Sufficiency orientation" ///
           3.hhinc#c.suffort="D3 x Sufficiency orientation" ///
           2.hhinc#c.suffort="D2 x Sufficiency orientation" ///
           1.hhinc#c.suffort="D1 x Sufficiency orientation" ///
           10.hhinc#c.suffort="D10 x Sufficiency orientation") ///
xline(0) ylabel(,labsize(vsmall)) legend(position(1) ring(0) cols(1)) msize(small)

graph export coefplot_interact_suffort_inc_country.png, width(4000) replace

* Country-specific interaction: wealth x sufficiency orientation
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

cd "[YOUR_DIRECTORY]/Figures"


// Coefplot
coefplot Ger Fra Ita Can USA UK, keep(*hhwealth#c.suffort) nolabel ///
coeflabels(8.hhwealth#c.suffort="D8 x Sufficiency orientation" ///
           9.hhwealth#c.suffort="D9 x Sufficiency orientation" ///
           7.hhwealth#c.suffort="D7 x Sufficiency orientation" ///
           6.hhwealth#c.suffort="D6 x Sufficiency orientation" ///
           5.hhwealth#c.suffort="D5 x Sufficiency orientation" ///
           4.hhwealth#c.suffort="D4 x Sufficiency orientation" ///
           3.hhwealth#c.suffort="D3 x Sufficiency orientation" ///
           2.hhwealth#c.suffort="D2 x Sufficiency orientation" ///
           1.hhwealth#c.suffort="D1 x Sufficiency orientation" ///
           10.hhwealth#c.suffort="D10 x Sufficiency orientation") ///
xline(0) ylabel(,labsize(vsmall)) legend(position(1) ring(0) cols(1)) msize(small)

graph export coefplot_interact_suffort_wealth_country.png, width(4000) replace

 Country-specific interaction: wealth x sufficiency orientation
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.suffort   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

cd "[YOUR_DIRECTORY]/Figures"
coefplot Ger Fra Ita Can USA UK, keep(c.econ_stat#c.suffort) asequation swapnames nolabel ///
coeflabels(c.econ_stat#c.pnorm="SES x Sufficiency orientation") ///
xline(0) ylabel(,labsize(small)) legend(off) msize(small)

graph export coefplot_interact_suffort_ses_country.png, width(4000) replace


// Biov
* Country-specific interaction: income x biospheric values

cd "[YOUR_DIRECTORY]/Tables"

reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhinc#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

// Coefplot 
cd "[YOUR_DIRECTORY]/Figures"


coefplot Ger Fra Ita Can USA UK, keep(*hhinc#c.biov) nolabel ///
coeflabels(8.hhinc#c.biov="D8 x Biospheric values" ///
           9.hhinc#c.biov="D9 x Biospheric values" ///
           7.hhinc#c.biov="D7 x Biospheric values" ///
           6.hhinc#c.biov="D6 x Biospheric values" ///
           5.hhinc#c.biov="D5 x Biospheric values" ///
           4.hhinc#c.biov="D4 x Biospheric values" ///
           3.hhinc#c.biov="D3 x Biospheric values" ///
           2.hhinc#c.biov="D2 x Biospheric values" ///
           1.hhinc#c.biov="D1 x Biospheric values" ///
           10.hhinc#c.biov="D10 x Biospheric values") ///
xline(0) ylabel(,labsize(vsmall)) legend(position(1) ring(0) cols(1)) msize(small)

graph export coefplot_interact_biov_inc_country.png, width(4000) replace

* Country-specific interaction: wealth x biospheric values
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ $travel $healthwellbeing $psych $airt $house $car i.hhwealth#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

cd "[YOUR_DIRECTORY]/Figures"


// Coefplot
coefplot Ger Fra Ita Can USA UK, keep(*hhwealth#c.biov) nolabel ///
coeflabels(8.hhwealth#c.biov="D8 x Biospheric values" ///
           9.hhwealth#c.biov="D9 x Biospheric values" ///
           7.hhwealth#c.biov="D7 x Biospheric values" ///
           6.hhwealth#c.biov="D6 x Biospheric values" ///
           5.hhwealth#c.biov="D5 x Biospheric values" ///
           4.hhwealth#c.biov="D4 x Biospheric values" ///
           3.hhwealth#c.biov="D3 x Biospheric values" ///
           2.hhwealth#c.biov="D2 x Biospheric values" ///
           1.hhwealth#c.biov="D1 x Biospheric values" ///
           10.hhwealth#c.biov="D10 x Biospheric values") ///
xline(0) ylabel(,labsize(vsmall)) legend(position(1) ring(0) cols(1)) msize(small)

graph export coefplot_interact_biov_wealth_country.png, width(4000) replace

* Country-specific interaction: SES x biospheric values
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==1, vce(robust)
est store Ger
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==2, vce(robust)
est store Fra
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==3, vce(robust)
est store Ita
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==4, vce(robust)
est store Can
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==5, vce(robust)
est store USA
reg  total $demo $econ_1 $travel $healthwellbeing $psych $airt $house $car c.econ_stat#c.biov   if hhinc<13 & hhwealth<12 & flag==0 & educ<9 & gender<4 & country==6, vce(robust)
est store UK

cd "[YOUR_DIRECTORY]/Figures"
coefplot Ger Fra Ita Can USA UK, keep(c.econ_stat#c.biov) asequation swapnames nolabel ///
coeflabels(c.econ_stat#c.pnorm="SES x Biospheric values") ///
xline(0) ylabel(,labsize(small)) legend(off) msize(small)

graph export coefplot_interact_suffort_biov_country.png, width(4000) replace