quietly{
use "sfvc_data.dta", clear
rename AY scope
keep id scopes_text scope countriesiso3_text
drop if missing(countriesiso3_text)
replace scope = scope[_n-1] if missing(scope)
}
	tab countriesiso3_text, sort
	tab countriesiso3_text scope
quietly{
encode countriesiso3_text, generate(country_num)
gen national=country_num if scope=="NATIONAL_OR_LOCAL"
gen regional=country_num if scope=="REGIONAL"
}
	graph hbar (count) country_num, over(countriesiso3_text, sort(country_num) descending) blabel(bar)
	
	graph hbar (count) national regional, over(countriesiso3_text) stack
	