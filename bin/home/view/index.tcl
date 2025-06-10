#
# core/index controller
#
::oo::class create home_view_index {
    superclass ::request::core_block
    
    variable templatePath
    
    constructor {} {
        my variable templatePath
        next
        set templatePath [file join $::rootDir templates home]
    }

}
