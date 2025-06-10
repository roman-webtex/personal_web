#
# core/index controller
#
::oo::class create home_index {
    variable workDir
    
    constructor {} {
        set workDir [file join $::workingDir $::request::module]
    }
    
    method index {} {
        set blockClassFileName [file join $workDir view index.tcl]
        source $blockClassFileName
        set ::request::blockClass [home_view_index new]
        $::request::blockClass render
    }
    
    method login {} {
        set params [string map {: " " , " "} [::rivet::raw_post]]

        foreach {key value} [lindex $params 0] {
            set $key $value
        }
        
        set usersData [my getUsersFile r]

        $::request::coreSession setIsLoggedOn 0
        $::request::coreSession addError "Невірне ім'я користувача або пароль"

        while {[gets $usersData line] >= 0} {
            set line [split [string trimleft $line] :]
            if {[lindex $line 0] == $user && [lindex $line 1] == $pass} {
                $::request::coreSession setIsLoggedOn 1
                $::request::coreSession setData urls [lindex $line 2]
                $::request::coreSession addSuccess "Ви зареєстровалися у системі"
                $::request::coreSession addError ""
            }
        }
        close $usersData
    }
    
    method logout {} {
        $::request::coreSession logout
    }

    method getUsersFile {mode} {
        puts [file join $::rootDir etc passwd]
        if {[catch {open [file join $::rootDir etc passwd] $mode} usersData]} {
            $::request::coreSession addError "Невірне ім'я користувача або пароль"
        }
        return $usersData
    }
    
}
