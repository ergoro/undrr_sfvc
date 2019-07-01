use "sfvc_data.dta", clear

*Fill ID for every field
replace id = id[_n-1] if missing(id)

*This code filters data to show only published commitments (excluding those in draft, revision, etc.)
gen long obsno=_n
foreach v of var commitmentfirstpublicationdate{
quietly count if missing(`v')
if r(N) > 0 capture noisily stripolate `v' obsno, groupwise by(id) generate(`v'_2)
}
replace commitmentfirstpublicationdate=commitmentfirstpublicationdate_2
drop obsno commitmentfirstpublicationdate_2
drop if missing(commitmentfirstpublicationdate)
