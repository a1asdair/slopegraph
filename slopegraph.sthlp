{smcl}
{* *! version 1.2.1  07mar2013}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:slopegraph} {hline 2} Generate a slope graph linking two sets of categories.


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:slopegraph}
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}

{syntab:Required}
{synopt:{opt event(varname)}}This is the variable for the left-hand-side{p_end}
{synopt:{opt response(varname)}}This is the variable for the right-hand-side{p_end}


{syntab:Optional}
{synopt:{opt yscale(integer)}}The maximum range of the y-axis; stretches the graph vertically{p_end}
{synopt:{opt xscale(integer)}}The maximum range of the x-axis; stretches the graph horizontally{p_end}
{synopt:{opt mthick(integer)}}The maximum line thickness for the graph lines{p_end}
{synopt:{opt collapsed}}Signals that the dataset has already been collapsed{p_end}
{synopt:{opt equal}}Forces the connecting lines to be equal thickness{p_end}
{synopt:{opt number}}Numbers the labels for the Event and Response categories{p_end}
{synopt:{opt color(event | response | links)}}specifies the method of colring the lines{p_end}
{synopt:{opt links(varname)}}Specifies a variable containing the number of links (required with pre-collapsed data){p_end}
{synopt:{opt saving()}}Allows a path to be specified to save the graph{p_end}
{synopt:{opt eorder(numlist)}}Specifies a manual order for the Events{p_end}
{synopt:{opt rorder(numlist)}}Specifies a manual order for the Responses{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}


{marker description}{...}
{title:Description}

{pstd}
{cmd:progressbar} displays a progress bar for use in loops or repeated tasks.  It is able to track the progress of nested loops incorporating both foreach and forvalues loops.  It can also be used outside of loops where the number of tasks is known.

{pstd}
{cmd:progressbar} should be called once before the repeated tasks begin to set up the tracking using the init option.  It can then be called each time the progress bar needs to be updated and displayed.  Options allow the display of the progress bar to be customised, and it can also estimate the time to completion.


{marker options}{...}
{title:Options}

{dlgtab:Initialisation}

{phang}
{opt init} This option must be specified when the command is called before the loops begin. It allows the calculating of the number of iterations expected in the loops.

{phang}
{opt type()} This indicates the number and type of nested loops.  There are two types of loop supported:
v	forvalues
e 	foreach
Specify in order the types of nested loop e.g. "e v v"
Any number of forvalues loops are supported; up to 10 nested foreach loops are supported

{phang}
{opt start()} List the starting values for each of the forvalues loops
e.g. 1 1 3

{phang}
{opt end()} list the ending value for each of the forvalues loops
e.g. 10 100 6

{phang}
{opt step()} Specify the step values for each of the forvalue loops
If they are all 1, then this option can be omitted, otheriwse it must be specified
e.g. 2 1 1

{phang}
{opt list#()} Include the list for each of the foreach loops in turn, where # should be 1 for the first list, 2 for the second list, etc.  progressbar supports up to 10 nested foreach loops.

{phang}
{opt time()}
This option needs to be specified in both the initiation and looping commands.  Here it records the start time of the looped tasks.


{phang}
{opt width()}
Allows the user to specify the width of the bar displayed in characters.  The progress bar will be scaled when displayed to fit within the character limit.  This is useful when the width of the dispaly is limited, or when the progress bar needs to fit with other output being displayed. The default is 80 characters.

{phang}
{opt loud} This option prevents the -progressbar- from clearing the screen, allowing the output to be preserved.

{phang}
{opt display} This option displays the progress bar without incrementing the counter.

{phang}
{opt time} This option needs to be specified in both the initiation and looping commands for it to work. It estimates the remaining time for the loop, assuming constant runtimes.


{marker remarks}{...}
{title:Remarks}

{pstd}
While {cmd:progressbar} will add slightly to runtime, it is helpful to be able to estimate when an intensive loop will finish.


{marker examples}{...}
{title:Examples}

{pstd}
Before each loop (or set of nested loops), {cmd:. progressbar} must be called  with the option init, along with the specifications of the loops to be carried out. 

{pstd}
Initialise a simple loop from 1 to 10

{phang}{cmd:. progressbar , init type(v) start(1) end(10) step(1)}{p_end}

{pstd}
Initialise a simple loop from 1 to 10 including a timer

{phang}{cmd:. progressbar , init type(v) start(1) end(10) time}{p_end}

{pstd}
Initialise a complicated loop involving two forvalues and two foreach loops of different sizes

{phang}{cmd:. progressbar , init type(v e v e) start(1 5) end(10 25) step(1 5) list1(abc def ghi) list2(a b c d)}{p_end}

{p 4 6 2}

{pstd}
During a loop (or set of nested loops), {cmd:. progressbar} should be called each time the progress bar should be displayed.  {cmd:. progressbar} should be called once at the nested loops deepest point (i.e. inside all the loops).

{pstd}
Display a progress bar during a loop

{phang}{cmd:. progressbar , }{p_end}

{pstd}
Display a progress bar during a loop with a timer

{phang}{cmd:. progressbar , time }{p_end}

{pstd}
Display a progress bar that is 100 characters wide

{phang}{cmd:. progressbar , width(100)}{p_end}

{p 4 6 2}

{pstd}
A full example of using progressbar with a forvalues loop.

{phang}{cmd:. progressbar , init type(v) start(1) end(100) time}{p_end}

{phang}{cmd:. forvalues i = 1(1)100 {c -(}}{p_end}
{phang}{cmd:. 	progressbar , time}{p_end}
{phang}{cmd:. 	generate x`i' = runiform()}{p_end}
{phang}{cmd:. {c )-}}{p_end}


{pstd}
A full example of using progressbar with nested loops.

{phang}{cmd:. local alist = "alpha beta gamma"}{p_end}

{phang}{cmd:. progressbar , init type(v e) start(1) end(100) list1(`alist') time}{p_end}

{phang}{cmd:. forvalues i = 1(1)100 {c -(}}{p_end}
{phang}{cmd:. 		foreach jj in `alist' {c -(}}{p_end}
{phang}{cmd:. 			progressbar , time}{p_end}
{phang}{cmd:. 			generate x`i'`jj' = runiform()}{p_end}
{phang}{cmd:. 		{c )-}}{p_end}
{phang}{cmd:. {c )-}}{p_end}




