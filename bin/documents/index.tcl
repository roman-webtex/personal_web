#
# core/index controller
#
::oo::class create documents_index {
    variable workDir
    
    constructor {} {
        set workDir [file join $::workingDir $::request::module]

        set blockClassFileName [file join $workDir view index.tcl]
        source $blockClassFileName
        set ::request::blockClass [documents_view_index new]
        
        set modelClassFileName [file join $workDir model documents.tcl]
        source $modelClassFileName
        set ::request::modelClass [documents_model_documents new]
    }
    
    method index {} {
        ::rivet::load_response params

        if {[array names params -glob year] != ""} {
            $::request::coreSession setData workingYear $params(year)
        }

        if {[array names params -glob p] != ""} {
            $::request::coreSession setData pageNom [set ::request::page $params(p)]
        } else {
            $::request::coreSession setData pageNom [set ::request::page 1]
        }
        
        $::request::blockClass render
    }
}
