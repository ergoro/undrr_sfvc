quietly{
use "sfvc_data.dta", clear
drop if missing(id)
sort commitmentfirstpublicationdate
generate ni=_n
generate nt=_N
}
	list id title commitmentfirstpublicationdate
	sum ni nt
