quietly{
clear
import excel "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\disasters_em_dat_countries_2019_05_07.xlsx", sheet("disasters_em_dat_countries_2019") firstrow
save "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\em_dat_countries.dta", replace
}
quietly{
use "em_dat_countries.dta", clear
drop if missing(year)
drop if _n==_N
drop if _n==_N
destring year, replace
drop if year<2000
drop if year>2018
keep if disastergroup=="Natural"
sort country year
by country: egen deathtoll=total(Totaldeaths)
by country: egen deathtoll_avg=mean(Totaldeaths)
by country:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop if missing(deathtoll_avg)
gen deathtoll_avg_t=deathtoll_avg/1000
sort deathtoll_avg_t
}
*Average death toll by country (2000-2018)
*Please keep in mind that EM-DAT data is being constantly updated
	list country_name deathtoll_avg_t
quietly{
keep if deathtoll_avg_t>0.3
}
	graph hbar deathtoll_avg_t, over(country_name, sort(deathtoll_avg_t) descending) blabel(bar) ytitle("Thousands") title("Average death toll (2000-2018)")

quietly{
use "em_dat_countries.dta", clear
drop if missing(year)
drop if _n==_N
drop if _n==_N
destring year, replace
drop if year<2000
drop if year>2018
keep if disastergroup=="Natural"
sort country year
by country: egen affected_avg=mean(Totalaffected)
by country:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop if missing(affected_avg)
gen affected_avg_t=affected_avg/1000
sort affected_avg_t
}
*Average affected (injured, affected and homeless) by country (2000-2018)
*Please keep in mind that EM-DAT data is being constantly updated
	list country_name affected_avg_t
quietly{
keep if affected_avg_t>600
}
	graph hbar affected_avg_t, over(country_name, sort(affected_avg_t) descending label(labsize(vsmall))) blabel(bar) ytitle("Thousands") title("Average affected (2000-2018)") ylabel(,labsize(vsmall)) xsize(4) ysize(5) graphregion(margin(l+27 r+2))
	