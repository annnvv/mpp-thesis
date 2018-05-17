	***** REGRESSION ANALYSIS CODE ****
	set more off
	cd "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\3 Clean Data\"
	use "analysisfile_FINAL2.dta", clear

	** Set Global Variables for Regression
	global HHH female AGE1_b o.EDU1_grade_none EDU1_grade_primary EDU1_grade_secondaryplus
	global HHC HHNUM_5UP HHNUM_5UNDER
	global HH i.DISTRICT EXP_MONTHLY_2inf ag_part o.LAND_CULT_d0_none LAND_CULT_d1_quarter LAND_CULT_d2_half LAND_CULT_d3_threefourths LAND_CULT_d4_all

	* Generate Interaction Variable 
	gen inter = time*treatment_comm
	*gen triple = time*treatment_comm*ag_part
	*gen treat_ag = treatment_comm*ag_part
	*gen time_ag = time*ag_part


	* -----------------------------------------------------------------------------------------------
	graph set window fontface "Times New Roman"
	*label define time_lbl 0 "2011" 1 "2013
	*label value time time_lbl
	reg collect_time treatment_comm time inter $HHH $HHC $HH , robust
	graph bar collect_time if e(sample), over(time) over(treatment) ytitle("Mean Collection Time (in min.)") blabel(bar) yscale(range(0 120)) title(" ") subtitle(" ")
	ttest collect_time if treatment_comm == 1 & e(sample), by(time)
ttest collect_time if treatment_comm == 0 & e(sample), by(time)
	
	
	graph bar primary_walktime_total_min_2, over(time) over(treatment) ytitle("Mean Collection Time (in min.)") blabel(bar) yscale(range(0 120)) title(" ") subtitle(" ")
	graph bar ave_waittime_min, over(time) over(treatment) ytitle("Mean Collection Time (in min.)") blabel(bar) yscale(range(0 120)) title(" ") subtitle(" ")
		* need to change the data labels manually to whole numbers, instead of having a bunch of decimal points
	graph bar collect_time_0, over(time) over(treatment) ytitle("Mean Collection Time (in min.)")blabel(bar) yscale(range(0 120)) title(" ") subtitle(" ")

	* -----------------------------------------------------------------------------------------------
	reg collect_time treatment_comm time inter $HHH $HHC $HH , robust

	**** COLLECTION TIME - Regression Sample****
	reg collect_time treatment_comm time inter if e(sample), robust
		outreg2 using "reg\reg_collect_smp.doc", replace
	reg collect_time treatment_comm time inter $HHH if e(sample), robust
		outreg2 using "reg\reg_collect_smp.doc", append
	reg collect_time treatment_comm time inter $HHH $HHC if e(sample), robust
		outreg2 using "reg\reg_collect_smp.doc", append
	reg collect_time treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "reg\reg_collect_smp.doc", append
		
		**** ROUND TRIP WALKTIME TIME - Regression Sample****
	reg primary_walktime_total_min_2 treatment_comm time inter if e(sample), robust
		outreg2 using "reg\reg_walk_smp.doc", replace
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH if e(sample), robust
		outreg2 using "reg\reg_walk_smp.doc", append
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH $HHC if e(sample), robust
		outreg2 using "reg\reg_walk_smp.doc", append
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "reg\reg_walk_smp.doc", append
		
	**** WAIT TIME - Regression Sample****
	reg ave_waittime_min treatment_comm time inter if e(sample), robust
		outreg2 using "reg\reg_wait_smp.doc", replace
	reg ave_waittime_min treatment_comm time inter $HHH if e(sample), robust
		outreg2 using "reg\reg_wait_smp.doc", append
	reg ave_waittime_min treatment_comm time inter $HHH $HHC if e(sample), robust
		outreg2 using "reg\reg_wait_smp.doc", append
	reg ave_waittime_min treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "reg\reg_wait_smp.doc", append
		

	*----------------------------------------------------------------------------------------------	
	**** COLLECTION TIME - All Observations****
	reg collect_time treatment_comm time inter, robust
		outreg2 using "reg\reg_collect_all.doc", replace
	reg collect_time treatment_comm time inter $HHH , robust
		outreg2 using "reg\reg_collect_all.doc", append
	reg collect_time treatment_comm time inter $HHH $HHC , robust
		outreg2 using "reg\reg_collect_all.doc", append
	reg collect_time treatment_comm time inter $HHH $HHC $HH , robust
		outreg2 using "reg\reg_collect_all.doc", append

	* -----------------------------------------------------------------------------------------------
	**** ROUND TRIP WALKTIME TIME - All Observations****
	reg primary_walktime_total_min_2 treatment_comm time inter, robust
		outreg2 using "reg\reg_walk_all.doc", replace
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH, robust
		outreg2 using "reg\reg_walk_all.doc", append
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH $HHC, robust
		outreg2 using "reg\reg_walk_all.doc", append
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH $HHC $HH , robust
		outreg2 using "reg\reg_walk_all.doc", append

	* -----------------------------------------------------------------------------------------------	
	**** WAIT TIME - All Observations****
	reg ave_waittime_min treatment_comm time inter, robust
		outreg2 using "reg\reg_wait_all.doc", replace
	reg ave_waittime_min treatment_comm time inter $HHH, robust
		outreg2 using "reg\reg_wait_all.doc", append
	reg ave_waittime_min treatment_comm time inter $HHH $HHC, robust
		outreg2 using "reg\reg_wait_all.doc", append
	reg ave_waittime_min treatment_comm time inter $HHH $HHC $HH , robust
		outreg2 using "reg\reg_wait_all.doc", append

	* -----------------------------------------------------------------------------------------------
	*** For regression tables ***

	* Collection Time
	reg collect_time treatment_comm time inter $HHH $HHC $HH, robust	
	reg collect_time treatment_comm time inter if e(sample), robust
		outreg2 using "results_collect.doc", label replace ctitle("No Controls")
	reg collect_time treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "results_collect.doc", label append ctitle("All Controls")	

	reg collect_time treatment_comm time inter, robust
		outreg2 using "results2_collect.doc", label replace ctitle("No Controls")
	reg collect_time treatment_comm time inter $HHH $HHC $HH, robust
		outreg2 using "results2_collect.doc", label append ctitle("All Controls")

	* Walk Time
	reg collect_time treatment_comm time inter $HHH $HHC $HH, robust	
	reg primary_walktime_total_min_2 treatment_comm time inter if e(sample), robust
		outreg2 using "results_walk.doc", label replace ctitle("No Controls")
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "results_walk.doc", label append ctitle("All Controls")	

	reg primary_walktime_total_min_2 treatment_comm time inter, robust
		outreg2 using "results2_walk.doc", label replace ctitle("No Controls")
	reg primary_walktime_total_min_2 treatment_comm time inter $HHH $HHC $HH, robust
		outreg2 using "results2_walk.doc", label append  ctitle("All Controls")

	* Wait Time
	reg collect_time treatment_comm time inter $HHH $HHC $HH, robust	
	reg ave_waittime_min treatment_comm time inter if e(sample), robust
		outreg2 using "results_wait.doc", label replace ctitle("No Controls")
	reg ave_waittime_min treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "results_wait.doc", label append ctitle("All Controls")	 

	reg ave_waittime_min treatment_comm time inter, robust
		outreg2 using "results2_wait.doc", label replace ctitle("No Controls")
	reg ave_waittime_min treatment_comm time inter $HHH $HHC $HH, robust
		outreg2 using "results2_wait.doc", label append ctitle("All Controls")

	* -----------------------------------------------------------------------------------------------
	*** For deliverable: 
	*reg collect_time treatment_comm time inter $HHH $HHC $HH, robust	
	*reg collect_time treatment_comm time inter triple $HHH $HHC $HH if e(sample), robust	
	*reg collect_time treatment_comm time inter $HHH $HHC $HH if e(sample), robust	
	*reg collect_time treatment_comm time inter $HHH $HHC if e(sample), robust
	*reg collect_time treatment_comm time inter $HHH if e(sample), robust
	*reg collect_time treatment_comm time inter if e(sample), robust


