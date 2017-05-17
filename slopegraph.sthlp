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
{synopt:{opt label}}Adds labels with the the number of links and percentage of links to each Event and Response{p_end}
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
{cmd:slopegraph} produces a "slope graph" popularised by Edward Tufte. As default it requires "long" data where each case is an "Event" (appearing on the left-hand-side) and "Response" (appearing on the righ-hand-side) pair.  It will then calculate the number of links for each Event-Response pair.  It is also possible to supply "wide" data, where each case is a unique Event-Response pair, with the number of links specified in a third variable.

{pstd}
A range of options allow the user to customise the appearance of the slope graph produced.

{marker options}{...}
{title:Options}

{dlgtab:Required}

{phang}
{opt event(varname)} This specifies the variable containing the values for the left-hand-side.  It should either contain strings, or be integers representing sequentially-numbered categories with value labels applied.

{phang}
{opt response(varname)} This specifies the variable containing the values for the right-hand-side.  It should either contain strings, or be integers representing sequentially-numbered categories with value labels applied.


{dlgtab:Optional}

{phang}
{opt yscale()} Specifies the maximum range of the y-axis, and can be used to stretch the graph vertically.

{phang}
{opt xscale()} Specifies the maximum range of the x-axis, and can be used to stretch the graph horizontally.

{phang}
{opt label()} Appends the total number of links and percentage of links to each value label for both Events and Responses.  It can only be used if the data is supplied in "long" format (i.e. without using the collapsed option)

{phang}
Additional options still to be documented ...

{marker remarks}{...}
{title:Remarks}

{pstd}


{marker examples}{...}
{title:Examples}

{pstd}





