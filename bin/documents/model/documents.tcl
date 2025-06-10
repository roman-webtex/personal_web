#
# core/index controller
#
::oo::class create documents_model_documents {
    superclass ::request::core_model    
    
    constructor {} {
        next
        set ::request::rowsCount 20
    }
    
    method getCollection {} {
        my variable db_table_name

        if {[set year [$::request::coreSession getData workingYear]] == ""} {
            set year 2024
        }
        set db_table_name catalog_$year
        
        set first [expr {[$::request::coreSession getData pageNom] * $::request::rowsCount - $::request::rowsCount}]
        set count [my runQuery "select count(*) from $db_table_name"]
        set lastPage [expr { $count / $::request::rowsCount }]
        if {[expr { $count % $::request::rowsCount}] != 0} {
            incr lastPage
        }
        $::request::coreSession setData lastPage $lastPage
        set limit "limit $first, $::request::rowsCount"
        set addWhere 1
        return [::webapp::mysql::getRecordSetWithQuery "*" $db_table_name "$addWhere order by r_nomer $limit"]
    }
}
