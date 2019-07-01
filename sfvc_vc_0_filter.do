*email adresses of focal points (main and others) of published VCs
*use "sfvc_data.dta", clear
replace id = id[_n-1] if missing(id)

gen long obsno=_n
foreach v of var commitmentfirstpublicationdate{
quietly count if missing(`v')
if r(N) > 0 capture noisily stripolate `v' obsno, groupwise by(id) generate(`v'_2)
}

replace commitmentfirstpublicationdate=commitmentfirstpublicationdate_2
drop obsno commitmentfirstpublicationdate_2

drop if missing(commitmentfirstpublicationdate)


*to send only main focal points
replace title = title[_n-1] if missing(title)
keep if persons_role=="MAIN_FOCAL_POINT"


drop if missing(persons_role)
list id persons_role persons_email




foreach v of var commitmentfirstpublicationdate{
quietly count if missing(`v')
if r(N) > 0 capture noisily mipolate `v' obsno, groupwise by(id) generate(`v'_2)
}
list id commitmentfirstpublicationdate commitmentfirstpublicationdate_2
drop commitmentfirstpublicationdate_2






gen num=_n


bysort id num: replace commitmentfirstpublicationdate = commitmentfirstpublicationdate[_n-1] if missing(commitmentfirstpublicationdate)

list commitmentfirstpublicationdate
foreach var in `varlist' {
bysort id: mipolate `var' id, gen(n`var') nearest
replace `var'=n`var' if `var'==.
drop n`var'
} 


foreach val in commitmentfirstpublicationdate {
bysort id: mipolate `commitmentfirstpublicationdate' id, gen(n`commitmentfirstpublicationdate') nearest
replace `commitmentfirstpublicationdate'=n`commitmentfirstpublicationdate' if `commitmentfirstpublicationdate'==.
drop n`commitmentfirstpublicationdate'
} 


bysort id: carryforward commitmentfirstpublicationdate, gen(fpubdate)





sort id commitmentfirstpublicationdate



replace commitmentfirstpublicationdate = commitmentfirstpublicationdate[_n-1] if missing(commitmentfirstpublicationdate) & _n > 1

replace commitmentfirstpublicationdate = commitmentfirstpublicationdate[_n-1] if missing(commitmentfirstpublicationdate) & missing(commitmentfirstpublicationdate[_n-1])


by id: replace commitmentfirstpublicationdate = commitmentfirstpublicationdate[_n-1] if missing(commitmentfirstpublicationdate) & commitmentfirstpublicationdate[_n-1]=!""




by id: replace commitmentfirstpublicationdate = commitmentfirstpublicationdate[_n-1] if missing(commitmentfirstpublicationdate) 

drop if missing(commitmentfirstpublicationdate)
tab id


tab commitmentfirstpublicationdate




gen wherenum = .
quietly forval j = 0/9 {
replace wherenum = min(wherenum, strpos(scopes_text, "`j'")) if strpos(scopes_text, "`j'")
}
gen scope = substr(scopes_text, 1, wherenum - 1)
split scope, parse(- ,)
drop wherenum
