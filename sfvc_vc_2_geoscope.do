quietly{
use "sfvc_data.dta", clear
rename AY scope
encode scope, generate(scope_num)
}
	tab scope
	graph hbar (count) scope_num, over(scope) blabel(bar)
