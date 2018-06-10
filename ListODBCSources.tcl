#!/usr/bin/tclsh
#
# A simple program to list ODBC data sources by Tcl/Gnocl, version 0.1
#

package require Gnocl
package require tdbc::odbc

set menu [gnocl::menu]
$menu add [gnocl::menuSeparator]
$menu add [gnocl::menuItem -text "%#Quit" -onClicked exit \
      -tooltip "Quit program"]

set file [gnocl::menuItem -text "%__File" -submenu $menu]

set toolBar [gnocl::toolBar -style both]
$toolBar add item -text "%#Quit" -tooltip "Tooltip Quit" \
      -onClicked exit

set menu [gnocl::menu]
$menu add [gnocl::menuItem -text "%__About" \
            -tooltip "Show about dialog" \
            -onClicked {gnocl::aboutDialog \
            -programName "ListODBCSources" \
            -version "Version 0.1"}]
set help [gnocl::menuItem -text "%__Help" -submenu $menu]
      

set box [gnocl::box -orientation vertical -borderWidth 0 -spacing 0]
set win [gnocl::window -child $box -title "List ODBC Sources" \
           -defaultWidth 800 -defaultHeight 600 -onDestroy { exit } ]
$box add [gnocl::menuBar -children [list $file $help]]
$box add $toolBar

set ::list [gnocl::list \
    -titles {"DSN" "driver"} \
    -types {string string}]

$box add $::list -fill {1 1} -expand 1

set sources [::tdbc::odbc::datasources]
foreach {dsn driver} $sources {
    $list add [list $dsn $driver] -singleRow 1 
}

# enter GTK+ main loop
gnocl::mainLoop

