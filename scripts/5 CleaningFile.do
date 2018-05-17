	cd "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\2 cleaning data\"
	use "clean.dta", clear
	save "analysisfile.dta", replace
	set more off

	drop HOUSEHOLD_DECISION_WATERPRI - CONTRIBUTE_LABOR_NUM 
	drop HOUSEHOLD_DECISION_OTH HOUSEHOLD_DECISION_OTH
	drop SECONDARY- SECONDARY_WET_WAITTIME_HOUR
	drop THIRD- THIRD_WET_WAITTIME_HOUR
	drop NUMWIVES
	drop TYPE_PROJTRAINING_OTH AGE1_a BL_RESPONDENT SAME_HH

	* ----------------------------------------------------------------------------------------------*
	/*
	**** EXPENDITURES **** 
	* DEALING WITH MISSING DATA - EXPENDITURES: Loop to change -99 in 2011 to zero if expenditure was zero in 2013
	// get data in right order
	sort HHID time
	// to tell stata how many observations there are
	local N = _N
	local counter = 0
	local variables EXP_WEEK_CURRY EXP_WEEK_TOBACCO EXP_WEEK_DRINKS EXP_WEEK_SUGAR EXP_WEEK_LIGHTER EXP_WEEK_BREAD EXP_WEEK_SOAP EXP_WEEK_CREDIT EXP_WEEK_COOKOIL EXP_MONTH_EMPLOYEE EXP_MONTH_TRANSPORT EXP_MONTH_ENERGY EXP_MONTH_OINTMENT EXP_MONTH_UTENSIL EXP_MONTH_WATER EXP_MONTH_RICE EXP_YEAR_CEREMONIES EXP_YEAR_FEES EXP_YEAR_CONSTRUCT EXP_YEAR_CLOTHES EXP_YEAR_ANIMALS EXP_OTH_IND EXP_OTH_AMT EXP_MONTH_DOCTOR EXP_WEEK_RICE

	forvalues i = 1/`N' { // loop through all obs
		if HHID[`i'] == HHID[`i'+1] { // check if obs is missing
			foreach var of varlist `variables' {
				if `var'[`i'] == -99 & `var'[`i'+1] == 0 {
					qui replace `var' = 0 in `i' // replace missing value with new value
				local counter = `counter' + 1
				} // close if replace
			} // close loop var
		} // close IF HHID
	} // close loop N
	disp `counter'
	* changed 589 observations!
	*/

	* ----------------------------------------------------------------------------------------------*

	* DEALING WITH MISSING DATA - NUM of HH Members
	local N = _N
	local counter2 = 0

	local variables_HH  HHNUM_ALL HHNUM_5UP
	forvalues i = 1/`N' { // loop through all obs
		if HHID[`i'] == HHID[`i'+1] { // check if obs is missing
			foreach var of varlist `variables_HH' {
				if `var'[`i'] == -99 & `var'[`i'+1] == 1 {
					qui replace `var' = 1 in `i' // replace missing value with new value
				local counter2 = `counter2' + 1
				} // close if replace
			} // close loop var
		} // close IF HHID
	} // close loop N
	disp `counter2'
	* changed 26 observations!

	replace HHNUM_5UNDER = 0 if HHNUM_ALL == 1 & HHNUM_5UP == 1 & HHNUM_5UNDER == -99
	* changed 13 observations! 

	* ----------------------------------------------------------------------------------------------*

	**** REPLACE all -99 with MISSING ****
	ds, has(type numeric)
	foreach var of varlist `r(varlist)'{
		replace `var' = . if `var' == -99,
	}
	* ----------------------------------------------------------------------------------------------*

	label define commlbl 6 "Nachera" 56 "Muamethe" 7 "Namilapa (Liupo)" 57 " Mudjiriane" 8 "Pochene" 58 "Mucocorra" 9"Muanona" 59 "Xilapane" 10 "Nanluco" 60 "Nacuaho" 11 "Tcanha EP1" 61 "Naiacaji" 12 "Topuito Sede" 62 "Natugo" 13 "Mpago Sede" 63 "Namacuva" 14 "Mpuitine" 64 "Mulala" 15 "Priganha" 65 "Mavule" 16 "Mutamala" 66 "Colomoa" 17 "Naminhipire" 67 "Gelo" 21 "7 de Abril" 71 "Namalele" 22 "Napuhi" 72 "Macuano" 23 "Chilapane 2" 73 "Cabo Recula" 24 "Muachele-Vorreiwa" 74 "Injovola-Namunha" 25 "Nrepo 1" 75 "Cabo Namilo" 26 "EP1 Nagonha" 76 "Nachiue"
	label define districtlbl 1 "Mecota" 2 "Mogincual" 3 "Mogovolas" 4 "Moma" 5 "Murrupula" 6 "Rapale"
	label define time_lbl 0 "2011" 1 "2013"

	label values COMMUNITY commlbl 
	label values DISTRICT districtlbl
	label value time time_lbl


	**** DEPENDENT VARIABLE **** 
	* Generate a walking time total (multiply hours by sixty, then sum to minutes) | KEEP NAs/-99s
	gen PRIMARY_WALKTIME_HOUR_min = PRIMARY_WALKTIME_HOUR * 60 if PRIMARY_WALKTIME_HOUR != .
	gen primary_walktime_total_min = PRIMARY_WALKTIME_HOUR_min + PRIMARY_WALKTIME_MIN if PRIMARY_WALKTIME_HOUR_min != . & PRIMARY_WALKTIME_MIN != .
	*br HHID treatment_comm PRIMARY_WALKTIME_MIN PRIMARY_WALKTIME_HOUR_min primary_walktime_total_min 

	* Round-trip Walk Time!
	gen primary_walktime_total_min_2 = primary_walktime_total_min * 2

	* ----------------------------------------------------------------------------------------------*
	* A loop that counts the number of households that have observations for walk time in 2011 and 2013
	local N = _N
	local counter3 = 0
	local vars primary_walktime_total_min_2

	forvalues i = 1/`N' { // loop through all obs
		if HHID[`i'] == HHID[`i' + 1] { // check if obs is missing
			foreach var of varlist `vars' {
				if `vars'[`i'] != . &`vars'[`i' + 1] != . {
					local counter3 = `counter3' + 1
					} // close if replace
				} // close loop var
		} // close IF HHID
	} // close loop N

	disp `counter3'

	* ----------------------------------------------------------------------------------------------*

	* Generate a waiting time total - dry season (multiply hours by sixty, then sum to minutes)
	gen PRIMARY_DRY_WAITTIME_HOUR_min= PRIMARY_DRY_WAITTIME_HOUR * 60 if PRIMARY_DRY_WAITTIME_HOUR != .
	* there are two outliers of 10 and 12 hours!
	gen primary_dry_waittime_total_min = PRIMARY_DRY_WAITTIME_HOUR_min + PRIMARY_DRY_WAITTIME_MIN if PRIMARY_DRY_WAITTIME_MIN != . & PRIMARY_DRY_WAITTIME_HOUR_min != .

	* Generate a waiting time total - rainy season (multiply hours by sixty, then sum to minutes)
	gen PRIMARY_WET_WAITTIME_HOUR_min = PRIMARY_WET_WAITTIME_HOUR * 60 if PRIMARY_WET_WAITTIME_HOUR != .
	gen primary_wet_waittime_total_min = PRIMARY_WET_WAITTIME_MIN +PRIMARY_WET_WAITTIME_HOUR_min if PRIMARY_WET_WAITTIME_MIN != . & PRIMARY_WET_WAITTIME_HOUR_min != .

	* Generate an average waiting time (take wait time dry seasons plus wait time rainy season and divide by two)
	gen ave_waittime_min = (primary_dry_waittime_total_min+ primary_wet_waittime_total_min)/2

	* GENERATE COLLECTION TIME
	gen collect_time = primary_walktime_total_min_2 + ave_waittime_min

	* ----------------------------------------------------------------------------------------------*

	* Generate a walking time total [0]
	gen PRIMARY_WALKTIME_HOUR_min_0 = PRIMARY_WALKTIME_HOUR_min
		replace PRIMARY_WALKTIME_HOUR_min_0 = 0 if PRIMARY_WALKTIME_HOUR_min_0 == . 
	gen PRIMARY_WALKTIME_MIN_0 = PRIMARY_WALKTIME_HOUR_min
		replace PRIMARY_WALKTIME_MIN_0 = 0 if PRIMARY_WALKTIME_MIN_0 == . 
		
	gen primary_walktime_total_min_0 = (PRIMARY_WALKTIME_HOUR_min_0 + PRIMARY_WALKTIME_MIN_0)*2

	gen primary_walktime_total_min_02 = (PRIMARY_WALKTIME_HOUR_min_0 + PRIMARY_WALKTIME_MIN_0)*2 if !missing(PRIMARY_WALKTIME_HOUR_min, PRIMARY_WALKTIME_HOUR)

	* Generate a dry wait time total [0]
	gen PRIMARY_DRY_WAITTIME_HOUR_min_0 =  PRIMARY_DRY_WAITTIME_HOUR_min
		replace PRIMARY_DRY_WAITTIME_HOUR_min_0 = 0 if PRIMARY_DRY_WAITTIME_HOUR_min_0 == .
	gen PRIMARY_DRY_WAITTIME_MIN_0 = PRIMARY_DRY_WAITTIME_MIN
		replace PRIMARY_DRY_WAITTIME_MIN_0 = 0 if PRIMARY_DRY_WAITTIME_MIN_0 == . 
		
	gen primary_dry_waittime_total_min_0 = PRIMARY_DRY_WAITTIME_HOUR_min_0 + PRIMARY_DRY_WAITTIME_MIN_0

	* Generate a wet wait time total [0]	 
	gen PRIMARY_WET_WAITTIME_HOUR_min_0 = PRIMARY_WET_WAITTIME_HOUR_min
		replace PRIMARY_WET_WAITTIME_HOUR_min_0 = 0 if PRIMARY_WET_WAITTIME_HOUR_min_0 == . 
		
	gen PRIMARY_WET_WAITTIME_MIN_0 = PRIMARY_WET_WAITTIME_MIN
		replace PRIMARY_WET_WAITTIME_MIN_0 = 0 if PRIMARY_WET_WAITTIME_MIN_0 == . 

	gen primary_wet_waittime_total_min_0 = PRIMARY_WET_WAITTIME_HOUR_min_0 + PRIMARY_WET_WAITTIME_MIN_0
		
	* Generate an average waiting time [0]
	gen ave_waittime_min_0 = (primary_dry_waittime_total_min_0 + primary_wet_waittime_total_min_0)/2

	* GENERATE COLLECTION TIME [0]
	gen collect_time_0 = primary_walktime_total_min_0 + ave_waittime_min_0

	* -----------------------------------------------------------------------------------------------

	****DEALING WITH RICE EXPENDITURES
	gen EXP_MONTH_rice_B = EXP_WEEK_RICE * 4
	replace EXP_MONTH_rice_B = 0 if EXP_MONTH_rice_B == . 

	gen EXP_MONTH_RICE_A = EXP_MONTH_RICE
	replace EXP_MONTH_RICE_A = 0 if EXP_MONTH_RICE_A  == . 

	generate EXP_MONTHLY_RICE = EXP_MONTH_rice_B + EXP_MONTH_RICE_A 
	replace EXP_MONTHLY_RICE = . if EXP_WEEK_RICE == . & EXP_MONTH_RICE == .

	* Generate total monthly expeditures data from weekly data
	gen EXP_MONTHLY_CURRY = EXP_WEEK_CURRY * 4
	gen EXP_MONTHLY_TOBACCO = EXP_WEEK_TOBACCO* 4
	gen EXP_MONTHLY_DRINKS = EXP_WEEK_DRINKS * 4
	gen EXP_MONTHLY_SUGAR = EXP_WEEK_SUGAR * 4
	gen EXP_MONTHLY_LIGHTER = EXP_WEEK_LIGHTER * 4 
	gen EXP_MONTHLY_BREAD = EXP_WEEK_BREAD * 4
	gen EXP_MONTHLY_SOAP = EXP_WEEK_SOAP * 4
	gen EXP_MONTHLY_CREDIT = EXP_WEEK_CREDIT * 4
	gen EXP_MONTHLY_COOKOIL = EXP_WEEK_COOKOIL * 4

	* Generate total monthly expeditures data from annual data
	gen EXP_MONTHLY_CEREMONIES = EXP_YEAR_CEREMONIES / 12
	gen EXP_MONTHLY_FEES = EXP_YEAR_FEES / 12
	gen EXP_MONTHLY_CONSTRUCT = EXP_YEAR_CONSTRUCT / 12
	gen EXP_MONTHLY_CLOTHES = EXP_YEAR_CLOTHES / 12 
	gen EXP_MONTHLY_ANIMALS = EXP_YEAR_ANIMALS / 12

	* Generate a new variable MONTHLY (instead of just MONTH)
	gen EXP_MONTHLY_EMPLOYEE = EXP_MONTH_EMPLOYEE
	gen EXP_MONTHLY_TRANSPORT = EXP_MONTH_TRANSPORT 
	gen EXP_MONTHLY_ENERGY = EXP_MONTH_ENERGY
	gen EXP_MONTHLY_OINTMENT = EXP_MONTH_OINTMENT
	gen EXP_MONTHLY_UTENSIL = EXP_MONTH_UTENSIL
	gen EXP_MONTHLY_WATER = EXP_MONTH_WATER

	* Generate a total monthly HH expenditure 
	gen EXP_MONTHLY = EXP_MONTHLY_RICE+ EXP_MONTHLY_CURRY+ EXP_MONTHLY_TOBACCO+ EXP_MONTHLY_DRINKS+ EXP_MONTHLY_SUGAR+ EXP_MONTHLY_LIGHTER+ EXP_MONTHLY_BREAD+ EXP_MONTHLY_SOAP+ EXP_MONTHLY_CREDIT+ EXP_MONTHLY_COOKOIL+ EXP_MONTHLY_CEREMONIES+ EXP_MONTHLY_FEES+ EXP_MONTHLY_CONSTRUCT+ EXP_MONTHLY_CLOTHES+ EXP_MONTHLY_ANIMALS+ EXP_MONTHLY_EMPLOYEE+ EXP_MONTHLY_TRANSPORT+ EXP_MONTHLY_ENERGY+ EXP_MONTHLY_OINTMENT+ EXP_MONTHLY_UTENSIL+ EXP_MONTHLY_WATER


	*** CONTROL VARIABLES
	* Generate Dummies for Grade/Education Variable
	tab EDU1_GRADE, generate(EDU1_grade_)
	rename EDU1_grade_1 EDU1_grade_none
	rename EDU1_grade_2 EDU1_grade_primary
	rename EDU1_grade_3 EDU1_grade_secondaryplus

	* Generate Dummies for Land Cultivation
	replace LAND_CULT = . if LAND_CULT == 6

	/* commenting this out because 'imputation' is done in the 6th do file and this variable is generated again
	tab LAND_CULT, generate(LAND_CULT_d)
	rename LAND_CULT_d1 LAND_CULT_d0_none
	rename LAND_CULT_d2 LAND_CULT_d1_quarter
	rename LAND_CULT_d3 LAND_CULT_d2_half
	rename LAND_CULT_d4 LAND_CULT_d3_threefourths
	rename LAND_CULT_d5 LAND_CULT_d4_all */

	*Recode Gender to binary FEMALE
	gen female = .
	replace female = 0 if GENDER1 == 1
	replace female = 1 if GENDER1 == 2

	label define female_lbl 0 "Male" 1  "Female"
	label values female female_lbl

	*Recode AG participation to Binary 
	gen ag_part = .
	replace ag_part = 0 if AG_PART_IND == 2
	replace ag_part = 1 if AG_PART_IND == 1

	label define yesno_lbl 0 "No" 1 "Yes" 
	label values ag_part yesno_lbl

	drop PRIMARY_WALKTIME_MIN  PRIMARY_WALKTIME_HOUR PRIMARY_DRY_WAITTIME_MIN PRIMARY_DRY_WAITTIME_HOUR PRIMARY_WET_WAITTIME_MIN PRIMARY_WET_WAITTIME_HOUR PRIMARY_WALKTIME_HOUR_min PRIMARY_DRY_WAITTIME_HOUR_min PRIMARY_WET_WAITTIME_HOUR_min primary_walktime_total_min primary_dry_waittime_total_min primary_wet_waittime_total_min PRIMARY_WALKTIME_HOUR_min_0  PRIMARY_WALKTIME_MIN_0  PRIMARY_DRY_WAITTIME_HOUR_min_0 PRIMARY_DRY_WAITTIME_MIN_0  PRIMARY_WET_WAITTIME_HOUR_min_0 PRIMARY_WET_WAITTIME_MIN_0 primary_dry_waittime_total_min_0 primary_wet_waittime_total_min_0

	save "analysisfile_1.dta", replace

	*** For next steps, see 6 Imputation do-file. *** 
