package require md5crypt
package require uuid
package require json::write
package require tdbc
package require tdom

source $::rootDir/bin/init.tcl
source $::rootDir/bin/MysqlDb.tcl
source $::rootDir/bin/coreblock.tcl
source $::rootDir/bin/coresession.tcl
source $::rootDir/bin/coremodel.tcl

package require tdbc::$::db_engine

::oo::class create Dispatcher

::oo::define Dispatcher {
    variable ds
    
    constructor {} {
        set ds "/"
        set ::request::coreSession [::request::core_session new]
    }

    method dispatch {{sitePart ""}} {
        if {$sitePart == ""} {
            set sitePart "home/index/index"
        }
        
        set module [lindex [split $sitePart $ds] 0]
        set controller [lindex [split $sitePart $ds] 1]
        set action [string trimright [lindex [split $sitePart $ds] 2] "?"]
        
        if {$controller == ""} {
            set controller "index"
        }
        if {$action == ""} {
            set action "index"
        }
        
        set ::request::module $module

        set classFileName [file join $::workingDir $module $controller]
        source $classFileName.tcl
        
        set controllerInstance ${module}_${controller}
        set ::request::controller [$controllerInstance new]
        
        $::request::controller $action
    }
}