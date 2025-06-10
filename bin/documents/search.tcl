#
# core/index controller
#
::oo::class create documents_search {
    variable workDir
    
    constructor {} {
        set workDir [file join $::workingDir $::request::module]

        set blockClassFileName [file join $workDir view search.tcl]
        source $blockClassFileName
        set ::request::blockClass [documents_view_search new]
        
        set modelClassFileName [file join $workDir model search.tcl]
        source $modelClassFileName
        set ::request::modelClass [documents_model_search new]
    }
    
    method index {} {
        $::request::blockClass render
    }
}
