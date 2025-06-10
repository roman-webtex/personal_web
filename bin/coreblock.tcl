::oo::class create core_block {

    variable rootTemplatePath
    variable templatePath
    variable session
    variable showSearch
    variable templates
    variable activeModules
    
    constructor {} {
        set rootTemplatePath [file join $::rootDir templates root]
        set templatePath [file join $::rootDir templates root]
        set session [$::request::coreSession getSession]
        set doc [dom parse [tDOM::xmlReadFile [file join $::rootDir bin modules.xml]]]
        set root [$doc documentElement]
        set activeModules [$root getElementsByTagName modules]
        set showSearch false
        dict set templates body "body"
    }

    method render {{block_name index}} {
        if {[dict exists $templates $block_name]} {
            set block_name [dict get $templates $block_name]
        }

        set templateFileName [file join $templatePath $block_name.rvt]
        set rootTemplateFileName [file join $rootTemplatePath $block_name.rvt]
        
        if {[catch {open $templateFileName} html]} {
            if {[catch {open $rootTemplateFileName} html]} {
                puts "Invalid block template $templateFileName"
            } else {
                close $html
                puts [::rivet::parse $rootTemplateFileName]
            }
        } else {
            close $html
            puts [::rivet::parse $templateFileName]
        }
    }
    
    method showSearch {} {
        return $showSearch
    }

    method getSearchUrl {} {
        return "#"
    }

    method getBlock {block_name} {
        my render $block_name
    }
    
    method getSessionData {key} {
        return [$::request::coreSession getData $key]
    }
    
    method isMessage {} {
        if {[dict get $session message error] != "" || [dict get $session message success] != ""} {
            return 1
        } else {
            return 0
        }
    }
    
    method getMessageType {} {
        if {[dict get $session message error] != ""} {
            return "danger"
        } elseif {[dict get $session message success] != ""} {
            return "success"
        }
    }
    
    method getMessageText {} {
        if {[my getMessageType] == "danger"} {
            set message [dict get $session message error]
        } else {
            set message [dict get $session message success]
        }        
        $::request::coreSession clearMessages
        return $message
    }
    
    method isLoggedOn {} {
        if {[dict get $session logged] == 1} {
            return true
        }
        return false
    }
    
    method convert {text} {
        return [encoding convertto utf-8 $text]
    }
    
    method getPageNom {} {
        if {[set page [$::request::coreSession getData pageNom]] == "" } {
            set page 1
        }
        return $page
    }
    
    method getLastPage {} {
        return [$::request::coreSession getData lastPage]
    }

    method getMainMenuItems {} {
        ::rivet::load_env env 
        set currentUrl [lindex [split [array get env REQUEST_URI] /] 1]
        set accessUrl [split [$::request::coreSession getData urls] ,]
        foreach item [$activeModules childNodes] {
            if {[my isLoggedOn] && [lsearch $accessUrl [$item getAttribute url]] != -1} {
                lappend mainMenu [$item getAttribute url]
                lappend mainMenu [$item getAttribute title]
                lappend mainMenu [expr {"/$currentUrl" == [$item getAttribute url] ? "active" : ""}]
            } elseif {[$item getAttribute url] == "/"} {
                lappend mainMenu [$item getAttribute url]
                lappend mainMenu [$item getAttribute title]
                lappend mainMenu [expr {"/$currentUrl" == [$item getAttribute url] ? "active" : ""}]
            }
        }
        return $mainMenu
    }
}