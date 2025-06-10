#
# core/index controller
#
::oo::class create documents_view_index {
    superclass ::request::core_block    

    constructor {} {
        my variable showSearch
        my variable templatePath
        next
        set templatePath [file join $::rootDir templates documents]
        set showSearch true
    }

    method getSearchUrl {} {
        return "/documents/search"
    }
    
    method getWorkingYear {} {
        return [expr {[$::request::coreSession getData workingYear] == "" ? [clock format [clock seconds] -format "%Y"] : [$::request::coreSession getData workingYear]}]
    }
}
