##
#
#
#
##
set ::rootDir [pwd]

if {![file exist "$::rootDir/bin/dispatcher.tcl"]} {
    puts "<style>"
    puts [::rivet::include $::rootDir/script/css/main/empty-styles.css]
    puts "</style>"
    puts [::rivet::xml "Error! Can't initialize main application." [list div class "noapp-outer"] [list div class "noapp-inner"] [list h3 class "noapp-h3"]]
    ::rivet::abort_page
}

source "$::rootDir/bin/dispatcher.tcl"

set ::request::app [Dispatcher new]

::rivet::load_env env
#foreach {key value} [array get env] {
#    puts "$key :  $value<br/>"
#}      

set sitePart [lindex [split [string trimleft [lindex [array get env REQUEST_URI] 1] "/"] "?"] 0]

$::request::app dispatch $sitePart

