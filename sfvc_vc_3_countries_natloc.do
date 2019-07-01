quietly{
use "sfvc_data.dta", clear
rename AY scope
keep id scopes_text scope countriesiso3_text
drop if missing(countriesiso3_text)
replace scope = scope[_n-1] if missing(scope)
}
	tab countriesiso3_text if scope=="NATIONAL_OR_LOCAL", sort
