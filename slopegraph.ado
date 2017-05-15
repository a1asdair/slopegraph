// slope graph
// (c) Alasdair Rutherford
// May 2017


// slopegraph


capture prog drop slopegraph

program slopegraph,

version 11
syntax [using/] , event(string) response(string) [yscale(integer 10) xscale(integer 10) mthick(integer 5) collapsed equal number color(string) links(string) saving(string) eorder(string) rorder(string) label debug] 


// Events (LHS)
// Response (RHS)


// Set up

	set more off

	if "`debug'" == "debug" {
		di "Starting up ..."
	}
	else {
		preserve
	}


// Load the dataset if needed

	if "`using'" != "" {
		use "`using'", clear
	}

	if "`debug'" == "debug" {
		di "Data ready"
	}

	
	
// Number the events

	capture confirm numeric variable `event'
    if _rc {
		// For string variables, encode them
		encode `event', gen(lhs)
		gen lhslabel = `event'
    }
	else {
		// For pre-coded variables, make sure to grab the labels
		gen lhs=`event'
		label values lhs `: value label `event''
		decode `event', gen(lhslabel)
	}

	capture confirm numeric variable `response'
    if _rc {
		// For string variables, encode them
		encode `response', gen(rhs)
		gen rhslabel = `response'
    }
	else {
		// For pre-coded variables, make sure to grab the labels
		gen rhs = `response'
		label values rhs `: value label `response''
		decode `response', gen(rhslabel)		
	}
	
	if "`number'" != "" {
		numlabel lhs rhs, add
	}
	
// Collapse the dataset if required	
	
		if "`collapsed'" == "" {	

			gen N = _N
			
			bysort lhs: egen countlhs = count(lhs)
			bysort rhs: egen countrhs = count(rhs)
		
			// For each event/response pair, count
			// Collapse to that count

			gen links=1
			collapse (count) links, by(lhs rhs lhslabel rhslabel N countlhs countrhs) //`event' `response')
		}		
		else {

			if "`links'" == "" {
				di "You must specify the variable containing the number of links if your dataset is already collapsed"
				exit
			}

			// This is the user-supplied variable that contains the number of links
			rename `links' links
			
		}


	if "`debug'" == "debug" {
		di "Prepare the plot settings ..."
	}		
		
		
// Think about Event order

	// Ranks the Events by the total number of links from them
	bysort lhslabel: egen totallinks = sum(links)
	egen lhsrank = group(totallinks lhslabel)
	
	// We now have to reverse this order to get it right
	quietly sum lhsrank
	local rmax = r(max)
	
	replace lhsrank = `rmax' + 1 - lhsrank
	
	if "`eorder'" != "" {
		local pp = 1
		foreach item in `eorder' {
			di "`item' will become `pp'"
			replace lhsrank = `pp' if lhs==`item'
			local pp = `pp' + 1
		}
	tab lhsrank	
	}
	
// Think about Response order

	gen rhsrank = rhs
	
	if "`rorder'" != "" {
		local pp = 1
		foreach item in `rorder' {
			di "`item' will become `pp'"
			replace rhsrank = `pp' if rhs==`item'
			local pp = `pp' + 1
		}
	tab rhsrank	
	}

	
// Think about scaling	
	
	// Scale the Events on the y-axis

	gen ylhs = (lhsrank / `rmax') * `yscale'
	
	// Scale the Responses on the y-axis
	quietly sum rhs
	local rhsmax = r(max)
	gen yrhs = (rhsrank/(`rhsmax' + 1)) * `yscale'

	// Scale the distance between Events and Responses on the x-axis
	gen xlhs = 1
	gen xrhs = `xscale'
	
	// Add extra room to the x-axis so that the Event and Response labels will fit
	local xrax = `xscale'*1.3
	local xlax = -`xscale'*0.3


// Think about line thickness

	quietly sum links
	local lmax = r(max)
	local lmin = r(min)

	// Allow for all lines to be equal thickness
	if "`equal'" != "" {
		gen thick = `mthick'
	}
	else {
		// Scale the thickness between 1 and the maximum
		gen linkspercent = (links - `lmin') / (`lmax' - `lmin')
		gen thick = round(linkspercent * `mthick')
	}
	
// Think about labelling

	if "`debug'" == "debug" {
		di "Labelling ..."
	}	

	if "`label'"!="" & "`collapsed'" == "" {
		gen percentlhs = round((countlhs/N)*100,0.1)
		replace lhslabel = lhslabel + " (n=" + string(countlhs) + "; " + string(percentlhs) + "%)"
		gen percentrhs = round((countrhs/N)*100,0.1)
		replace rhslabel = rhslabel + " (n=" + string(countrhs) + "; " + string(percentrhs) + "%)"
	}
	
	
	// This sort ensures that the first occurence below is the largest one
	// This is important so that the largest line doesn't overlap with the labels
	gsort - links

	// We only need to plot the Event and Response labels once; numbering the occurences
	// lets us plot just the first occurence for each Event and Response
	bysort lhslabel: egen plotlhs = seq()		
	bysort rhslabel: egen plotrhs = seq()	
	
	
// Think about Colour

	if "`debug'" == "debug" {
		di "Color ..."
	}	
	

	// Apply a greyscale color to each link
	// These are scaled across the range based on the user-selection
	// The default is monotone

	gen color=.

	// Color by Event
	if substr("`color'",1,1)=="e" {
		replace color = round((lhsrank / `rmax') * 14) + 1
	}
	
	// Color by Response	
	if substr("`color'",1,1)=="r" {
		replace color = round((rhs / `rhsmax') * 14) + 1
	}

	// Color by line thickness	
	if substr("`color'",1,1)=="l" {
		replace color = round((links / `lmax') * 14) + 1
	}
	
	// Default color if none specified
	replace color = 6 if color==.

	
	if "`debug'" == "debug" {
		di "Ready for the graph command ..."
	}	
	
// Build the graphing command
// This loops over each row of the dataset
	
	local rows = _N

	forvalues obs = 1(1)`rows' {

		// Extract the thickness for this case (only one obs)
		quietly sum thick if _n==`obs'
		local thickness =  r(mean)
		
		// Extract the color for this case (only one obs)		
		quietly sum color if _n==`obs'
		local color =  r(mean)
		
		// The macro slopes builds up the graphing command
		// It alternates between -pcspike- which draws the line, and two
		// -scatter- plots which round off the ends of the lines		
		local slopes = "`slopes' " + "(pcspike ylhs xlhs yrhs xrhs if _n==`obs', lwidth(`thickness') lcolor(gs`color') ) (scatter ylhs xlhs if _n==`obs', msize(`thickness') mcolor(gs`color') ) (scatter yrhs xrhs if _n==`obs', msize(`thickness') mcolor(gs`color') )"
	 
	} 

		if "`debug'" == "debug" {		
			di "`slopes'"
		}

// Sort out any last-minute graph options

	if "`saving'"!="" {
		local save = "saving(`saving')"
	}
		
		
		
		
// Finally, draw the graph		
	twoway  (scatter ylhs xlhs if plotlhs==1, mlabel(lhslabel) mlabcolor(gs1) mlabposition(9) mlabsize(vsmall) msize(`mthick') mcolor(white)) ///
			(scatter yrhs xrhs if plotrhs==1, mlabel(rhslabel) mlabcolor(gs1) mlabsize(vsmall) mcolor(white)  msize(`mthick') ) ///
			`slopes' , ///
			legend(off) graphregion(color(white)) xla(none) xsc(noline r(`xlax' `xrax')) xtitle("") ysc(r(0 .) reverse off) yla(, nogrid) ///
			`save'



end

















