*Regions: one region per VC
quietly{
use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)
rename AY scope
keep id scopes_text scope countriesiso3_text
order countriesiso3_text
merge m:1 countriesiso3_text using regions_UNDRR
drop if missing(id)
sort id
keep id scopes_text scope countriesiso3_text analysis_region unisdr_region_name
order countriesiso3_text analysis_region unisdr_region_name, last
gen africa = regexs(0) if regexm(unisdr_region_name, "Africa")
gen americas = regexs(0) if regexm(unisdr_region_name, "Americas")
gen arab_states = regexs(0) if regexm(unisdr_region_name, "Arab States")
gen asia_pacific = regexs(0) if regexm(unisdr_region_name, "Asia-Pacific")
gen europe = regexs(0) if regexm(unisdr_region_name, "Europe")
keep id scopes_text africa americas arab_states asia_pacific europe
sort id
by id: egen africac=count(africa) if africa=="Africa" & africa!=""
by id: egen americasc=count(americas) if americas=="Americas" & americas!=""
by id: egen arab_statesc=count(arab_states) if arab_states=="Arab States" & arab_states!=""
by id: egen asia_pacificc=count(asia_pacific) if asia_pacific=="Asia-Pacific" & asia_pacific!=""
by id: egen europec=count(europe) if europe=="Europe" & europe!=""
keep id scopes_text africac americasc arab_statesc asia_pacificc europec
bysort id: egen africacountry=mean(africac)
bysort id: egen americascountry=mean(americasc)
bysort id: egen arab_statescountry=mean(arab_statesc)
bysort id: egen asia_pacificcountry=mean(asia_pacificc)
bysort id: egen europecountry=mean(europec)
keep id scopes_text africacountry americascountry arab_statescountry asia_pacificcountry europecountry
sort id scopes_text
drop if missing(scopes_text)
gen africa = africacountry
*replace africa = 1 if missing(africacountry) & regexm(scopes_text, "Africa")
gen americas = americascountry
*replace americas = 1 if missing(americascountry) & regexm(scopes_text, "Americas")
gen arab_states = arab_statescountry
*replace asia = 1 if missing(asiacountry) & regexm(scopes_text, "Asia")
gen asia_pacific = asia_pacificcountry
*replace europe = 1 if missing(europecountry) & regexm(scopes_text, "Europe")
gen europe = europecountry
*replace oceania = 1 if missing(oceaniacountry) & regexm(scopes_text, "Oceania")
keep id africa americas arab_states asia_pacific europe
by id: egen Africa=count(africa)
by id: egen Americas=count(americas)
by id: egen Arab_States=count(arab_states)
by id: egen Asia_Pacific=count(asia_pacific)
by id: egen Europe=count(europe)
drop africa americas arab_states asia_pacific europe
egen africa=total(Africa)
egen americas=total(Americas)
egen arab_states=total(Arab_States)
egen asia_pacific=total(Asia_Pacific)
egen europe=total(Europe)
drop id Africa Americas Arab_States Asia_Pacific Europe
keep if _n==1
*This calculation assumes a VC cover a region only ONE time (NOT as many times as countries/territories are said to be covered in a region)
}
*Number of regions covered by VCs
	list africa americas arab_states asia_pacific europe
	graph bar (mean) africa americas arab_states asia_pacific europe, percentage blabel(total)

*Regions: one region per VC for REGIONAL SCOPE
quietly{
use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)
rename AY scope
replace scope = scope[_n-1] if missing(scope)
keep if scope=="REGIONAL"
keep id scopes_text scope countriesiso3_text
order countriesiso3_text
merge m:1 countriesiso3_text using regions_UNDRR
drop if missing(id)
sort id
keep id scopes_text scope countriesiso3_text analysis_region unisdr_region_name
order countriesiso3_text analysis_region unisdr_region_name, last
gen africa = regexs(0) if regexm(unisdr_region_name, "Africa")
gen americas = regexs(0) if regexm(unisdr_region_name, "Americas")
gen arab_states = regexs(0) if regexm(unisdr_region_name, "Arab States")
gen asia_pacific = regexs(0) if regexm(unisdr_region_name, "Asia-Pacific")
gen europe = regexs(0) if regexm(unisdr_region_name, "Europe")
keep id scopes_text africa americas arab_states asia_pacific europe
sort id
by id: egen africac=count(africa) if africa=="Africa" & africa!=""
by id: egen americasc=count(americas) if americas=="Americas" & americas!=""
by id: egen arab_statesc=count(arab_states) if arab_states=="Arab States" & arab_states!=""
by id: egen asia_pacificc=count(asia_pacific) if asia_pacific=="Asia-Pacific" & asia_pacific!=""
by id: egen europec=count(europe) if europe=="Europe" & europe!=""
keep id scopes_text africac americasc arab_statesc asia_pacificc europec
bysort id: egen africacountry=mean(africac)
bysort id: egen americascountry=mean(americasc)
bysort id: egen arab_statescountry=mean(arab_statesc)
bysort id: egen asia_pacificcountry=mean(asia_pacificc)
bysort id: egen europecountry=mean(europec)
keep id scopes_text africacountry americascountry arab_statescountry asia_pacificcountry europecountry
sort id scopes_text
drop if missing(scopes_text)
gen africa = africacountry
*replace africa = 1 if missing(africacountry) & regexm(scopes_text, "Africa")
gen americas = americascountry
*replace americas = 1 if missing(americascountry) & regexm(scopes_text, "Americas")
gen arab_states = arab_statescountry
*replace asia = 1 if missing(asiacountry) & regexm(scopes_text, "Asia")
gen asia_pacific = asia_pacificcountry
*replace europe = 1 if missing(europecountry) & regexm(scopes_text, "Europe")
gen europe = europecountry
*replace oceania = 1 if missing(oceaniacountry) & regexm(scopes_text, "Oceania")
keep id africa americas arab_states asia_pacific europe
by id: egen Africa=count(africa)
by id: egen Americas=count(americas)
by id: egen Arab_States=count(arab_states)
by id: egen Asia_Pacific=count(asia_pacific)
by id: egen Europe=count(europe)
drop africa americas arab_states asia_pacific europe
egen africa=total(Africa)
egen americas=total(Americas)
egen arab_states=total(Arab_States)
egen asia_pacific=total(Asia_Pacific)
egen europe=total(Europe)
drop id Africa Americas Arab_States Asia_Pacific Europe
keep if _n==1
*This calculation assumes a VC cover a region only ONE time (NOT as many times as countries/territories are said to be covered in a region)
}
*Number of regions covered by VCs with REGIONAL scope
	list africa americas arab_states asia_pacific europe
	graph bar (mean) africa americas arab_states asia_pacific europe, percentage blabel(total)

*Regions: one region per VC for NATIONAL OR LOCAL
quietly{
use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)
rename AY scope
replace scope = scope[_n-1] if missing(scope)
keep if scope=="NATIONAL_OR_LOCAL"
keep id scopes_text scope countriesiso3_text
order countriesiso3_text
merge m:1 countriesiso3_text using regions_UNDRR
drop if missing(id)
sort id
keep id scopes_text scope countriesiso3_text analysis_region unisdr_region_name
order countriesiso3_text analysis_region unisdr_region_name, last
gen africa = regexs(0) if regexm(unisdr_region_name, "Africa")
gen americas = regexs(0) if regexm(unisdr_region_name, "Americas")
gen arab_states = regexs(0) if regexm(unisdr_region_name, "Arab States")
gen asia_pacific = regexs(0) if regexm(unisdr_region_name, "Asia-Pacific")
gen europe = regexs(0) if regexm(unisdr_region_name, "Europe")
keep id scopes_text africa americas arab_states asia_pacific europe
sort id
by id: egen africac=count(africa) if africa=="Africa" & africa!=""
by id: egen americasc=count(americas) if americas=="Americas" & americas!=""
by id: egen arab_statesc=count(arab_states) if arab_states=="Arab States" & arab_states!=""
by id: egen asia_pacificc=count(asia_pacific) if asia_pacific=="Asia-Pacific" & asia_pacific!=""
by id: egen europec=count(europe) if europe=="Europe" & europe!=""
keep id scopes_text africac americasc arab_statesc asia_pacificc europec
bysort id: egen africacountry=mean(africac)
bysort id: egen americascountry=mean(americasc)
bysort id: egen arab_statescountry=mean(arab_statesc)
bysort id: egen asia_pacificcountry=mean(asia_pacificc)
bysort id: egen europecountry=mean(europec)
keep id scopes_text africacountry americascountry arab_statescountry asia_pacificcountry europecountry
sort id scopes_text
drop if missing(scopes_text)
gen africa = africacountry
*replace africa = 1 if missing(africacountry) & regexm(scopes_text, "Africa")
gen americas = americascountry
*replace americas = 1 if missing(americascountry) & regexm(scopes_text, "Americas")
gen arab_states = arab_statescountry
*replace asia = 1 if missing(asiacountry) & regexm(scopes_text, "Asia")
gen asia_pacific = asia_pacificcountry
*replace europe = 1 if missing(europecountry) & regexm(scopes_text, "Europe")
gen europe = europecountry
*replace oceania = 1 if missing(oceaniacountry) & regexm(scopes_text, "Oceania")
keep id africa americas arab_states asia_pacific europe
by id: egen Africa=count(africa)
by id: egen Americas=count(americas)
by id: egen Arab_States=count(arab_states)
by id: egen Asia_Pacific=count(asia_pacific)
by id: egen Europe=count(europe)
drop africa americas arab_states asia_pacific europe
egen africa=total(Africa)
egen americas=total(Americas)
egen arab_states=total(Arab_States)
egen asia_pacific=total(Asia_Pacific)
egen europe=total(Europe)
drop id Africa Americas Arab_States Asia_Pacific Europe
keep if _n==1
*This calculation assumes a VC cover a region only ONE time (NOT as many times as countries/territories are said to be covered in a region)
}
*Number of regions covered by VCs with NATIONAL OR LOCAL scope
	list africa americas arab_states asia_pacific europe
	graph bar (mean) africa americas arab_states asia_pacific europe, percentage blabel(total)

*How many cases of VCs selecting only regions
quietly{
use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)
rename AY scope
keep id scopes_text scope countriesiso3_text
drop if missing(scopes_text)
keep if scope=="REGIONAL"
keep if countriesiso3_text==""
drop countriesiso3_text
}
*All VCs that having regional scope, only selected region names (without specifying any country)
	list id scopes_text
quietly{
gen africa = regexs(0) if regexm(scopes_text, "Africa")
gen americas = regexs(0) if regexm(scopes_text, "Americas")
gen asia = regexs(0) if regexm(scopes_text, "Asia")
gen europe = regexs(0) if regexm(scopes_text, "Europe")
gen oceania = regexs(0) if regexm(scopes_text, "Oceania")
sort id
by id: egen africac=count(africa) if africa=="Africa" & africa!=""
by id: egen americasc=count(americas) if americas=="Americas" & americas!=""
by id: egen asiac=count(asia) if asia=="Asia" & asia!=""
by id: egen europec=count(europe) if europe=="Europe" & europe!=""
by id: egen oceaniac=count(oceania) if oceania=="Oceania" & oceania!=""
egen Africa=total(africac)
egen Americas=total(americasc)
egen Asia=total(asiac)
egen Europe=total(europec)
egen Oceania=total(oceaniac)
keep Africa Americas Asia Europe Oceania
keep if _n==1
}
*Number of times a region was selected by a VC with regional scope (cases where only region was selected without specifying the name of a country)
	list Africa Americas Asia Europe Oceania
