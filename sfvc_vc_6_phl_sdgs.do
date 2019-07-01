quietly{
use "sfvc_data.dta", clear
rename AY scope
replace id = id[_n-1] if missing(id)
gen phl=.
replace phl=1 if countriesiso3_text=="PHL"
bysort id: egen phl_c=mean(phl)
drop if missing(phl_c)
}
	tab selectedsdgs_keyword
	
quietly{
encode id, generate(id_num)
gen disability=1 if id=="20190219_001"
gen preparedness=1 if id=="20190301_001"
gen local_gov=1 if id=="20190306_001"
gen hazards=1 if id=="20190308_001"
}
	graph hbar disability preparedness local_gov hazards, over(selectedsdgs_keyword) stack

