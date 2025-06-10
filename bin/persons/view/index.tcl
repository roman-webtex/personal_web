#
# core/index controller
#
::oo::class create persons_view_index {
    superclass ::request::core_block    

    constructor {} {
        my variable templatePath
        next
        set templatePath [file join $::rootDir templates persons]
    }
}
