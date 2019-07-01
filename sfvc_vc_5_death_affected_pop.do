quietly{
clear
import excel "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\disasters_em_dat_countries_2019_05_07.xlsx", sheet("disasters_em_dat_countries_2019") firstrow
save "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\em_dat_countries.dta", replace
clear
import excel "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\population_2019_05_24.xlsx", sheet("Data") firstrow
rename CountryCode iso
order iso
save "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\population.dta", replace
clear
import excel "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\countries_sfvc_2019_05_24.xlsx", sheet("countries") firstrow
save "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\countries_sfvc.dta", replace
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
drop dup
drop if missing(deathtoll_avg)
merge m:1 iso using population
drop if missing(year)
drop _merge
egen pop_avg=rmean(AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ)
merge m:1 iso using countries_sfvc
drop if missing(year)
drop _merge
gen deathtoll_avg_pop=(deathtoll_avg/pop_avg)*1000000
drop if missing(deathtoll_avg_pop)
sort deathtoll_avg_pop
}
*Average death toll by country accounting for population (2000-2018)
*Please keep in mind that EM-DAT data is being constantly updated
	list country_name deathtoll_avg_pop
quietly{
keep if deathtoll_avg_pop>50
}
	graph hbar deathtoll_avg_pop, over(country_name, sort(deathtoll_avg_pop) descending) blabel(bar) ytitle("Millions") title("Average death toll accounting for population(2000-2018)") ylabel(,labsize(vsmall)) xsize(4) ysize(5) graphregion(margin(l+35 r+2))

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
merge m:1 iso using population
drop if missing(year)
drop _merge
egen pop_avg=rmean(AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ)
merge m:1 iso using countries_sfvc
drop if missing(year)
drop _merge
gen affected_avg_pop=(affected_avg/pop_avg)*1000000
drop if missing(affected_avg_pop)
sort affected_avg_pop
}
*Average affected (injured, affected and homeless) by country accounting for population (2000-2018)
*Please keep in mind that EM-DAT data is being constantly updated
	list country_name affected_avg_pop
quietly{
keep if affected_avg_pop>70000
}
	graph hbar affected_avg_pop, over(country_name, sort(affected_avg_pop) descending label(labsize(vsmall))) blabel(bar) ytitle("Millions") title("Average affected accounting for population (2000-2018)") ylabel(,labsize(vsmall)) xsize(4) ysize(5) graphregion(margin(l+40 r+2))
