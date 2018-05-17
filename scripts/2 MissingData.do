	*** MISSING DATA
	cd "F:\4. Spring 2018\4 Thesis\! Mozambique Rural Water Supply\Data\2 cleaning data\"
	use "combined_af7-nomissing-samplesize.dta", clear

	** AGE VARIABLE
	* using the year of birth to extrapolate the age of respondent
	replace B022_AGE1_b = (2011 - B022_AGE1_a) if B022_AGE1_b == -99 & (HHID != 46727 & HHID !=  46529)
	replace F017_AGE1_b = (2013 - F017_AGE1_a) if F017_AGE1_b == -99 & (HHID != 46727 & HHID !=  46529)

	*** EDUCATION VARIABLE
	* using information from a previous variable, no education means zero grade completed.
	replace B020_EDU1_GRADE = 0 if B019_EDU1_IND_a == 3 & B020_EDU1_GRADE == -99
	replace F025_EDU1_GRADE = 0 if F024_EDU1_IND_a == 3 & F025_EDU1_GRADE == -99
	replace B020_EDU1_GRADE = . if B020_EDU1_GRADE == 99 | B020_EDU1_GRADE == -99
	replace F025_EDU1_GRADE = . if F025_EDU1_GRADE == 99
	* there was a new category  (2- literate) introduced in the follow-up survey, there are only 5 such observations therefore make them missing
	replace F025_EDU1_GRADE = . if F025_EDU1_GRADE == 2
	* replace recoding 1- category to zero, then recoding the 3/4 categories to match the 2/3 categories from baseline
	replace B020_EDU1_GRADE = 0 if B020_EDU1_GRADE == 1
	replace F025_EDU1_GRADE = 0 if F025_EDU1_GRADE == 1
	replace F025_EDU1_GRADE = 2 if F025_EDU1_GRADE == 3
	replace F025_EDU1_GRADE = 3 if F025_EDU1_GRADE == 4
	save "nomissing1.dta", replace

	*** For next steps, see Reshaping do-file. 
