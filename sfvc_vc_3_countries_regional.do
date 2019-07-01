quietly{
*this analyses VCs that have Regional scope AND have specifically selected countries
*it does not count VCs that have Regional scope and did not selected any country (user selected only region name)
*otherwise, we should count all countries for each region selected by a VC (again, when only the name of the region was selected)
*it is similar to the Global scope case where all countries are covered (for VCs that selected Regional scope and only region name, all countries in that region are covered)
use "sfvc_data.dta", clear
rename AY scope
keep id scopes_text scope countriesiso3_text
drop if missing(countriesiso3_text)
replace scope = scope[_n-1] if missing(scope)
}
*this is for VCs with Regional scope that specifically selected countries
	tab countriesiso3_text if scope=="REGIONAL", sort
