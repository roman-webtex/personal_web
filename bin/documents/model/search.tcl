#
# core/index controller
#
::oo::class create documents_model_search {
    superclass ::request::core_model    
    
    constructor {} {
        next
    }
    
    method getCollection {} {
        my variable db_table_name

        ::rivet::load_response params
        set s ""

        if {[array names params -glob s] != ""} {
            set s $params(s)
        }

        if {[set year [$::request::coreSession getData workingYear]] == ""} {
            set year 2024
        }
        set db_table_name catalog_$year

        set addWhere "1"

        set recordSet [::webapp::mysql::getRecordSetWithQuery "*" $db_table_name "$addWhere order by r_nomer"]
        set itemList [my search $recordSet $s]
        
        if {$itemList != 0} {
            return [::webapp::mysql::getRecordSetWithQuery "*" $db_table_name "entity_id in ($itemList) order by r_nomer"]
        } else {
            return $recordSet
        }
    }
    
    method search {dataSet searchVariable} {
        if {[string trim $searchVariable] == ""} {
            return 0
        }

        set searchList [split $searchVariable ";"]

        set result {}

        foreach item $dataSet {
            foreach value $item {
                foreach sval $searchList {
                    if {[regexp -nocase -- "[string trim $sval]" $value] > 0} {
                        lappend result [lindex $item 0]
                        lappend result ","
                    }
                }
            }
        }
        
        if {[llength $result] > 0} {
            return [lrange $result 0 end-1]
        } else {
            return 0
        }
    }
}
