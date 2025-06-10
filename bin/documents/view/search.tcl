#
# core/index controller
#
::oo::class create documents_view_search {
    superclass ::request::core_block    
    
    constructor {} {
        my variable showSearch
        my variable templatePath
        my variable templates
        next
        dict set templates body "search"
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
