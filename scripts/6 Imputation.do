	*** IMPUTATION - sort of ***
	cd "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\2 cleaning data\"
	use "analysisfile_1.dta", clear

	*** MISSING DATA - Number above 5 and under 5 ***
	** solution: cannot do anything because any missing data is missing for all three variable (all, above 5 and under 5)
	* however all are missing from the before period!

	** NO MISSING FOR FEMALE ***
	** NO MISSING FOR AGE *** 

	** EDU1_GRADE - missing 11 observations ***
	/*
	HHID	time	EDU1_IND_a	EDU1_GRADE
	30742	0	No	
	30762	1	Yes-As Child	
	30904	1	Yes-As Child	
	31042	1	Yes-As Adult	
	31121	1	Yes-As Adult	
	31123	1	Yes-As Adult	
	31146	1	Yes-As Child	
	62249	1	Yes-As Child	
	62345	1	Yes-As Adult	
	62446	1	Yes-As Child	
	62562	0	Yes-As Adult */

	*** NO MISSING DATA DISTRICT *** 
	*** AG_PART - one missing observation***


	*** MISSING DATA in LAND_CULT variable, a lot of missing observations in before variable ****
	** SOLUTION: set before value to be the same as the after value (category)


	*** Panel data VARIABLEs- HHID and time
	sort HHID time
	xtset HHID time
	gen diff_lc = D1.LAND_CULT

	/*
	. tab2 diff_lc treatment_comm

	-> tabulation of diff_lc by treatment_comm  

			   |    treatment_comm
	   diff_lc |   Control  Treatment |     Total
	-----------+----------------------+----------
			-4 |         3          0 |         3 
			-3 |         8          1 |         9 
			-2 |        12          4 |        16 
			-1 |        33          4 |        37 
			 0 |        20         14 |        34 
			 1 |        12          3 |        15 
			 2 |         7          0 |         7 
			 3 |        10          2 |        12 
			 4 |         4          0 |         4 
	-----------+----------------------+----------
		 Total |       109         28 |       137 



	 tab2 diff_lc treatment_comm

	-> tabulation of diff_lc by treatment_comm  

			   |    treatment_comm
	   diff_lc |   Control  Treatment |     Total
	-----------+----------------------+----------
			-4 |         1          0 |         1 
			-3 |         2          1 |         3 
			-2 |         7          4 |        11 
			-1 |        11          2 |        13 
			 0 |         8         13 |        21 
			 1 |         4          3 |         7 
			 2 |         3          0 |         3 
			 3 |         5          1 |         6 
			 4 |         2          0 |         2 
	-----------+----------------------+----------
		 Total |        43         24 |        67 
	*/



	** Dummy is 1 if land_cultivation did not change (-1,0,1), 0 if changed
	gen cult_change = .
		replace cult_change = 1 if inrange(diff_lc, -1,1) 
	*no change before and after
		replace cult_change = 0 if diff_lc < -1 | diff_lc > 1 & diff_lc != . 
	* change 


	/*reg cult_change female AGE1_b EDU1_grade_none EDU1_grade_primary EDU1_grade_secondaryplus HHNUM_5UP HHNUM_5UNDER
		predict cult_change_pred if time == 1, xb 

	 br HHID cult_change cult_change_pred time
	* Predicting NO CHANGE - pretty good at predicting no change
	. count if cult_change == 1
	  86
	. count if cult_change == 1 & cult_change_pred >0.5
	  81
	. count if cult_change == 1 & cult_change_pred <0.5
	  5
	  * Predicting CHANGE - really bad at predicting change
	. count if cult_change == 0
	  51
	. count if cult_change == 0 & cult_change_pred <0.5
	  1
	. count if cult_change == 0 & cult_change_pred >0.5
	  50

	  * decided that logit is a slightly better predictor than LPM
	*/

	logit cult_change female AGE1_b EDU1_grade_none EDU1_grade_primary EDU1_grade_secondaryplus HHNUM_5UP HHNUM_5UNDER ag_part
		predict cult_change_pred_logit if time == 1
		
	/*
	* Predicting NO CHANGE - pretty good at predicting no change
	. count if cult_change == 1
	  86
	. count if cult_change == 1 & cult_change_pred_logit >0.5
	  81
	. count if cult_change == 1 & cult_change_pred_logit <0.5
	  5
	 * Predicting CHANGE - pretty bad at predicting change
	. count if cult_change == 0
	  51
	. count if cult_change == 0 & cult_change_pred_logit <0.5
	  3
	. count if cult_change == 0 & cult_change_pred_logit >0.5
	  48
	*/

	logit cult_change female AGE1_b EDU1_grade_none EDU1_grade_primary EDU1_grade_secondaryplus HHNUM_5UP HHNUM_5UNDER ag_part
		predict cult_change_pred_logit_all if time ==1 

	gen LAND_CULT_imp = LAND_CULT

	sort HHID time
	local counter4 = 0
	local landcult LAND_CULT_imp
	local N = _N

	forvalues i = 1/`N' { // loop through all obs
		if HHID[`i'] == HHID[`i'+1] { // check if obs is missing
			foreach var of varlist `landcult' {
				 if `var'[`i'] == . & `var'[`i'+1] != . & cult_change_pred_logit_all[`i' + 1] >0.5 {
					qui replace `var' = `var'[`i'+1] in `i' // replace missing  before value with after value (no change in land cultivation)
				 local counter4 = `counter4' + 1
				 } // close if replace
			} // close loop var
		} // close IF HHID
	} // close loop N
	disp `counter4'

	* changed 169 observations

	*** 1 caveat - overpredicting (because taking into account -1, 0, 1)
	*** 2 caveat - roughly constant (predict no change)
	*** 3 caveat - do not predict change
	***** therefore biases results

	* Loop to population before values if after values are present
	local counter5 = 0
	local landcult LAND_CULT_imp
	local N = _N

	forvalues i = 1/`N' { // loop through all obs
		if HHID[`i'] == HHID[`i'+1] { // check if obs is missing
			foreach var of varlist `landcult' {
				 if `var'[`i'+ 1] == . & `var'[`i'] != . & cult_change_pred_logit_all[`i' + 1] >0.5 {
				 local obs_no = `i' + 1
					qui replace `var' = `var'[`i'] in `obs_no' // replace missing  after value with before value (no change in land cultivation)
				 local counter5 = `counter5' + 1
				 } // close if replace
			} // close loop var
		} // close IF HHID
	} // close loop N
	disp `counter5'
	* changed 11 observations

	tab LAND_CULT_imp, generate(LAND_CULT_d)
		rename LAND_CULT_d1 LAND_CULT_d0_none
		rename LAND_CULT_d2 LAND_CULT_d1_quarter
		rename LAND_CULT_d3 LAND_CULT_d2_half
		rename LAND_CULT_d4 LAND_CULT_d3_threefourths
		rename LAND_CULT_d5 LAND_CULT_d4_all

	save "analysisfile_2.dta", replace


	*** For next steps, see 7 Imputation do-file. *** 

	/*
	tab2 LAND_CULT treatment_comm if time == 0
	tab2 LAND_CULT treatment_comm if time == 1
	tab2 LAND_CULT_imp treatment_comm if time == 0
	tab2 LAND_CULT_imp treatment_comm if time == 1

	gen diff_lc_imp = D1.LAND_CULT_imp
	*/

	/*
	. tab2 diff_lc_imp treatment_comm
	-> tabulation of diff_lc_imp by treatment_comm  

	diff_lc_im |    treatment_comm
			 p |   Control  Treatment |     Total
	-----------+----------------------+----------
			-4 |         1          0 |         1 
			-3 |         2          1 |         3 
			-2 |         7          4 |        11 
			-1 |        11          2 |        13 
			 0 |       136        116 |       252 
			 1 |         4          3 |         7 
			 2 |         3          0 |         3 
			 3 |         5          1 |         6 
			 4 |         2          0 |         2 
	-----------+----------------------+----------
		 Total |       171        127 |       298 
	*/
