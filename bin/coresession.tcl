#
# CoreSession
#
::oo::class create core_session {

    variable session
    variable lifeDays
    variable sessionId
    
    constructor {} {
        set lifeDays 365
        set sessionId [::rivet::cookie get session]
        dict set session message success ""
        dict set session message error ""

        if {$sessionId == ""} {
            set sessionId [::uuid::uuid generate]
            dict set session id $sessionId
            dict set session logged 0
            ::rivet::cookie set session $sessionId -path "cray.tyl.a7015.afu" -days $lifeDays
            set sessionFileName [file join $::rootDir var session $sessionId]
            set sessionFile [open $sessionFileName w]
            puts $sessionFile $session
            close $sessionFile
        } else {
            set sessionFileName [file join $::rootDir var session $sessionId]
            if {[catch {open $sessionFileName r} sessionFile]} {
                ::rivet::cookie unset session
                set sessionId [::uuid::uuid generate]
                dict set session id $sessionId
                dict set session logged 0
                ::rivet::cookie set session $sessionId -path "cray.tyl.a7015.afu" -days $lifeDays
                set sessionFileName [file join $::rootDir var session $sessionId]
                set sessionFile [open $sessionFileName w]
                puts $sessionFile $session
                close $sessionFile
            } else {
                gets $sessionFile session
                close $sessionFile
                ::rivet::cookie unset session
                ::rivet::cookie set session $sessionId -path "cray.tyl.a7015.afu" -days $lifeDays
            }
        }
    }
    
    method setIsLoggedOn {logged} {
        dict set session logged $logged
        my save
    }
    
    method logout {} {
        dict set session logged 0
        dict set session urls ""
        my save
    }
    
    method getSession {} {
        return $session
    }
    
    method addSuccess {message} {
        dict set session message success $message
        my save
    }
    
    method addError {message} {
        dict set session message error $message
        my save
    }
    
    method setData {key value} {
        dict set session $key $value
        my save
    }
    
    method getData {key} {
        set key [string trim $key]
        if {[dict exists $session $key]} {
            return [dict get $session $key]
        } else {
            return ""
        }
    }
    
    method clearMessages {} {
        dict set session message error ""
        dict set session message success ""
        my save
    }
    
    method save {} {
        set sessionFileName [file join $::rootDir var session $sessionId]
        set sessionFile [open $sessionFileName w+]
        puts $sessionFile $session
        close $sessionFile
    }
}
