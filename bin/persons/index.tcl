#
# core/index controller
#
::oo::class create persons_index {
    variable workDir
    
    constructor {} {
        set workDir [file join $::workingDir $::request::module]

        set blockClassFileName [file join $workDir view index.tcl]
        source $blockClassFileName
        set ::request::blockClass [persons_view_index new]
        
        set modelClassFileName [file join $workDir model persons.tcl]
        source $modelClassFileName
        set ::request::modelClass [persons_model_persons new]
    }
    
    method index {} {
        $::request::blockClass render
    }
    
    method datacheck {} {
        set params [string map {: " " , " "} [::rivet::raw_post]]

        foreach {key value} [lindex $params 0] {
            set $key [string trimleft $value "_"]
        }
        $::request::modelClass runQuery "update $::dbpersons_table_name set online=$state where s_nom=$id"
    }
}
