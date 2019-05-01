*Regions: one region per VC
quietly{
use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)
rename AY scope
replace scope = scope[_n-1] if missing(scope)
keep if scope=="NATIONAL_OR_LOCAL"
keep id scopes_text scope countriesiso3_text
order countriesiso3_text
merge m:1 countriesiso3_text using regions
drop if missing(id)
sort id
keep id scopes_text scope countriesiso3_text analysis_region
order countriesiso3_text analysis_region, last
gen africa = regexs(0) if regexm(analysis_region, "Africa")
gen americas = regexs(0) if regexm(analysis_region, "Americas")
gen asia = regexs(0) if regexm(analysis_region, "Asia")
gen europe = regexs(0) if regexm(analysis_region, "Europe")
gen oceania = regexs(0) if regexm(analysis_region, "Oceania")
keep id scopes_text africa americas asia europe oceania
sort id
by id: egen africac=count(africa) if africa=="Africa" & africa!=""
by id: egen americasc=count(americas) if americas=="Americas" & americas!=""
by id: egen asiac=count(asia) if asia=="Asia" & asia!=""
by id: egen europec=count(europe) if europe=="Europe" & europe!=""
by id: egen oceaniac=count(oceania) if oceania=="Oceania" & oceania!=""
keep id scopes_text africac americasc asiac europec oceaniac
bysort id: egen africacountry=mean(africac)
bysort id: egen americascountry=mean(americasc)
bysort id: egen asiacountry=mean(asiac)
bysort id: egen europecountry=mean(europec)
bysort id: egen oceaniacountry=mean(oceaniac)
keep id scopes_text africacountry americascountry asiacountry europecountry oceaniacountry
sort id scopes_text
drop if missing(scopes_text)
gen africa = africacountry
replace africa = 1 if missing(africacountry) & regexm(scopes_text, "Africa")
gen americas = americascountry
replace americas = 1 if missing(americascountry) & regexm(scopes_text, "Americas")
gen asia = asiacountry
replace asia = 1 if missing(asiacountry) & regexm(scopes_text, "Asia")
gen europe = europecountry
replace europe = 1 if missing(europecountry) & regexm(scopes_text, "Europe")
gen oceania = oceaniacountry
replace oceania = 1 if missing(oceaniacountry) & regexm(scopes_text, "Oceania")
keep id africa americas asia europe oceania
by id: egen Africa=count(africa)
by id: egen Americas=count(americas)
by id: egen Asia=count(asia)
by id: egen Europe=count(europe)
by id: egen Oceania=count(oceania)
drop africa americas asia europe oceania
egen africa=total(Africa)
egen americas=total(Americas)
egen asia=total(Asia)
egen europe=total(Europe)
egen oceania=total(Oceania)
drop id Africa Americas Asia Europe Oceania
keep if _n==1
*This calculation assumes a VC cover a region only ONE time (NOT as many times as countries/territories are said to be covered in a region)
}
*Number of regions covered by VCs
	list africa americas asia europe oceania
	graph bar (mean) africa americas asia europe oceania, percentage blabel(total)
quietly{
*Data on population size was obtained from World Bank Data. The average population for the period 2000 to 2017 was estimated, 2017 is the latest year available. 
*As more data is gathered in the SFVC platform, estimates could be based on or around the same period covered by VCs.
gen denAfrica=(africa/1253988181)*1000000000
gen denAmericas=(americas/1006396120)*1000000000
gen denAsia=(asia/4458423016)*1000000000
gen denEurope=(europe/744050446)*1000000000
gen denOceania=(oceania/40901664)*1000000000
}
*Density (VCs in each region accounting for the population in each region)
	list denAfrica denAmericas denAsia denEurope denOceania
	
*Regions: Number of countries in every region
quietly{
use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)
rename AY scope
replace scope = scope[_n-1] if missing(scope)
keep if scope=="NATIONAL_OR_LOCAL"
keep id scopes_text scope countriesiso3_text
order countriesiso3_text
merge m:1 countriesiso3_text using regions
drop if missing(id)
sort id
keep id scopes_text scope countriesiso3_text analysis_region
order countriesiso3_text analysis_region, last
gen africa = regexs(0) if regexm(analysis_region, "Africa")
gen americas = regexs(0) if regexm(analysis_region, "Americas")
gen asia = regexs(0) if regexm(analysis_region, "Asia")
gen europe = regexs(0) if regexm(analysis_region, "Europe")
gen oceania = regexs(0) if regexm(analysis_region, "Oceania")
keep id scopes_text countriesiso3_text africa americas asia europe oceania
sort id
by id: egen africac=count(africa) if africa=="Africa" & africa!=""
by id: egen americasc=count(americas) if americas=="Americas" & americas!=""
by id: egen asiac=count(asia) if asia=="Asia" & asia!=""
by id: egen europec=count(europe) if europe=="Europe" & europe!=""
by id: egen oceaniac=count(oceania) if oceania=="Oceania" & oceania!=""
keep id scopes_text countriesiso3_text africac americasc asiac europec oceaniac
bysort id: egen africacountry=mean(africac)
bysort id: egen americascountry=mean(americasc)
bysort id: egen asiacountry=mean(asiac)
bysort id: egen europecountry=mean(europec)
bysort id: egen oceaniacountry=mean(oceaniac)
keep id scopes_text africacountry americascountry asiacountry europecountry oceaniacountry
sort id scopes_text
drop if missing(scopes_text)
*[here please be mindful of that data for number of countries in each region is being provided from latest data on countries and regions for SFVC]
*[data as of 27 April 2019: MS Excel "SFVC_countries_territories_2019_04_27_counting"]
gen africa = africacountry
replace africa = 57 if missing(africacountry) & regexm(scopes_text, "Africa")
gen americas = americascountry
replace americas = 50 if missing(americascountry) & regexm(scopes_text, "Americas")
gen asia = asiacountry
replace asia = 51 if missing(asiacountry) & regexm(scopes_text, "Asia")
gen europe = europecountry
replace europe = 45 if missing(europecountry) & regexm(scopes_text, "Europe")
gen oceania = oceaniacountry
replace oceania = 24 if missing(oceaniacountry) & regexm(scopes_text, "Oceania")
keep id africa americas asia europe oceania
egen Africa=total(africa)
egen Americas=total(americas)
egen Asia=total(asia)
egen Europe=total(europe)
egen Oceania=total(oceania)
drop id africa americas asia europe oceania
keep if _n==1
*This calculation provides how many countries are covered in each region by VC (for VCs that selected only regions, the total number of countries in each region was assigned)
}
*Number of countries in each region covered by VCs
	list Africa Americas Asia Europe Oceania
quietly{
*Data on population size was obtained from World Bank Data. The average population for the period 2000 to 2017 was estimated, 2017 is the latest year available. 
*As more data is gathered in the SFVC platform, estimates could be based on or around the same period covered by VCs.
gen denAfrica=(Africa/1253988181)*1000000000
gen denAmericas=(Americas/1006396120)*1000000000
gen denAsia=(Asia/4458423016)*1000000000
gen denEurope=(Europe/744050446)*1000000000
gen denOceania=(Oceania/40901664)*1000000000
}
*Density (VCs in each region accounting for the number of countries in each region and population in each region)
	list denAfrica denAmericas denAsia denEurope denOceania
