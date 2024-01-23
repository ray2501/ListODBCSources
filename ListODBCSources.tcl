#!/usr/bin/env tclsh

#
# A simple program to list ODBC Data Sources by Tcl/Tk, version 0.1
#

package require Tcl 8.6
package require Tk
package require tablelist
package require tdbc::odbc

if { [catch {package require awthemes}]==0} {
    ttk::setTheme "awlight"
}

wm geometry . 600x400+100+100

frame .menubar -relief raised -bd 2
pack .menubar -side top -fill x

ttk::menubutton .menubar.file -text File -menu .menubar.file.menu
menu .menubar.file.menu -tearoff 0
.menubar.file.menu add command -label Quit -command Exit
ttk::menubutton .menubar.help -text Help -menu .menubar.help.menu
menu .menubar.help.menu -tearoff 0
.menubar.help.menu add command -label About -command HelpAbout
pack .menubar.file .menubar.help -side left

# Contextual Menus
menu .menu
foreach i [list Exit] {
    .menu add command -label $i -command $i
}

if {[tk windowingsystem]=="aqua"} {
    bind . <2> "tk_popup .menu %X %Y"
    bind . <Control-1> "tk_popup .menu %X %Y"
} else {
    bind . <3> "tk_popup .menu %X %Y"
}

# Get data sources list and list
tablelist::tablelist .t -columns {0 "DSN" 0 "Driver"} -stretch all \
    -background white -font {Helvetica -14}
pack .t -fill both -expand 1 -side top
set sources [::tdbc::odbc::datasources]
foreach {dsn driver} $sources {
   .t insert end [list $dsn $driver]
}

# Handle special key
bind all <F1> HelpAbout

#=================================================================
# Event Handler
#=================================================================

proc Exit {} {
    set answer [tk_messageBox -message "Really quit?" -type yesno -icon warning]
    switch -- $answer {
        yes exit
    }
}

proc HelpAbout {} {
    set ans [tk_messageBox -title "About" -type ok -message \
    "Using TDBC-ODBC to list ODBC Data Sources." ]
}
