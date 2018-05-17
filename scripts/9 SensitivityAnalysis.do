	***** REGRESSIONS WITH DEPENDENT VARIABLE MISSING REPLACED WITH ZERO *****
	**** COLLECTION TIME - All Observations**** [0]
	reg collect_time_0 treatment_comm time inter, robust
		outreg2 using "reg_0\reg_collect_all_0.doc", replace
	reg collect_time_0 treatment_comm time inter $HHH , robust
		outreg2 using "reg_0\reg_collect_all_0.doc", append
	reg collect_time_0 treatment_comm time inter $HHH $HHC , robust
		outreg2 using "reg_0\reg_collect_all_0.doc", append
	reg collect_time_0 treatment_comm time inter $HHH $HHC $HH , robust
		outreg2 using "reg_0\reg_collect_all_0.doc", append

	* -----------------------------------------------------------------------------------------------
	**** ROUND TRIP WALKTIME TIME - All Observations**** [0]
	reg primary_walktime_total_min_0 treatment_comm time inter, robust
		outreg2 using "reg_0\reg_walk_all_0.doc", replace
	reg primary_walktime_total_min_0 treatment_comm time inter $HHH, robust
		outreg2 using "reg_0\reg_walk_all_0.doc", append
	reg primary_walktime_total_min_0 treatment_comm time inter $HHH $HHC, robust
		outreg2 using "reg_0\reg_walk_all_0.doc", append
	reg primary_walktime_total_min_0 treatment_comm time inter $HHH $HHC $HH , robust
		outreg2 using "reg_0\reg_walk_all_0.doc", append
	* -----------------------------------------------------------------------------------------------
	**** WAIT TIME - All Observations**** [0]
	reg ave_waittime_min_0 treatment_comm time inter, robust
		outreg2 using "reg_0\reg_wait_all_0.doc", replace
	reg ave_waittime_min_0 treatment_comm time inter $HHH, robust
		outreg2 using "reg_0\reg_wait_all_0.doc", append
	reg ave_waittime_min_0 treatment_comm time inter $HHH $HHC, robust
		outreg2 using "reg_0\reg_wait_all_0.doc", append
	reg ave_waittime_min_0 treatment_comm time inter $HHH $HHC $HH, robust
		outreg2 using "reg_0\reg_wait_all_0.doc", append
		
	* -----------------------------------------------------------------------------------------------
	* -----------------------------------------------------------------------------------------------
	**** COLLECTION TIME - Regression Sample**** [0]
	reg collect_time treatment_comm time inter $HHH $HHC $HH , robust
	
	reg collect_time_0 treatment_comm time inter if e(sample), robust
		outreg2 using "reg_0\reg_collect_smp_0.doc", replace
	reg collect_time_0 treatment_comm time inter $HHH if e(sample), robust
		outreg2 using "reg_0\reg_collect_smp_0.doc", append
	reg collect_time_0 treatment_comm time inter $HHH $HHC if e(sample), robust
		outreg2 using "reg_0\reg_collect_smp_0.doc", append
	reg collect_time_0 treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "reg_0\reg_collect_smp_0.doc", append
	* -----------------------------------------------------------------------------------------------
		**** ROUND TRIP WALKTIME TIME - Regression Sample**** [0]
	reg primary_walktime_total_min_0 treatment_comm time inter if e(sample), robust
		outreg2 using "reg_0\reg_walk_smp_0.doc", replace
	reg primary_walktime_total_min_0 treatment_comm time inter $HHH if e(sample), robust
		outreg2 using "reg_0\reg_walk_smp_0.doc", append
	reg primary_walktime_total_min_0 treatment_comm time inter $HHH $HHC if e(sample), robust
		outreg2 using "reg_0\reg_walk_smp_0.doc", append
	reg primary_walktime_total_min_0 treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "reg_0\reg_walk_smp_0.doc", append
	* -----------------------------------------------------------------------------------------------
	**** WAIT TIME - Regression Sample**** [0]
	reg ave_waittime_min_0 treatment_comm time inter if e(sample), robust
		outreg2 using "reg_0\reg_wait_smp_0.doc", replace
	reg ave_waittime_min_0 treatment_comm time inter $HHH if e(sample), robust
		outreg2 using "reg_0\reg_wait_smp_0.doc", append
	reg ave_waittime_min_0 treatment_comm time inter $HHH $HHC if e(sample), robust
		outreg2 using "reg_0\reg_wait_smp_0.doc", append
	reg ave_waittime_min_0 treatment_comm time inter $HHH $HHC $HH if e(sample), robust
		outreg2 using "reg_0\reg_wait_smp_0.doc", append

		
	* predict resid, residual
	* twoway kdensity resid
		
