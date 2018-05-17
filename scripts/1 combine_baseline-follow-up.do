	/* MERGE BASE-LINE & FOLLOW-UP FILES */

	/* FOLLOW-UP */
	use "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\1 raw\Followup_HH_Survey_Anonymized_Data_2014-04-05.dta" 
	isid F010_HHID
	rename F010_HHID HHID
	save "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\1 raw\Stata Files"

	/* BASELINE */
	use "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\1 raw\\Baseline_HH_Survey_Anonymized_Data_2014-04-05.dta" 
	des
	isid B010_HHID
	rename B010_HHID HHID
	cd "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\1 raw\Stata Files"
	save "Baseline_HH_Survey_Anonymized_Data_2014-04-05.dta"
	
	merge 1:1 HHID using "Followup_HH_Survey_Anonymized_Data_2014-04-05"
	/*
		Result                           # of obs.
		-----------------------------------------
		not matched                         1,111
			from master                       432  (_merge==1)
			from using                        679  (_merge==2)

		matched                             1,147  (_merge==3) /* IN BOTH FILES */
		-----------------------------------------
	*/

	rename _merge _mergeBL_FU
	save combined


	drop B012_CONSENT_a-B014_CONSENT_YN F019_CONSENT_a-F021_CONSENT_YN
	drop B564_GPS_LATITUDE F645_GPS_LATITUDE B564_GPS_LONGITUDE F645_GPS_LONGITUDE
	log using listvars
	des
	log close
	save combined_2

	tab2 F503_TREAT_TIME_MORELESS  F512_CONTROL_TIME_MORELESS
	/*
	. -> tabulation of F503_TREAT_TIME_MORELESS by F512_CONTROL_TIME_MORELESS  

	F503_TREAT |
	_TIME_MORE |               F512_CONTROL_TIME_MORELESS
		  LESS |         1          2          3          4         NA |     Total
	-----------+-------------------------------------------------------+----------
			 1 |         0          0          0          0        162 |       162 
			 2 |         0          0          0          0        143 |       143 
			 3 |         0          0          0          0        192 |       192 
			 4 |         0          0          0          0          9 |         9 
			NA |       143         33        424         41          0 |       641 
	-----------+-------------------------------------------------------+----------
		 Total |       143         33        424         41        506 |     1,147 
	*/

	/* NOW ONLY RETAIN MATCHED RECORDS */
	keep if _mergeBL_FU == 3 /* TO RETAIN ONLY MATCHED HHIDs */
	save combined_af1.dta

	/*generate treatment = .
	replace treatment = 1 if F503_TREAT_TIME_MORELESS == "1" | F503_TREAT_TIME_MORELESS == "2" |F503_TREAT_TIME_MORELESS == "3" | F503_TREAT_TIME_MORELESS == "4"
	replace treatment = 0 if F503_TREAT_TIME_MORELESS == "NA"*/

	/*. tab F012

	F012_BL_RES |
		PONDENT |      Freq.     Percent        Cum.
	------------+-----------------------------------
			  1 |        916       79.86       79.86
			  2 |        231       20.14      100.00
	------------+-----------------------------------
		  Total |      1,147      100.00
	After this point, F012 == 1
		  */
	save combined_af2.dta, replace

	*** KEEPS ONLY COMMUNITIES OF INTEREST*** 
	notes: Keeps only Matched HHIDs (Baseline/Follow-up)in Phase 2
	keep if inlist(B007_COMMUNITY, 6,56,7,57,8,58,9,59,10,60,11,61,12,62,13,63,14,64,15,65,16,66,17,67,21,70,71,22,72,23,73,24,74,25,75,26,76) 

	save combined_af3.dta, replace

	*Drop unnecessary variables 
	drop B001_SURVEYOR B002_SURVEYOR_OTH B005_TIME B006_DURATION B008_DAY B009_MONTH F001_SURVEYOR F002_SURVEYOR_OTH F005_TIME F007_DURATION F008_DAY F009_MONTH F643_INT_QUALITY F644_INT_REASON B562_INT_QUALITY B563_INT_REASON

	*Drop Health Module Variables (Baseline and Follow-Up)
	drop B401__F_EFFORT_GARDEN- B489_HANDWASH_FAMILY  
	drop F103_F_EFFORT_FIELD - F123_SLEEP
	drop F522_FOOD_ID_A - F537_VISIT_MED_MONEY 

	*Drop Sanitation Module Variables (Baseline and Follow-Up)
	*drop B445_VISIT_DISTHOSP - B489_HANDWASH_FAMILY */ for some reason doesn't want to drop these
	drop F539_ADULT_DEFECATE - F561_HANDWASHSOAP_FREQ

	*Drop Participation Module Variables (Baseline and Follow-Up)
	drop B204_WHOINITATE_WATERPROJECT - B210_LANDOWN_WATERSOURCE_OTHID 
	drop B227_WHOOWNS_WATERSOURCE_A - B233_WATERPROJ_OWNER_COMM

	*Drop Unncessary Variables (Baseline and Follow-Up)
	drop B185_CONCERN1_ID - B200_WOMENSIT_IMPROVED_OTH 
	drop F076_CONCERN1_ID - F099_TREAT_WOMENSIT_IMPROVED_h

	save combined_af4.dta, replace

	*Destring all variables
	use "combined_af4.dta"

	*** LOOP to replace string NA's with -99 and destring
	ds B003_DISTRICT - F642_ASSIST_RESP_E, has(type string)
	foreach var of varlist `r(varlist)'{
		replace `var' = "-99" if strpos(`var', "NA")
		destring `var', replace
	}

	save combined_af4-destringed.dta, replace

	*install missings package
	* drop variables that have all missing values
	 missings dropvars
	*  B181_HOUSEOWN_OTH B213_HOUSEHOLD_DECISION_OTHID B270_PRIMARY_WETUSE_OTH dropped
	 
	save combined_af5-nomissing.dta, replace

	*** NEW TREATMENT VARIABLE ***
	drop treatment
	gen treatment_comm = .
		* Treatment Communities
		replace treatment_comm = 1 if inlist(B007_COMMUNITY, 7,9,10,11,16,21,23,25,56,57,58,60,67) 
		* Control Communities
		replace treatment_comm = 0 if inlist(B007_COMMUNITY, 6,8,12,13,14,15,17,22,24,59,61,62,63,64,65,66,70,71,72,73,74,75,76)

	/* old treatment/control assignments based on evaluation design April 2013
	gen treatment_comm = .
	replace treatment_comm = 1 if inlist(B007_COMMUNITY, 6,9,10,11,21,23,25,56,58)
	replace treatment_comm = 0 if inlist(B007_COMMUNITY, 7,8,12,13,14,15,16,17,22,24,26)
	*/

	label define treat_control_lbl 0 "Control" 1 "Treatment"
	label values treatment_comm treat_control_lbl

	save combined_af6-nomissing.dta, replace

	*** Drop all observation that aren't in the treatment or control groups! 
	drop if treatment_comm == .
	save combined_af7-nomissing-samplesize.dta, replace

	/*Generate a new variable that is the total household size 
	destring B037_HHNUM_5UP B159_HHNUM_5UNDER, ignore(NA) replace
	gen HH_Size = B037_HHNUM_5UP + B159_HHNUM_5UNDER

	*Seeing whether there is a difference between baseline and follow-up difference in HH size
	gen diff_hhsize = F031_HHNUM_ALL - HH_Size
	sum diff_hhsize
	ttest HH_Size == F031_HHNUM_ALL*/

