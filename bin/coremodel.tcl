::oo::class create core_model {
    variable db_table_name
    
    constructor {} {
        set db_table_name ""
    }

    method runQuery {query} {
        return [::webapp::mysql::runQuery $query]
    }
    
    method getData {{what "*"} {where "1=1"}} {
        set query "select $what from $db_table_name where $where"
        return [my runQuery $query]
    }
}