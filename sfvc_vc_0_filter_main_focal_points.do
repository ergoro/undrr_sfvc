use "sfvc_data.dta", clear

*Fill ID for every field
replace id = id[_n-1] if missing(id)

*To filter and obtain information about main focal points only
replace title = title[_n-1] if missing(title)
keep if persons_role=="MAIN_FOCAL_POINT"
drop if missing(persons_role)
list id persons_role persons_email
