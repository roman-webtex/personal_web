#
# core/index controller
#
::oo::class create persons_model_persons {
    superclass ::request::core_model    
    
    variable db_history
    
    constructor {} {
        my variable db_table_name
        next
        set db_table_name persons
        set db_history persons_history
        
    }
    
    method getCollection {} {
        my variable db_table_name
        return [::webapp::mysql::getRecordSetWithQuery "*" $db_table_name "s_nom > 0 order by s_nom"]
    }

    method getScanCollection {person} {
        return [::webapp::mysql::getRecordSetWithQuery "*" $db_history "person_id = $person and dod_inf != \"\" order by entity_id"]
    }
}
