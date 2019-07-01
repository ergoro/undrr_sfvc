import excel "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\2019-04-06_published_commitments_Stata.xlsx", sheet("VC Export - Published") firstrow
save "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra\sfvc_data.dta", replace

cd "C:\Users\Erick Gonzales\Documents\UN\7_SFVC_Analysis_Report_2019\Others\Analysis_extra"

*Number of VCs
do sfvc_vc_1_howmany.do

*Geographic scope (Figure 3, Figure 6)
do sfvc_vc_2_geoscope.do

*Countries: All (Figure 8)
do sfvc_vc_3_countries_all.do

*Countries: Regional scope
do sfvc_vc_3_countries_regional.do

*Countries: National or local scope
do sfvc_vc_3_countries_natloc.do

*Regions: All (Figure 5)
do sfvc_vc_4_regions_all.do

*Regions: Regional scope (Figure 7)
do sfvc_vc_4_regions_regional.do

*Regions: National or local scope
do sfvc_vc_4_regions_natloc.do

*Regions UNDRR
do sfvc_vc_4_regions_undrr.do

*Compare countries covered by VCs with death toll and affected people (Figures 9, 10 and 11)
do sfvc_vc_5_death_affected.do

*Compare countries covered by VCs with death toll and affected people accounting for population size(Figures 12, 13 and 14)
do sfvc_vc_5_death_affected_pop.do

*Box: Philippines
do sfvc_vc_6_phl_priorities.do
do sfvc_vc_6_phl_targets.do
do sfvc_vc_6_phl_themes.do
do sfvc_vc_6_phl_hazards.do
do sfvc_vc_6_phl_sdgs.do








*ID fill
replace id = id[_n-1] if missing(id)
rename AY scope


	
*WHO
*Who are submitting commitments
preserve
quietly{
drop if missing(organizations_organizationname)
sort organizations_organizationname
quietly by organizations_organizationname:  gen dup = cond(_N==1,0,_n)
tabulate dup
}
	list organizations_organizationname dup organizations_organizationrole if dup>0
	tab organizations_organizationrole
drop if dup>1
	tab organizations_organizationrole
restore
	tab organizations_organizationcatego if organizations_organizationrole=="IMPLEMENTER"
	tab organizations_organizationcatego if organizations_organizationrole=="PARTNER"
*NGOs
preserve
keep if organizations_organizationcatego=="NGO" & organizations_organizationrole=="IMPLEMENTER"
list id
sort id
quietly by id:  gen dup = cond(_N==1,0,_n)
tabulate dup
drop if dup>1
	tab id
restore
preserve
keep if ///
id=="20190110_001" | ///
id=="20190121_002" | ///
id=="20190201_002" | ///
id=="20190205_002" | ///
id=="20190213_002" | ///
id=="20190214_001" | ///
id=="20190214_002" | ///
id=="20190214_003" | ///
id=="20190214_004" | ///
id=="20190219_001" | ///
id=="20190222_001" | ///
id=="20190228_002" | ///
id=="20190301_001" | ///
id=="20190305_002" | ///
id=="20190306_001" | ///
id=="20190308_001"
*sort id
*bysort id: list organizations_organizationname id if organizations_organizationcatego=="NGO" & organizations_organizationrole=="IMPLEMENTER"
list organizations_organizationname id if organizations_organizationcatego=="NGO" & organizations_organizationrole=="IMPLEMENTER"
tab selectedthemesorissues_keyword, sort
tab selectedhazards_keyword, sort
tab selectedpriorities_keyword, sort
tab selectedtargets_keyword, sort
tab selectedindicators_keyword, sort
tab budgetscale
tab scaleofbeneficiaries
tab securedbudgetsize, sort
tab selectedsdgs_keyword
*include duration once I have a formula for this
restore
tab organizations_organizationcountr if organizations_organizationcatego=="NGO" & organizations_organizationrole=="IMPLEMENTER", sort
*Government
list organizations_organizationname organizations_organizationcountr id if organizations_organizationcatego=="GOVERNMENTS" & organizations_organizationrole=="IMPLEMENTER"
list organizations_organizationname organizations_organizationcountr organizations_organizationcatego if ///
id=="20190205_002" | ///
id=="20190220_001" | ///
id=="20190305_006" | ///
id=="20190308_007"
*Organizations by scope
replace scope = scope[_n-1] if missing(scope)
tab organizations_organizationcatego
tab organizations_organizationcatego if scope=="GLOBAL"
list organizations_organizationname organizations_organizationcountr id if organizations_organizationcatego=="UN_AND_IO"
preserve
sort id
bysort id: list organizations_organizationname organizations_organizationcountr organizations_organizationcatego id if ///
id=="20190110_001" | ///
id=="20190203_001" | ///
id=="20190211_001" | ///
id=="20190214_002" | ///
id=="20190214_004" | ///
id=="20190307_002"
restore
tab organizations_organizationcatego if scope=="REGIONAL"
tab organizations_organizationcatego if scope=="NATIONAL_OR_LOCAL"

*Organizations per commitment
preserve
drop if missing(organizations_organizationname)
keep id organizations_organizationname organizations_organizationrole
drop if organizations_organizationrole=="PARTNER"
egen numorg=count(organizations_organizationname != ""), by(id)
sort id
quietly by id:  gen dup = cond(_N==1,0,_n)
drop if dup>1
egen avgnumorg=mean(numorg)
	list id numorg avgnumorg
	tabstat numorg, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	tab numorg
	*tabstat var1, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	*histogram var1
restore
preserve
drop if missing(organizations_organizationname)
keep id organizations_organizationname organizations_organizationrole
drop if organizations_organizationrole=="IMPLEMENTER"
egen numorg=count(organizations_organizationname != ""), by(id)
sort id
quietly by id:  gen dup = cond(_N==1,0,_n)
drop if dup>1
egen avgnumorg=mean(numorg)
	list id numorg avgnumorg
	tabstat numorg, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	tab numorg
	*tabstat var1, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	*histogram var1
restore
*joint better?
preserve
generate sdate=date(durationfrom, "YMD")
format %td sdate
generate edate=date(durationto, "YMD")
format %td edate
gen syr=year(sdate)
gen eyr=year(edate)
sum syr eyr
gen ddays=edate-sdate
gen dyears=ddays/365
drop if missing(organizations_organizationname)
keep id organizations_organizationname organizations_organizationrole dyears scaleofbeneficiaries budgetscale securedbudgetsize
egen numorg=count(organizations_organizationname != ""), by(id)
sort id
quietly by id:  gen dup = cond(_N==1,0,_n)
drop if dup>1
	tabstat numorg, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	tab numorg
	tabstat dyears if numorg==1, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	tabstat dyears if numorg>1, stat(mean sd min p50 max iqr cv skewness kurtosis n)
	tab scaleofbeneficiaries if numorg==1
	tab scaleofbeneficiaries if numorg>1
	tab budgetscale if numorg==1
	tab budgetscale if numorg>1
	tab securedbudgetsize if numorg==1
	tab securedbudgetsize if numorg>1

restore



*Networks
drop if missing(countriesiso3_text)
tab countriesiso3_text, sort
keep id title scope organizations_organizationrole organizations_organizationname countriesiso3_text
bysort id: list countriesiso3_text
merge m:1 countriesiso3_text using regions
drop if missing(id)
sort id
drop cca2 lang_key c_name analysis_region_id notify_ notify_unisdr_office_1_id _merge
tab countriesiso3_text, sort
bysort id: list countriesiso3_text if countriesiso3_text=="PHL" | countriesiso3_text=="JPN" | countriesiso3_text=="NPL" | countriesiso3_text=="KEN" | countriesiso3_text=="MMR" | countriesiso3_text=="PAk"
*focus on the Phillipines
keep if id=="20190308_001" | id=="20190306_001" | id=="20190219_001" | id=="20190301_001"
tab id selectedpriorities_keyword
tab id selectedtargets_keyword
*tab id selectedthemesorissues_keyword
by id: tab selectedthemesorissues_keyword
tab id selectedhazards_keyword
tab id selectedsdgs_keyword

*Strategic
**Priorities for action
tab selectedpriorities_keyword
replace scope = scope[_n-1] if missing(scope)
bysort scope: tab selectedpriorities_keyword


**Targets
tab selectedtargets_keyword
replace scope = scope[_n-1] if missing(scope)
bysort scope: tab selectedtargets_keyword

**Indicators
tab selectedindicators_keyword

*Themes and hazards
tab selectedthemesorissues_keyword, sort

*Hazards
tab selectedhazards_keyword, sort

*SDGs
tab selectedsdgs_keyword
tab selectedsdgs_keyword, sort

*duration
generate sdate=date(durationfrom, "YMD")
format %td sdate
generate edate=date(durationto, "YMD")
format %td edate
gen syr=year(sdate)
gen eyr=year(edate)
sum syr eyr
gen ddays=edate-sdate
gen dyears=ddays/365
tabstat dyears, by(scope) stat(mean sd min p50 max iqr cv skewness kurtosis n)
egen numorg=count(organizations_organizationname != "") if organizations_organizationrole=="IMPLEMENTER", by(id)
egen numopartner=count(organizations_organizationname != "") if organizations_organizationrole=="PARTNER", by(id)
bysort id: egen avgopartner=mean(numopartner)
drop if organizations_organizationrole!="IMPLEMENTER"
replace scope = scope[_n-1] if missing(scope)
list title organizations_organizationname numorg avgopartner dyears if scope=="GLOBAL"

*good practices
tab selectedtargets_keyword
tab selectedsdgs_keyword
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG1"
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG11"
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG13"
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG1" & selectedsdgs_keyword=="SDG11"
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG1" & selectedsdgs_keyword=="SDG13"
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG11" & selectedsdgs_keyword=="SDG13"
list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG1" & selectedsdgs_keyword=="SDG11" & selectedsdgs_keyword=="SDG13"
list id scope selectedtargets_keyword if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG13" | selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG11" | selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG1"
generate sdate=date(durationfrom, "YMD")
format %td sdate
generate edate=date(durationto, "YMD")
format %td edate
gen ddays=edate-sdate
gen dyears=ddays/365
keep if id=="20190128_001" | id=="20190211_002" | id=="20190214_001" | id=="20190214_002" | id=="20190222_001" | id=="20190305_005" | id=="20190308_007"
bysort id: list id scope scaleofbeneficiaries 
bysort id: list organizations_organizationname organizations_organizationrole 
bysort id: list selectedpriorities_keyword selectedtargets_keyword selectedindicators_keyword selectedthemesorissues_keyword selectedhazards_keyword selectedsdgs_keyword 
bysort id: list dyears countriesiso3_text

replace scope = scope[_n-1] if missing(scope)
keep if scope=="NATIONAL_OR_LOCAL"
*list id if selectedtargets_keyword=="E" & selectedsdgs_keyword=="SDG1" | selectedsdgs_keyword=="SDG11" | selectedsdgs_keyword=="SDG13"
list id if selectedtargets_keyword=="E"

keep if id=="20190201_002" | id=="20190205_002" | id=="20190213_002" | id=="20190214_001" | id=="20190214_002" | id=="20190214_003" | id=="20190220_001" | id=="20190228_002" | id=="20190301_001" | id=="20190305_002" | id=="20190305_006" | id=="20190306_001" | id=="20190307_002" | id=="20190308_001" | id=="20190308_007" | id=="20190308_007"
keep id title organizations_organizationname organizations_organizationrole selectedpriorities_keyword selectedtargets_keyword selectedindicators_keyword selectedthemesorissues_keyword selectedhazards_keyword selectedsdgs_keyword  dyears countriesiso3_text
export excel using test_excel

*deliverables
keep id deliverables_deliverabletitle deliverables_deliverabledescript deliverables_deliverablestatus deliverables_deliverydate deliverables_deliverablecomplete deliverables_filenameofoutput deliverables_deliverablelink deliverables_deliverableprivate deliverables_getdeliverableoutpu
egen numdev=total(!missing(deliverables_deliverydate)), by(id)
egen numdevcom=total(deliverables_deliverablecomplete), by(id)
preserve
sort id
quietly by id:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup
tab numdev 
sum numdev
tab numdevcom
sum numdevcom
restore
tab deliverables_getdeliverableoutpu

tab deliverables_deliverydate
generate ddate=date(deliverables_deliverydate, "YMD")
format %td ddate
gen dyear=year(ddate)
tab dyear

drop numdevcom
egen numdevcom=total(!missing(deliverables_deliverablecomplete)), by(id)

*indepth with target E
replace scope = scope[_n-1] if missing(scope)
keep if selectedindicators_keyword=="E1" | selectedindicators_keyword=="E2"
tab selectedindicators_keyword
bysort scope: tab selectedindicators_keyword

*Beneficiaries
tab scaleofbeneficiaries
format scaleofbeneficiariesother %12.0f
tab scaleofbeneficiariesother
format scaleofbeneficiariesother %12.0f
tabstat scaleofbeneficiariesother, stat(mean sd min p50 max iqr cv skewness kurtosis n)

*total number of beneficiaries
sort id
quietly by id:  gen dup = cond(_N==1,0,_n)
drop if dup>1
keep id scaleofbeneficiaries scaleofbeneficiariesother
tab scaleofbeneficiaries 
gen benef=.
replace benef=scaleofbeneficiariesother
replace benef=1500 if scaleofbeneficiaries=="F1000T2000"
replace benef=150 if scaleofbeneficiaries=="F100T200"
replace benef=350 if scaleofbeneficiaries=="F200T500"
replace benef=7500 if scaleofbeneficiaries=="F5000T10000"
replace benef=750 if scaleofbeneficiaries=="F500T1000"
egen totalbenef=total(benef)
format totalbenef %12.0f

*Budget size
tab budgetscale
replace scope = scope[_n-1] if missing(scope)
bysort scope: tab budgetscale

*Secured budget
tab securedbudgetsize
replace scope = scope[_n-1] if missing(scope)
bysort scope: tab securedbudgetsize

*Donors
tab donors_donorcategory

*email from published commitments
list persons_email if persons_role=="MAIN_FOCAL_POINT"




*Scopes
gen wherenum = .
quietly forval j = 0/9 {
replace wherenum = min(wherenum, strpos(scopes_text, "`j'")) if strpos(scopes_text, "`j'")
}
gen scope = substr(scopes_text, 1, wherenum - 1)
split scope, parse(- ,)
drop wherenum
*l scope?, sep(0)
